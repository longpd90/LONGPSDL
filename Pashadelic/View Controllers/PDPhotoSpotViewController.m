//
//  PDPhotoDetailViewController.m
//  Pashadelic
//
//  Created by LongPD on 6/2/14.

#import "PDPhotoSpotViewController.h"
#import "UIImage+Extra.h"
#import "UIImage+MTFilter.h"
#import "UIButton+FontAwesome.h"
#import "PDEditPhotoViewController.h"
#import "PDTagViewController.h"
#import <Social/Social.h>
#import "PDPOIItemViewController.h"
#import "PDPhotoTipsView.h"
#import "PDCommentCell.h"
#import "PDServerPhotoNearbyLoader.h"
#import "PDAppRater.h"
#import "PDCommentsViewController.h"
#import "PDLocationViewController.h"

#define kPDPhotoSpotBackgroundColor             [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]
#define kPDPhotoPageTagBackgroudColor           [UIColor colorWithRed:237/255.0 green:242/255.0 blue:245/255.0 alpha:1]

@interface PDPhotoSpotViewController ()
@property (assign, nonatomic) int tipsCount;
@property (assign, nonatomic) float heighTableView;
@property (assign, nonatomic) NSUInteger currentPhotoIndex;
@property (assign, nonatomic, getter = isBottomSlideViewVisible) BOOL bottomSlideViewVisible;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (assign, nonatomic) float tagViewHeight;
@end

@implementation PDPhotoSpotViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    self.navigationItem.titleView = self.navigationBarView;
    addCommentLinesNumber = 1;
	[self initInterface];
	self.loadingView = nil;
	if (self.photo) {
		self.photo = self.photo;
	}
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoStatusChanged:)
                                                 name:kPDPhotoStatusChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	if (self.fullscreenPhotoBrowserShown) {
		self.fullscreenPhotoBrowserShown = NO;
		if (self.photoBrowser.currentPageIndex != self.currentPhotoIndex) {
            self.photo = [self.photosDataSource photoAtIndex:self.photoBrowser.currentPageIndex forPhotoViewController:self];
        }
		self.photoBrowser = nil;
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[SDImageCache sharedImageCache] removeImageForKey:self.photo.fullImageURL.absoluteString fromDisk:NO];
	[super viewWillDisappear:animated];
	[self.photoImage sd_cancelCurrentImageLoad];
	[self.photoImage hideActivity];
}

- (void)dealloc
{
	self.photoBrowser = nil;
	self.tipDescription = nil;
	self.photosTableView = nil;
	self.collectionsViewController = nil;
	self.photoViewController = nil;
}

#pragma mark - Public

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)itemWasChanged:(NSNotification *)notification
{
	[super itemWasChanged:notification];
	NSDictionary *userInfo = notification.userInfo;
	PDItem *object = [userInfo objectForKey:@"object"];
	
	if ([self.photo.user isEqual:object]) {
		[self.photo.user setValuesFromArray:userInfo[@"values"]];
		self.needRefreshView = YES;
		
	} else 	if ([self.photo isEqual:object]) {
		[self.photo setValuesFromArray:userInfo[@"values"]];
		self.needRefreshView = YES;
	}
	
	if (self.view.window && self.needRefreshView) {
		[self refreshWithoutScrollToTop];
	}
}

- (NSString *)pageName
{
	return @"PhotoSpot View";
}

#pragma mark - private

- (void)fetchData
{
	[super fetchData];
    if (self.serverExchange) {
        self.serverExchange = nil;
    }
    self.serverExchange = [[PDServerPhotoLoader alloc] initWithDelegate:self];
	[self.serverExchange loadPhotoItem:self.photo];
}

- (void)setPhoto:(PDPhoto *)newPhoto
{
	[[SDImageCache sharedImageCache] removeImageForKey:_photo.fullImageURL.absoluteString fromDisk:NO];
	_photo = newPhoto;
    self.currentPhotoIndex = [self.photosDataSource indexOfPhoto:newPhoto forPhotoViewController:self];
	self.item = _photo;
    
	if (self.isViewLoaded) {
		[self resetView];
		self.photoImage.photo = newPhoto;
		self.photoImage.image = newPhoto.cachedFullImage;
		if (!self.photoImage.image) {
			self.photoImage.image = newPhoto.cachedThumbnailImage;
		}
		[self refreshView];
		[self fetchData];
	}
}

- (void)resetView
{
	self.userAvatarImageView.image = nil;
    [self.photoImage hideActivity];
	[self.itemsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	[self.mapPreviewButton setImage:nil forState:UIControlStateNormal];
    addCommentLinesNumber = 1;
    self.items = nil;
    self.comments = nil;
    
    self.likePhotosView.images = nil;
    [self.likePhotosView.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    self.ownerPhotosView.images = nil;
    [self.ownerPhotosView.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    self.collectsPhotoView.images = nil;
    self.timeLabel.text = nil;
    [self.collectsPhotoView.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    self.photoCoutOwnerLabel.text = nil;
    self.followersContOwnerLabel.text = nil;

    self.readMoreButton.selected = NO;
    self.showMoreTagButton.selected = NO;
    self.commentTextView.text = nil;
    [self textViewDidChange:_commentTextView];
	[_commentTextView resignFirstResponder];
    [self.locationView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.tagsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
}

- (void)layoutSubviews
{
    self.timeView.y = self.photoImage.bottomYPoint - 20;
    self.photoTitleView.y = self.photoImage.bottomYPoint;
    self.shadowDescriptionView.y = self.photoTitleView.bottomYPoint - 4;
    
    CGFloat descriptionHeight = [self.photoDescriptionLabel sizeThatFits:CGSizeMake(self.photoDescriptionLabel.width, MAXFLOAT)].height;
    
	if (self.photo.details.length == 0) {
        self.shadowDescriptionView.height = 0;
		self.descriptionView.height = 0;
        self.shadowDescriptionView.hidden = YES;
	} else if (descriptionHeight > kPDMaxDesctiptionHeight) {
		self.readMoreButton.hidden = NO;
        if (!self.readMoreButton.selected) {
            self.descriptionView.height = 72 + self.readMoreButton.height;
        } else {
            self.descriptionView.height =  descriptionHeight + self.readMoreButton.height + 4;
        }
        self.photoDescriptionLabel.height =  descriptionHeight;
        self.readMoreButton.y = self.descriptionView.height - self.readMoreButton.height;
        self.shadowDescriptionView.hidden = NO;
        self.shadowDescriptionView.height = self.descriptionView.bottomYPoint;

	} else {
        self.shadowDescriptionView.hidden = NO;
		self.readMoreButton.hidden = YES;
		self.photoDescriptionLabel.height = descriptionHeight + 14;
		self.descriptionView.height = self.photoDescriptionLabel.bottomYPoint;
        self.shadowDescriptionView.height = self.photoDescriptionLabel.bottomYPoint;
	}
    
    self.backgroundMapview.height = self.tipPreview.bottomYPoint;
    self.mapView.height = self.backgroundMapview.bottomYPoint;
    self.shadowMapview.height = self.backgroundMapview.bottomYPoint;
    self.shadowMapview.y = self.shadowDescriptionView.bottomYPoint;
    
    if (self.photo.poiItem.name.length == 0) {
        self.shadowLandmarkView.height = 0;
        self.landmarkView.height = 0;
        self.shadowLandmarkView.hidden = YES;
    } else {
        self.shadowLandmarkView.backgroundColor = [UIColor whiteColor];
        self.changeBackgroundColor = PDWhiteBackgroudColor;
        self.landmarkView.height = 188;
        self.shadowLandmarkView.height = 188;
        self.shadowLandmarkView.hidden = NO;
    }
    
    self.shadowLandmarkView.y = self.shadowMapview.bottomYPoint;
    if (self.changeBackgroundColor == PDWhiteBackgroudColor) {
        self.shadowExifView.backgroundColor = kPDGlobalBackgroundGrayColor;
    } else {
        self.shadowExifView.backgroundColor = [UIColor whiteColor];
    }
    self.changeBackgroundColor =! self.changeBackgroundColor;
    self.shadowExifView.y = self.shadowLandmarkView.bottomYPoint;
    
    if (self.photo.tags.length == 0) {
        self.shadowTagBackgroundView.height = 0;
        self.shadowTagBackgroundView.hidden = YES;
    } else {
        if (_tagViewHeight > 65) {
            if (!self.showMoreTagButton.selected) {
                self.tagsView.height =  70;
            } else {
                self.tagsView.height = _tagViewHeight;
            }
            self.tagsBackgroudView.height = self.tagsView.bottomYPoint + self.showMoreTagButton.height;
            self.showMoreTagButton.y = self.tagsBackgroudView.height - self.showMoreTagButton.height;
            self.showMoreTagButton.hidden = NO;

        } else {
            self.tagsView.height = _tagViewHeight;
            self.showMoreTagButton.hidden = YES;
            self.tagsBackgroudView.height = self.tagsView.bottomYPoint;
            
        }
        self.shadowTagBackgroundView.height = self.tagsBackgroudView.height;
        self.shadowTagBackgroundView.hidden = NO;
        
        if (self.changeBackgroundColor == PDWhiteBackgroudColor) {
            self.shadowTagBackgroundView.backgroundColor = kPDGlobalBackgroundGrayColor;
        } else {
            self.shadowTagBackgroundView.backgroundColor = [UIColor whiteColor];
        }
        self.changeBackgroundColor =! self.changeBackgroundColor;
    }
    self.shadowTagBackgroundView.y = self.shadowExifView.bottomYPoint;
    
    if (self.photo.likesCount < 6) {
        self.seeAllLikeLabel.hidden = YES;
    } else {
        self.seeAllLikeLabel.hidden = NO;
    }
    
    if (self.photo.pinsCount < 6) {
        self.seeAllCollectLabel.hidden = YES;
    } else {
        self.seeAllCollectLabel.hidden = NO;
    }
    
    if (self.photo.likesCount + self.photo.pinsCount == 0) {
        self.shadowLikeCollectView.height = 0;
        self.shadowLikeCollectView.hidden = YES;

    } else {
        self.shadowLikeCollectView.height = 155;
        self.shadowLikeCollectView.hidden = NO;
        if (self.changeBackgroundColor == PDWhiteBackgroudColor) {
            self.shadowLikeCollectView.backgroundColor = kPDGlobalBackgroundGrayColor;
        } else {
            self.shadowLikeCollectView.backgroundColor = [UIColor whiteColor];
        }
        self.changeBackgroundColor =! self.changeBackgroundColor;
    }
    self.shadowLikeCollectView.y = self.shadowTagBackgroundView.bottomYPoint;

    self.shadowCommentView.y = self.shadowLikeCollectView.bottomYPoint;

    if (self.photo.comments.count == 0) {
        _seeAllLabel.hidden = YES;
        self.commentTableHeaderView.height = 65;
        [self.commentTableHeaderView addSubview:self.placeholderComment];
        self.placeHolderCommentTableView.height = self.commentTableView.height = 105;
    } else {
        _seeAllLabel.hidden = NO;
        self.commentTableHeaderView.height = 25;
        self.placeHolderCommentTableView.height = self.commentTableView.height = 65 + self.heighTableView;
        [self.placeholderComment removeFromSuperview];
    }
    
    self.commentTableView.tableHeaderView = self.commentTableHeaderView;
    self.commentTableView.tableFooterView = self.writeCommentView;
    if (self.changeBackgroundColor == PDWhiteBackgroudColor) {
        self.shadowCommentView.backgroundColor = kPDGlobalBackgroundGrayColor;
    } else {
        self.shadowCommentView.backgroundColor = [UIColor whiteColor];
    }
    self.changeBackgroundColor = 0;
    self.shadowCommentView.height = self.commentView.height = self.commentTableView.height + 55;
    
    self.explorerView.y = self.shadowCommentView.bottomYPoint + 10;
    self.photoView.height = self.explorerView.bottomYPoint + 10;
    self.itemsTableView.tableHeaderView = self.photoView;
}

#pragma mark - init

- (void)initInterface
{
    commentCellExample = [UIView loadFromNibNamed:@"PDCommentCell"];
    _commentTextView.placeholder = NSLocalizedString(@"Add comment...", nil);
    self.tipDescription = [UIView loadFromNibNamed:@"PDTipDescription"];
    self.tipDescription.y = 145;
    [self.backgroundMapview addSubview:self.tipDescription];
    self.tipDescription.hidden = YES;
	[self initPhotosTable];
    self.editPhotoButton.layer.borderColor = [UIColor colorWithIntRed:240 green:243 blue:253 alpha:255].CGColor;
    self.editPhotoButton.layer.borderWidth = 1.0;
    self.viewInMapView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.viewInMapView.layer.masksToBounds = YES;
    self.viewInMapView.layer.borderWidth = 2.0;
    self.photoImage.delegate = self;
    self.snapshotImageView = [[UIImageView alloc] initWithFrame:self.view.zeroPositionFrame];
    self.snapshotImageView.autoresizingMask = kFullAutoresizingMask;
    self.snapshotImageView.hidden = YES;
    [self.view addSubview:self.snapshotImageView];
    
    NSMutableAttributedString *showTipsString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"show tips", nil)];
    [showTipsString addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                         range:NSMakeRange(0, [showTipsString length])];
    self.showTipsLabel.attributedText = showTipsString;
    
    NSMutableAttributedString *seeAllString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"see all", nil)];
    [seeAllString addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                           range:NSMakeRange(0, [seeAllString length])];
    self.seeAllLabel.attributedText = self.seeAllCollectLabel.attributedText = self.seeAllLikeLabel.attributedText = seeAllString;
    
    [self setBoderView:self.photoTitleView];
    [self setBoderView:self.placeHolderCommentTableView];
    
  	CGFloat fontSize = 22;
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName: kPDGlobalGrayColor};
    
    [self.readMoreButton setFontAwesomeIconForImage:[FAKFontAwesome angleDownIconWithSize:fontSize] forState:UIControlStateNormal attributes:grayColorAttribute];
    [self.readMoreButton setFontAwesomeIconForImage:[FAKFontAwesome angleUpIconWithSize:fontSize] forState:UIControlStateSelected attributes:grayColorAttribute];
    
    [self.showMoreTagButton setFontAwesomeIconForImage:[FAKFontAwesome angleDownIconWithSize:fontSize] forState:UIControlStateNormal attributes:grayColorAttribute];
    [self.showMoreTagButton setFontAwesomeIconForImage:[FAKFontAwesome angleUpIconWithSize:fontSize] forState:UIControlStateSelected attributes:grayColorAttribute];
    
    [self.arrowRightTipImageView setFontAwesomeIconForImage:[FAKFontAwesome angleRightIconWithSize:fontSize]
                                             withAttributes:grayColorAttribute ];
    [self.arrowRightLandMarkImageView setFontAwesomeIconForImage:[FAKFontAwesome angleRightIconWithSize:fontSize]
                                                  withAttributes:grayColorAttribute ];
    [self.angleLeftTipView setFontAwesomeIconForImage:[FAKFontAwesome angleLeftIconWithSize:fontSize]
                                             forState:UIControlStateNormal
                                           attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
    [self.angleLeftTipView setFontAwesomeIconForImage:[FAKFontAwesome angleLeftIconWithSize:fontSize]
                                             forState:UIControlStateSelected
                                           attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
    
    [self.editPhotoButton setFontAwesomeIconForImage:[FAKFontAwesome ellipsisHIconWithSize:fontSize]
                                            forState:UIControlStateNormal
                                          attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
    [self.editPhotoButton setFontAwesomeIconForImage:[FAKFontAwesome ellipsisHIconWithSize:fontSize]
                                            forState:UIControlStateSelected
                                          attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
    
    [self.likeButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsOUpIconWithSize:fontSize]
                                       forState:UIControlStateNormal
                                     attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
	[self.likeButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsUpIconWithSize:fontSize]
                                       forState:UIControlStateSelected
                                     attributes:@{NSForegroundColorAttributeName:kPDGlobalGreenColor}];
    
    [self.shareButton setFontAwesomeIconForImage:[FAKFontAwesome shareSquareIconWithSize:fontSize]
                                        forState:UIControlStateNormal
                                      attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
	[self.shareButton setFontAwesomeIconForImage:[FAKFontAwesome shareSquareIconWithSize:fontSize]
                                        forState:UIControlStateSelected
                                      attributes:@{NSForegroundColorAttributeName:kPDGlobalGreenColor}];
    
    [self.commentButton setFontAwesomeIconForImage:[FAKFontAwesome commentsIconWithSize:fontSize]
                                        forState:UIControlStateNormal
                                      attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
	[self.commentButton setFontAwesomeIconForImage:[FAKFontAwesome commentsIconWithSize:fontSize]
                                        forState:UIControlStateSelected
                                      attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
	
	[self.pinButton setFontAwesomeIconForImage:[FAKFontAwesome folderOpenOIconWithSize:23]
                                      forState:UIControlStateNormal
                                    attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
	[self.pinButton setFontAwesomeIconForImage:[FAKFontAwesome folderIconWithSize:23]
                                      forState:UIControlStateSelected
                                    attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.pinButton setTitle:NSLocalizedString(@"Collect", nil) forState:UIControlStateNormal];
    [self.pinButton setTitle:NSLocalizedString(@"Uncollect", nil) forState:UIControlStateSelected];
    
    [self.angleExplorer setFontAwesomeIconForImage:[FAKFontAwesome angleDownIconWithSize:fontSize]
                                          forState:UIControlStateNormal
                                        attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)initPhotosTable
{
	self.photosTableView = [[PDPhotosTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.photosTableView.itemsTableDelegate = self;
	self.photosTableView.photoViewDelegate = self;
    [self.photosTableView setBackgroundColor:kPDPhotoSpotBackgroundColor];
	[self.tablePlaceholderView addSubview:_photosTableView];
    self.itemsTableView = _photosTableView;
}

#pragma mark - Refresh View
     
- (void)refreshView
{
	[super refreshView];
	[self refreshTagsView];
    [self refreshLikeCollectView];
    [self refreshLocationView];
    [self refreshTipView];
    [self refreshExifView];
    [self refreshLandmarkView];
    self.heighTableView = 0;
    [self.commentTableView reloadData];
    self.photoTileLabel.text = self.photo.title;
	self.likeButton.enabled = (self.photo.user.identifier != kPDUserID);
	self.pinButton.enabled = (self.photo.user.identifier != kPDUserID);
	[self refreshDetails];
	[self layoutSubviews];
}

- (void)refreshDetails
{
    self.ownerPhotosView.images = self.photo.user.photos;

	self.likeButton.selected = self.photo.likedStatus;
	self.pinButton.selected = self.photo.pinnedStatus;
	self.usernameLabel.text = self.photo.user.name;
	self.photoDescriptionLabel.text = self.photo.details;
    
    if (self.photo.user.photosCount > 1) {
        self.photoCoutOwnerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"photos %d /", nil),self.photo.user.photosCount];
    } else {
        self.photoCoutOwnerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"photo %d /", nil),self.photo.user.photosCount];
    }
    if (self.photo.user.followersCount > 1) {
        self.followersContOwnerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"followers %d", nil),self.photo.user.followersCount];
    } else {
        self.followersContOwnerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"follower %d", nil),self.photo.user.followersCount];
    }
    
    if (self.photo.date) {
        if ([self.photo.date isEqualToString:@"unavailable"]) {
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Date/Time is", nil), self.photo.date];
        } else {
            self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"taken on", nil), self.photo.date];
        }
    }
    if (self.photo.commentsCount > 1) {
        self.countCommentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d comments", nil), self.photo.commentsCount];
    } else {
        self.countCommentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d comment", nil), self.photo.commentsCount];;
    }
    if (self.photo.likesCount > 1) {
        self.likeCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d LIKES", nil), self.photo.likesCount];
    } else {
        self.likeCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d LIKE", nil), self.photo.likesCount];
    }
    
    if (self.photo.pinsCount > 1) {
        self.collectCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d COLLECTS", nil), self.photo.pinsCount];

    } else {
        self.collectCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d COLLECT", nil), self.photo.pinsCount];
    }

}

- (void)refreshTagsView
{
    NSArray *tags = [self.photo.tags componentsSeparatedByString:@","];
    int startIndex = 0, endIndex = 0;
    int width = 5;
    int viewNumber = 0;
    for (int i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        width += [tag sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]].width + 15;
        if (width >= self.tagsView.width) {
            endIndex = i ;
            [self addTagViewWithStartIndex:startIndex endIndex:endIndex originY:(viewNumber * 30.0)];
            startIndex = endIndex ;
            viewNumber ++;
            width = 5 + [tag sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]].width + 15;
        } else if (i == tags.count - 1) {
            [self addTagViewWithStartIndex:startIndex endIndex:tags.count originY:(viewNumber * 30.0)];
        }
    }
    _tagViewHeight = (viewNumber + 1) * 30.0 + 5;
}

- (void)addTagViewWithStartIndex:(int)startIndex endIndex:(int)endIndex originY:(float)y
{
    UIView *tagSubView = [[UIView alloc] initWithFrame:CGRectMake(0, y , 0, 30)];
    [self.tagsView addSubview:tagSubView];
    NSArray *tags = [self.photo.tags componentsSeparatedByString:@","];
    float width = 0;
    float x = 0;
    for (int i = startIndex; i < endIndex; i ++) {
        PDLinedButton *tagButton;
        tagButton = [[PDLinedButton alloc] init];
        tagButton.layer.cornerRadius = 4;
        tagButton.backgroundColor = kPDPhotoPageTagBackgroudColor;
        tagButton.layer.masksToBounds = YES;
        [tagButton addTarget:self action:@selector(tagButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [tagButton setTitleColor:kPDGlobalGrayColor forState:UIControlStateNormal];
        tagButton.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:14];
        [tagSubView addSubview:tagButton];

        NSString *tag = tags[i];
        [tagButton setTitle:[NSString stringWithFormat:@"#%@",tag] forState:UIControlStateNormal];
        width += [tag sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]].width + 15;
        int buttonWidth = [tag sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]].width + 10;
        tagButton.frame = CGRectMake(x, 0, buttonWidth, 25);
        x += buttonWidth + 5;
    }
    tagSubView.width = width;
    tagSubView.center = CGPointMake(self.tagsView.width / 2, tagSubView.center.y);
}

- (void)refreshLikeCollectView
{
    self.likePhotosView.images = self.photo.likingsUser;
    self.collectsPhotoView.images = self.photo.piningsUser;
    
    if (self.photo.likingsUser.count < 3) {
        self.likePhotosView.width = self.photo.likesCount * 27;
    } else {
        self.likePhotosView.width = 82;
    }
    self.likePhotosView.center = CGPointMake(self.likeCountLabel.center.x, self.likePhotosView.center.y);
    
    if (self.photo.piningsUser.count < 3) {
        self.collectsPhotoView.width = self.photo.pinsCount * 27;
    } else {
        self.collectsPhotoView.width = 82;
    }
    self.collectsPhotoView.center = CGPointMake(self.collectCountLabel.center.x, self.collectsPhotoView.center.y);
}

- (void)refreshLocationView
{
    _locations = [[NSMutableArray alloc] init];
    
    if (self.photo.country) {
        [_locations addObject:self.photo.country];
    }
    if (self.photo.state) {
        [_locations addObject:self.photo.state];
    }
    if (self.photo.city) {
        [_locations addObject:self.photo.city];
    }
    
    int startIndex = 0, endIndex = 0;
    int width = 5;
    int viewNumber = 0;
    
    for (int i = 0; i < _locations.count; i++) {
        PDLocation *locationItem = (PDLocation *)[_locations objectAtIndex:i];
        NSString *locationName = locationItem.name;
        width += [locationName sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]].width + 15;
        if (width >= self.locationView.width) {
            endIndex = i ;
            [self addLocationViewWithStartIndex:startIndex endIndex:endIndex originY:(viewNumber * 30.0)];
            startIndex = endIndex ;
            viewNumber ++;
            width = 5 + [locationName sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]].width + 15;
        } else if (i == _locations.count - 1) {
            [self addLocationViewWithStartIndex:startIndex endIndex:_locations.count originY:(viewNumber * 30.0)];
        }
    }
    self.locationView.height = (viewNumber + 1) * 30.0;
    self.tipPreview.y = self.locationView.bottomYPoint;
    self.tipsBackgroundView.y = self.locationView.bottomYPoint;
}


- (void)addLocationViewWithStartIndex:(int)startIndex endIndex:(int)endIndex originY:(float)y
{
    UIView *locationSubView = [[UIView alloc] initWithFrame:CGRectMake(0, y , 0, 30)];
    [self.locationView addSubview:locationSubView];
    float width = 0;
    float x = 0;
    for (int i = startIndex; i < endIndex; i ++) {
        PDLinedButton *locationButton;
        locationButton = [[PDLinedButton alloc] init];
        locationButton.tag = i;
        locationButton.layer.cornerRadius = 4;
        locationButton.backgroundColor = kPDPhotoPageTagBackgroudColor;
        locationButton.layer.masksToBounds = YES;
        [locationButton addTarget:self action:@selector(showLocationDetailsView:) forControlEvents:UIControlEventTouchUpInside];
        [locationButton setTitleColor:kPDGlobalGrayColor forState:UIControlStateNormal];
        locationButton.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:14];
        [locationSubView addSubview:locationButton];
        
        PDLocation *locationItem = (PDLocation *)[_locations objectAtIndex:i];
        NSString *locationName = locationItem.name;
        
        [locationButton setTitle:[NSString stringWithFormat:@"%@",locationName] forState:UIControlStateNormal];
        width += [locationName sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]].width + 15;
        int buttonWidth = [locationName sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14]].width + 10;
        locationButton.frame = CGRectMake(x, 0, buttonWidth, 25);
        x += buttonWidth + 5;
    }
    locationSubView.width = width;
    locationSubView.center = CGPointMake(self.locationView.width / 2, locationSubView.center.y);
}


- (void)refreshTipView
{
    _tipsCount = 0;
    _tipSelecting = -1;
    [self.tipsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    if (_photo.tripod != kPDNoTip) {
        if (_photo.tripod == 1) {
            [self addTipWithImageName:@"icon-tripod.png" withTitle:NSLocalizedString(@"A tripod can be used here.", nil)];
        } else {
            [self addTipWithImageName:@"icon-no-tripod.png" withTitle:NSLocalizedString(@"A tripod can't be used here.", nil)];
        }
    }
    
    if (_photo.is_crowded != kPDNoTip) {
        if (_photo.is_crowded == 1)
            [self addTipWithImageName:@"icon-crowded.png" withTitle:NSLocalizedString(@"This place was crowded.", nil)];
        else
            [self addTipWithImageName:@"icon-no-cowded.png" withTitle:NSLocalizedString(@"This place wasn't crowded.", nil)];
    }
    
    if (_photo.is_parking != kPDNoTip) {
        if (_photo.is_parking == 1)
            [self addTipWithImageName:@"icon-parking.png" withTitle:NSLocalizedString(@"There is parking nearby.", nil)];
        else
            [self addTipWithImageName:@"icon-no-parking.png" withTitle:NSLocalizedString(@"There isn't parking nearby.", nil)];
    }
    
    if (_photo.is_dangerous != kPDNoTip) {
        if (_photo.is_dangerous == 1)
            [self addTipWithImageName:@"icon-caution.png" withTitle:NSLocalizedString(@"This place requires caution.", nil)];
        else
            [self addTipWithImageName:@"icon-no-caution.png" withTitle:NSLocalizedString(@"This place is safe.", nil)];
    }
    
    if (_photo.indoor != kPDNoTip) {
        if (_photo.indoor == 1)
            [self addTipWithImageName:@"icon-indoor.png" withTitle:NSLocalizedString(@"This place is indoor.", nil)];
        else
            [self addTipWithImageName:@"icon-outdoor.png" withTitle:NSLocalizedString(@"This place is outdoor.", nil)];
    }
    
    if (_photo.is_permission != kPDNoTip) {
        if (_photo.is_permission == 1)
            [self addTipWithImageName:@"icon-permission.png" withTitle:NSLocalizedString(@"Permission is required to access.", nil)];
        else
            [self addTipWithImageName:@"icon-no-permission.png" withTitle:NSLocalizedString(@"Permission isn't required to access.", nil)];
    }
    
    if (_photo.is_paid != kPDNoTip) {
        if (_photo.is_paid == YES)
            [self addTipWithImageName:@"icon-no-free.png" withTitle:NSLocalizedString(@"There is no fee to enter the spot.", nil)];
        else
            [self addTipWithImageName:@"icon-free.png" withTitle:NSLocalizedString(@"There is a fee to enter the spot.", nil)];
    }
    if (_photo.difficulty_access != 0) {
        if (_photo.difficulty_access == 1)
            [self addTipWithImageName:@"icon-hard.png" withTitle:NSLocalizedString(@"Difficulty to photograph this spot: hard", nil)];
        else if (_photo.difficulty_access == 2)
            [self addTipWithImageName:@"icon-medium.png" withTitle:NSLocalizedString(@"Difficulty to photograph this spot: medium", nil)];
        else if (_photo.difficulty_access == 3)
            [self addTipWithImageName:@"icon-easy.png" withTitle:NSLocalizedString(@"Difficulty to photograph this spot: easy", nil)];
    }
}

- (void)addTipWithImageName:(NSString *)iconName withTitle:(NSString *)tile
{
    PDPhotoTipsView *photoTipsView = [[PDPhotoTipsView alloc] init];
    photoTipsView.delegate = self;
    photoTipsView.tag = _tipsCount;
    photoTipsView.y = 5;
    photoTipsView.x = _tipsCount * 30;
    UIImage *image = [UIImage imageNamed:iconName];
    [photoTipsView setcontentImage:image withTitle:tile];
    [_tipsView addSubview:photoTipsView];
    _tipsCount ++;
}

- (void)refreshExifView
{
	self.focalLengtLabel.text = self.photo.focalLength;
	self.shutterSpeedLabel.text = self.photo.shutterSpeed;
	self.apertureLabel.text = self.photo.aperture;
	self.isoSpeedRatingLabel.text = self.photo.isoFilm;
    self.lenLabel.text = self.photo.lens;
    self.filterLabel.text = self.photo.filter;
    if (self.photo.cameraInfo) {
        NSMutableAttributedString *cameraString = [[NSMutableAttributedString alloc] initWithString:self.photo.cameraInfo];
        [cameraString addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                             range:NSMakeRange(0, [cameraString length])];
        self.cameraLabel.attributedText = cameraString;
    }
    if (self.photo.manufacter) {
        NSMutableAttributedString *manufacterString = [[NSMutableAttributedString alloc] initWithString:self.photo.manufacter];
        [manufacterString addAttribute:NSUnderlineStyleAttributeName
                                 value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                 range:NSMakeRange(0, [manufacterString length])];
        self.manufacterrLabel.attributedText = manufacterString;
    }

}

- (void)refreshLandmarkView
{
    NSMutableAttributedString *landmarkString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.photo.poiItem.name]];
    
    [landmarkString addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                          range:NSMakeRange(0, [landmarkString length])];
    self.landmarkNameLabel.attributedText = landmarkString;
    [self.landmarkNameLabel sizeToFit];
    self.landmarkNameLabel.center = CGPointMake(self.shadowLandmarkView.width/2, self.landmarkNameLabel.y + self.landmarkNameLabel.height/2);
    self.arrowRightLandMarkImageView.x = self.landmarkNameLabel.rightXPoint + 10;
    
    [self.landmarkAvatar sd_setImageWithURL:self.photo.poiItem.avatarURL placeholderImage:[UIImage imageNamed:@"placeholder_landmark.png"]];
    if (self.photo.poiItem.photosCount > 1)
        self.photoCountLandmarkLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photos /", nil), self.photo.poiItem.photosCount];
    else
        self.photoCountLandmarkLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photo /", nil), self.photo.poiItem.photosCount];
    if (self.photo.poiItem.photosgraphersCount > 1)
        self.userCountLandmarkLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d users", nil), self.photo.poiItem.photosgraphersCount];
    else
        self.userCountLandmarkLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d user", nil),self.photo.poiItem.photosgraphersCount];

}

- (void)layoutAddCommentView
{
    self.explorerView.y = self.shadowCommentView.bottomYPoint + 10;
}

- (void)refreshCommentCount
{
	self.countCommentLabel.text = self.photo.commentsCountInString;
}

#pragma mark - action

- (BOOL)validateData
{
	if (_commentTextView.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter comment text", nil)];
		return NO;
	}
	
	return YES;
}

- (IBAction)sendComment:(id)sender
{
	if (![self validateData]) return;
	
    [PDAppRater userDidSignificantEvent:NO];
	[kPDAppDelegate showWaitingSpinner];
	[self trackEvent:@"Comment"];
	PDServerComment *serverComment = [[PDServerComment alloc] initWithDelegate:self];
	self.serverExchange = serverComment;
	if (_replyComment.identifier) {
        [serverComment commentPhoto:self.photo text:_commentTextView.text replyUserId:_replyComment.identifier];
    }
    else {
        [serverComment commentPhoto:self.photo text:_commentTextView.text];
    }
    _replyComment = nil;
}

- (void)deletePhoto
{
    [kPDAppDelegate showWaitingSpinner];
    self.serverExchange  = [[PDServerDeletePhoto alloc] initWithDelegate:self];
    [self.serverExchange deletePhoto:self.photo];
}

- (void)selectReportReason
{
	UIAlertView *alertView =
	[[UIAlertView alloc] initWithTitle:nil
							   message:NSLocalizedString(@"Tell us why the photo is inappropriate", nil)
							  delegate:self
					 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
					 otherButtonTitles:
	 NSLocalizedString(@"Offensive (nude, obscene, violence)", nil),
	 NSLocalizedString(@"Spam (ads, self-promotion)", nil),
	 NSLocalizedString(@"Irrelevant Content (3D, graphics)", nil),
	 NSLocalizedString(@"Wrong location", nil), nil];
    alertView.tag = 0;
	[alertView show];
}

- (void)showFullSizePhotoView
{
	self.photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
	self.photoBrowser.wantsFullScreenLayout = YES;
	PDNavigationController *browserNavigationController = [[PDNavigationController alloc] initWithRootViewController:self.photoBrowser];
	browserNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	[self.photoBrowser setInitialPageIndex:self.currentPhotoIndex];
	[self.photoBrowser reloadData];
	[self presentViewController:browserNavigationController animated:NO completion:^{}];
	PDNavigationBar *bar = (PDNavigationBar *) browserNavigationController.navigationBar;
	if ([bar isKindOfClass:[PDNavigationBar class]]) {
		bar.titleButton.hidden = YES;
	}
    
	self.fullscreenPhotoBrowserShown = YES;
}

- (IBAction)editPhotoTouches:(id)sender
{
    [self editPhotoAction];
}

- (IBAction)showLocationDetailsView:(UIButton *)sender
{
	PDLocationViewController *locationViewController = [[PDLocationViewController alloc] initWithNibName:@"PDLocationViewController" bundle:nil];
    PDLocation *locationItem = [_locations objectAtIndex:sender.tag];
    locationViewController.location = locationItem;
	[self.navigationController pushViewController:locationViewController animated:YES];
}

- (IBAction)tagButtonTouch:(id)sender
{
	PDTagViewController *tagViewController = [[PDTagViewController alloc] initForUniversalDevice];
	
	PDTag *tagObject = [[PDTag alloc] init];
    NSString *tagName = [sender titleForState:UIControlStateNormal];
    tagName = [tagName substringFromIndex:1];
	tagObject.name = tagName;
	tagViewController.tag = tagObject;
	[self.navigationController pushViewController:tagViewController animated:YES];
	
}

- (IBAction)sharePhoto:(id)sender {
    [self shareAction];
}

- (IBAction)pinPhoto:(id)sender
{
    if (!self.photo.pinnedStatus) {
        [self trackEvent:@"Collect"];
		[self addPhotoToCollections];
	} else {
        [self trackEvent:@"Uncollect"];
        [self.photo unPinPhoto];
	}
}

- (IBAction)likePhoto:(id)sender
{
	if (!self.photo.likedStatus)
        [self trackEvent:@"Like"];
    else
        [self trackEvent:@"Unlike"];
	[self.photo likePhoto];
}

- (void)addPhotoToCollections
{
	self.collectionsViewController = [[PDCollectionsViewController alloc] initForUniversalDevice];
	self.collectionsViewController.photo = self.photo;
	[kPDAppDelegate.viewDeckController addChildViewController:self.collectionsViewController];
	self.collectionsViewController.view.frame = kPDAppDelegate.viewDeckController.view.zeroPositionFrame;
	[kPDAppDelegate.viewDeckController.view addSubview:self.collectionsViewController.view];
	[self.collectionsViewController viewWillAppear:YES];
	self.collectionsViewController.contentView.y = self.collectionsViewController.view.height;
	[UIView animateWithDuration:0.2 animations:^{
		self.collectionsViewController.contentView.y = 20;
	}];
}

- (IBAction)showPOIInfo:(id)sender
{
    PDLocationViewController *locationViewController = [[PDLocationViewController alloc] initForUniversalDevice];
    locationViewController.location = self.photo.landmark;
    [self.navigationController pushViewController:locationViewController animated:YES];
}

- (IBAction)goToMap:(id)sender
{
	PDPhotoMapViewController *photoMapViewController = [[PDPhotoMapViewController alloc] initForUniversalDevice];
	photoMapViewController.photo = self.photo;
	[self.navigationController pushViewController:photoMapViewController animated:YES];
}

- (IBAction)showTip:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.tipPreview.x = -320;
        self.tipsBackgroundView.x = 0;
    }];
}

- (IBAction)hiddenTips:(id)sender {
    self.tipDescription.hidden = YES;
    _tipSelecting = -1;
    [UIView animateWithDuration:0.2 animations:^{
        self.tipPreview.x = 0;
        self.tipsBackgroundView.x = 320;
    }];
}

- (IBAction)showUserDetail:(id)sender {
    [self showUser:self.photo.user];
}

- (IBAction)showHiddenNearbyPhoto:(id)sender {
    [self fetchDataPhotosNearby];
    self.angleExplorer.hidden = YES;
    self.showNearbyPhotoButton.hidden = YES;
    [self.explorerView clearBackgroundColor];
    self.photoSpotNearbyLabel.text = NSLocalizedString(@"Photospots from the area", nil);
    self.photoSpotNearbyLabel.x = 20;
    self.photoSpotNearbyLabel.textColor = kPDGlobalGrayColor;

}

- (void)swipeLeftGestureHandler
{
    PDPhoto *nextPhoto = [self.photosDataSource photoAtIndex:self.currentPhotoIndex + 1 forPhotoViewController:self];
    if (!nextPhoto) {
        [super swipeLeftGestureHandler];
        return;
    }
    
    [self.snapshotImageView.superview bringSubviewToFront:self.snapshotImageView];
    self.snapshotImageView.image = [self.contentView captureViewToUIImage];
    self.snapshotImageView.x = 0;
    self.snapshotImageView.hidden = NO;
    self.contentView.x = self.view.width;
    self.photo = nextPhoto;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.x = 0;
        self.snapshotImageView.x = -self.view.width;
    } completion:^(BOOL finished) {
        self.snapshotImageView.hidden = YES;
    }];
}

- (void)swipeRightGestureHandler
{
    PDPhoto *previousPhoto = [self.photosDataSource photoAtIndex:self.currentPhotoIndex - 1 forPhotoViewController:self];
    if (!previousPhoto) {
        [super swipeRightGestureHandler];
        return;
    }
    
    [self.snapshotImageView.superview bringSubviewToFront:self.snapshotImageView];
    self.snapshotImageView.image = [self.contentView captureViewToUIImage];
    self.snapshotImageView.x = 0;
    self.snapshotImageView.hidden = NO;
    self.contentView.x = -self.view.width;
    self.photo = previousPhoto;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.x = 0;
        self.snapshotImageView.x = self.view.width;
    } completion:^(BOOL finished) {
        self.snapshotImageView.hidden = YES;
    }];
}

- (void)goBack:(id)sender
{
    if (self.navigationController.presentingViewController && [self.navigationController.viewControllers.firstObject isEqual:self]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    } else {
        if (self.photosDataSource) {
            [self.photosDataSource dismissPhotoViewController:self
                                                    withPhoto:self.photo
                                                   photoImage:self.photoImage.image
                                               photoImageSize:self.photoImage.frame.size];            
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}

- (IBAction)showMoreComments:(id)sender
{
    if (self.photo.commentsCount == 0 ) return;
	PDCommentsViewController *commentsViewController = [[PDCommentsViewController alloc] initForUniversalDevice];
	commentsViewController.photo = self.photo;
	[self.navigationController pushViewController:commentsViewController animated:YES];
}

- (IBAction)showLikingUsers:(id)sender {
    if (self.photo.likesCount == 0) return;
	PDPhotoLikingUsersViewController *likesViewController = [[PDPhotoLikingUsersViewController alloc] initWithNibName:@"PDPhotoUsersViewController" bundle:nil];
	likesViewController.photo = self.photo;
    [self.navigationController pushViewController:likesViewController animated:YES];
    
}

- (IBAction)showPinnedUsers:(id)sender {
    if (self.photo.pinsCount == 0 ) return;
	PDPhotoPinnedUsersViewController *pinsViewController = [[PDPhotoPinnedUsersViewController alloc] initWithNibName:@"PDPhotoUsersViewController" bundle:nil];
	pinsViewController.photo = self.photo;
    [self.navigationController pushViewController:pinsViewController animated:YES];
}

- (IBAction)showMoreDescription:(id)sender {
    _readMoreButton.selected = !_readMoreButton.selected;
	
	[UIView animateWithDuration:0.3 animations:^{
		[self.itemsTableView beginUpdates];
		[self layoutSubviews];
	} completion:^(BOOL finished) {
		[self.itemsTableView endUpdates];
	}];
}

- (IBAction)showCameraTags:(id)sender {
    [self showTagWithText:self.photo.cameraInfo];
}

- (IBAction)showMoreTag:(id)sender {
    _showMoreTagButton.selected =! _showMoreTagButton.selected;
	
	[UIView animateWithDuration:0.3 animations:^{
		[self.itemsTableView beginUpdates];
		[self layoutSubviews];
	} completion:^(BOOL finished) {
		[self.itemsTableView endUpdates];
	}];
    
}

- (IBAction)scrollToComment:(id)sender {
    CGPoint newOffSet = CGPointMake(0, (self.shadowCommentView.y - (self.view.height - self.shadowCommentView.height - 55)));
    [UIView animateWithDuration:0.2 animations:^{
		[self.photosTableView setContentOffset:newOffSet animated:YES];
		[self viewWillLayoutSubviews];
	}];
}

- (IBAction)showManufacterTags:(id)sender {
    [self showTagWithText:self.photo.manufacter];
}

- (void)showTagWithText:(NSString *)tagName
{
    if (tagName.length == 0 || [tagName isEqualToString:@"0"]) {
        return;
    }
    PDTagViewController *tagViewController = [[PDTagViewController alloc] initForUniversalDevice];
	
	PDTag *tagObject = [[PDTag alloc] init];
	tagObject.name = tagName;
	tagViewController.tag = tagObject;
	[self.navigationController pushViewController:tagViewController animated:YES];
}

- (void)editPhotoAction
{
    if (self.photo.user.identifier == kPDUserID) {
        if (!_editPhotoActionSheet)
            _editPhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:NSLocalizedString(@"Edit Photo",nil), NSLocalizedString(@"Delete Photo", nil), nil];
        [_editPhotoActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    } else {
        if (!_reportPhotoActionSheet) {
            _reportPhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Report Photo",nil),  nil];
        }
        [_reportPhotoActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)editPhoto
{
	PDEditPhotoViewController *editPhotoViewController = [[PDEditPhotoViewController alloc] initWithNibName:@"PDUploadPhotoViewController" bundle:nil];
    if (_photoImage.image)
        self.photo.image = _photoImage.image;
    editPhotoViewController.photo = self.photo;
	[self.navigationController pushViewController:editPhotoViewController animated:YES];
}

- (void)setBoderView:(UIView *)view
{
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
	view.layer.borderWidth = 0.2;
	view.layer.shadowOffset = CGSizeMake(1, 1);
	view.layer.shadowOpacity = 0.5;
	view.layer.shadowRadius = 1;
	view.layer.shadowColor = [UIColor grayColor].CGColor;
    
}

#pragma mark - share photo

- (void)shareAction
{
    if (!_shareActionSheet) {
        _shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"Share on Facebook",nil), NSLocalizedString(@"Share on Twitter", nil), nil];
    }
    [_shareActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)shareWithFacebook
{
	SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
	[facebookController setInitialText:NSLocalizedString(@"Share Photo", nil)];
	NSString *sharePhotoURL = [kPDSharePhotoURL stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.photo.identifier]];
	[facebookController addURL:[NSURL URLWithString:sharePhotoURL]];
	[self presentViewController:facebookController animated:YES completion:nil];
    [self trackEvent:@"Share Facebook"];
}

- (void)shareWithTwitter
{
	NSString *sharePhotoURL = [kPDSharePhotoURL stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.photo.identifier]];
	SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
	[twitterController addImage:self.photoImage.image];
	[twitterController setInitialText:sharePhotoURL];
	[self presentViewController:twitterController animated:YES completion:nil];
    
    [self trackEvent:@"Share Twitter"];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!self.view.window) return;
    CGRect frame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardY = self.view.height - frame.size.height - self.shadowCommentView.height;
    float deltaCommentView = self.shadowCommentView.y - self.itemsTableView.contentOffset.y;
    float delta = deltaCommentView - keyboardY;
	double duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	self.keyboardShown = YES;
    self.currentOffset = self.itemsTableView.contentOffset;
    CGPoint newOffSet = CGPointMake(0, self.itemsTableView.contentOffset.y + delta + 4);
    
	[UIView animateWithDuration:duration animations:^{
		[self.photosTableView setContentOffset:newOffSet animated:YES];
		[self viewWillLayoutSubviews];
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.view.window) return;

	double duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	self.keyboardShown = NO;
    
    CGPoint newOffset = CGPointMake(0, self.currentOffset.y);
	[UIView animateWithDuration:duration animations:^{
        [self.photosTableView setContentOffset:newOffset animated:YES];
		[self viewWillLayoutSubviews];
	}];

}

#pragma mark - load data

- (void)loadPhotoImages
{
    UIImage *cachedFullImage = self.photo.cachedFullImage;
    
    if (cachedFullImage) {
        [self.photoImage hideActivity];
        self.photoImage.image = cachedFullImage;
        
    } else {
        [self.photoImage showActivityWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.photoImage sd_setImageWithURL:self.photo.fullImageURL placeholderImage:[self.photo cachedThumbnailImage] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.photoImage hideActivity];
        }];
    }
	[self.userAvatarImageView sd_setImageWithURL:self.photo.user.thumbnailURL];
}

#pragma mark - tipview delegate

- (void)showTitleTip:(PDPhotoTipsView *)tipView
{
    if (_tipSelecting == tipView.tag) {
        self.tipDescription.hidden =! self.tipDescription.hidden;
    } else {
        self.tipDescription.hidden = NO;
    }
    
    [self.tipDescription setTipDescription:tipView.titleTip];
    self.tipDescription.center = CGPointMake(tipView.center.x + 30, self.tipDescription.center.y);
    
    
    if (self.tipDescription.x < 0) {
        self.tipDescription.arrowImageView.x = self.tipDescription.arrowImageView.x + self.tipDescription.x;
        self.tipDescription.x = 0;
    }
    if (self.tipDescription.rightXPoint > 310) {
        self.tipDescription.arrowImageView.x = self.tipDescription.arrowImageView.x + (self.tipDescription.rightXPoint - 310);
        self.tipDescription.x = 310 - self.tipDescription.width;
    }
    _tipSelecting = tipView.tag;
}

#pragma mark -  ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _shareActionSheet)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self shareWithFacebook];
                break;
            }
            case 1:
            {
                [self shareWithTwitter];
                break;
            }
            default:
                break;
        }
    } else if (actionSheet == _editPhotoActionSheet) {
        switch (buttonIndex)
        {
            case 0:
            {
                [self editPhoto];
                break;
            }
            case 1:
            {
                UIAlertView *alertView =
                [[UIAlertView alloc] initWithTitle:nil
                                           message:NSLocalizedString(@"Do you really want to delete your photo?", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"No", nil)
                                 otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
                alertView.tag = 1;
                [alertView show];
                break;
            }
            default:
                break;
        }
    } else {
        switch (buttonIndex)
        {
            case 0:
            {
                [self selectReportReason];
                break;
            }
            default:
                break;
        }
    }
}

- (void)loadPhotoMap
{
	[self.mapPreviewButton sd_setImageWithURL:[NSURL URLWithString:self.photo.mapImageURLString] forState:UIControlStateNormal];
}

#pragma mark - Text view delegate

- (void)textViewDidChange:(UITextView *)textView
{
	int linesNumber = textView.contentSize.height / textView.font.lineHeight;
	if (linesNumber > 3) {
		linesNumber = 3;
	}
	
	if (addCommentLinesNumber != linesNumber) {
		addCommentLinesNumber = linesNumber;
		[self layoutAddCommentView];
	}
}

#pragma mark - Photo Status Changed Notification

- (void)photoStatusChanged:(NSNotification *)notification
{
    NSDictionary *statusInfo = notification.userInfo;
    int state = [[statusInfo objectForKey:@"state"] intValue];
    if (state == PDPhotoChangedStateLike) {
		[self.likeButton hideActivity];
		
	} else if (state == PDPhotoChangedStatePin) {
		[self.pinButton hideActivity];
	}
	
	[self refreshDetails];
}

#pragma mark - Attributed label delegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - Photo browser delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
	return [self.photosDataSource numberOfPhotosFor:self];
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
	return (id <MWPhoto>)[self.photosDataSource photoAtIndex:index forPhotoViewController:self];
}

#pragma mark - photo image view delegate

- (void)didTouchedImageView
{
    [self showFullSizePhotoView];
}

#pragma mark - items tableview delegate


- (void)fetchDataPhotosNearby
{
    self.itemsTableView.tableViewState = PDItemsTableViewStateLoadingMoreContent;
	if (self.serverExchange) {
        self.serverExchange = nil;
	}
    self.serverExchange = [[PDServerPhotoNearbyLoader alloc] initWithDelegate:self];
	[self.serverExchange loadNearbyForPhoto:_photo page:self.currentPage sorting:PDNearbySortTypeByDistance range:20];
}

#pragma mark - did select in view

- (void)initPhotoViewController
{
	self.photoViewController = [[PDPhotoSpotViewController alloc] initForUniversalDevice];
	self.fadeView = [[UIView alloc] initWithFrame:self.view.zeroPositionFrame];
	self.fadeView.backgroundColor = [UIColor whiteColor];
	self.fadeView.autoresizingMask = kFullAutoresizingMask;
	self.fadeView.hidden = YES;
	[self.view addSubview:self.fadeView];
	self.photoThumbnailImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	self.photoThumbnailImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.photoThumbnailImageView.clipsToBounds = YES;
	self.photoThumbnailImageView.hidden = YES;
	[self.view addSubview:self.photoThumbnailImageView];
}

- (void)photo:(PDPhoto *)photo didSelectInView:(UIView *)view image:(UIImage *)image
{
    if (!self.photoViewController) {
        [self initPhotoViewController];
    }
	self.photoViewController.photo = photo;
    self.initialPhotoIndex = [self.items indexOfObject:photo];
    
	self.fadeView.alpha = 0;
	[self.fadeView.superview bringSubviewToFront:self.fadeView];
	self.fadeView.hidden = NO;
    
	self.initialPhotoThumbnailViewFrame = [self.view convertRect:view.zeroPositionFrame fromView:view];
	[self.photoThumbnailImageView.superview bringSubviewToFront:self.photoThumbnailImageView];
	self.photoThumbnailImageView.frame = self.initialPhotoThumbnailViewFrame;
    
    if (image) {
        self.photoThumbnailImageView.image = image;
    } else {
        self.photoThumbnailImageView.image = view.captureViewToUIImage;
    }
    
	self.photoThumbnailImageView.hidden = NO;
    CGFloat yOffset = 0;
    if (self.navigationController.isNavigationBarHidden) {
        yOffset = self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    
	[UIView animateWithDuration:0.3 animations:^{
		self.fadeView.alpha = 1;
		self.photoThumbnailImageView.frame =
		CGRectMakeWithSize(0, yOffset, [UIImageView sizeThatFitImageSize:CGSizeMake(photo.photoWidth, photo.photoHeight)
                                                             maxViewSize:CGSizeMake(self.view.width, MAXFLOAT)]);
	} completion:^(BOOL finished) {
		if ([self.navigationController.topViewController isEqual:self.photoViewController]) {
			[self.navigationController popViewControllerAnimated:NO];
		}
		[self.navigationController pushViewController:self.photoViewController animated:NO];
		self.fadeView.hidden = YES;
		self.photoThumbnailImageView.hidden = YES;
	}];
}

#pragma mark - Item select delegate

- (void)itemDidSelect:(PDItem *)item
{
	[self showUser:(PDUser *) item];
}

#pragma mark - Comments cell delegate
     
 - (void)commentWasDeleted:(PDComment *)comment
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.comments];
    [array removeObject:comment];
    self.photo.comments = array;
    self.comments = array;
    self.photo.commentsCount--;
    [self refreshView];
}
 
 - (void)replyToUserComment:(PDComment *)comment atIndex:(int)intdex
{
    [_commentTextView becomeFirstResponder];
    _replyComment = comment;
    
    if (comment.user.identifier == kPDUserID) {
        _commentTextView.text = [NSString stringWithFormat:@"%@ ", _replyComment.comment];
    } else {
        _commentTextView.text = [NSString stringWithFormat:@"@%@ ", _replyComment.user.name];
    }
    [self textViewDidChange:_commentTextView];
}
     
# pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) return;
    if (alertView.tag == 0) {
        [kPDAppDelegate showWaitingSpinner];
        self.serverExchange = [[PDServerPhotoReport alloc] initWithDelegate:self];
        [self.serverExchange reportAboutPhoto:self.photo reason:buttonIndex];
    } else if (alertView.tag == 1) {
        [self deletePhoto];
    }
}

# pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return MIN(3, self.comments.count);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	commentCellExample.commentTextLabel.text = [[self.comments objectAtIndex:indexPath.row] comment];
    
	CGFloat newHeight = [commentCellExample.commentTextLabel sizeThatFits:
						 CGSizeMake(commentCellExample.commentTextLabel.bounds.size.width, MAXFLOAT)].height;
	
    self.heighTableView = self.heighTableView + commentCellExample.commentTextLabel.y + newHeight + 27;
	return commentCellExample.commentTextLabel.y + newHeight + 27 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CommentCellIdentifier = @"PDCommentCell";
	PDCommentCell *cell = (PDCommentCell *) [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
	if (!cell) {
		cell = [UIView loadFromNibNamed:CommentCellIdentifier];
		cell.delegate = self;
	}
    if (self.comments.count > indexPath.row) {
        cell.tag = indexPath.row;
        PDComment *comment = [self.comments objectAtIndex:indexPath.row];
        comment.itemDelegate = self;
        cell.comment = comment;
        [cell disableDetele];
    }
	return cell;
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	if ([serverExchange isKindOfClass:[PDServerPhotoLoader class]]) {
        self.photoImage.photo = self.photo;
        self.comments = [serverExchange loadCommentsFromArray:[[result objectForKey:@"photo"] objectForKey:@"comments"]];
        [self loadPhotoMap];
        [self loadPhotoImages];
	} else if ([serverExchange isKindOfClass:[PDServerPhotoNearbyLoader class]]) {
        self.totalPages = [result intForKey:@"total_pages"];
        self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
    } else if ([serverExchange isKindOfClass:[PDServerComment class]]) {
		[kPDAppDelegate hideWaitingSpinner];
		[_commentTextView resignFirstResponder];
		PDComment *comment = [[PDComment alloc] init];
		comment.photo = _photo;
		[comment loadFullDataFromDictionary:[result objectForKey:@"comment"]];
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.comments];
		[array insertObject:comment atIndex:0];
		self.comments = array;
		_photo.commentsCount++;
		_commentTextView.text = nil;
		[self textViewDidChange:_commentTextView];
        
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:_photo forKey:@"object"];
		[userInfo setObject:@[
                              @{@"value" : _photo.comments, @"key" : @"comments"},
                              @{@"value" : [NSNumber numberWithInteger:_photo.commentsCount], @"key" : @"commentsCount"}] forKey:@"values"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
															object:self
														  userInfo:userInfo];
	} else if ([serverExchange isKindOfClass:[PDServerDeletePhoto class]]) {
        if (self.photosDataSource) {
            [self.photosDataSource didDeletePhoto];
        }
        [self goBack:nil];
    }
    
    [self refreshView];
}

@end
