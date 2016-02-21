//
//  PDPhotoViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 26/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoViewController.h"
#import "PDPhotoNearbyViewController.h"
#import "PDSharePhotoViewController.h"
#import "PDEditPhotoViewController.h"
#import "PDTagViewController.h"
#import "PDPOIItemViewController.h"
#import "UIImage+Extra.h"
#import "UIImage+MTFilter.h"

//#define kPDMaxDesctiptionHeight 56

@interface PDPhotoViewController ()

@property (assign, nonatomic) NSUInteger currentPhotoIndex;
@property (assign, nonatomic, getter = isBottomSlideViewVisible) BOOL bottomSlideViewVisible;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;

- (void)initInterface;
- (void)initPhotoImage;
- (void)initItemsTable;
- (void)refreshDetails;
- (void)loadPhotoImages;
- (void)loadPhotoMap;
- (void)layoutSubviews;
- (void)resetView;
- (void)refreshTagsView;
- (void)removeLastChildViewController;
- (void)addPhotoToCollections;

@end

@implementation PDPhotoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
	[self initInterface];
	self.loadingView = nil;
	if (self.photo) {
		self.photo = self.photo;
	}
    [self setShawdowStyle: self.nearbyPhotosButton];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoStatusChanged:) name:kPDPhotoStatusChangedNotification object:nil];
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

- (void)photo:(PDPhoto *)photo didSelectInView:(UIView *)view image:(UIImage *)image
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[SDImageCache sharedImageCache] removeImageForKey:self.photo.fullImageURL.absoluteString fromDisk:NO];
	[super viewWillDisappear:animated];
	[self.photoImage sd_cancelCurrentImageLoad];
	[self.photoImage hideActivity];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	if (!self.isBottomSlideViewVisible) {
		self.tablePlaceholderView.frame = CGRectWithHeight(self.view.zeroPositionFrame	, self.view.height - self.bottomToolbar.height + self.slideBottomToolbarButton.height - 5);
		self.bottomToolbar.y = self.tablePlaceholderView.bottomYPoint - self.slideBottomToolbarButton.height + 5;
	}
}


#pragma mark - Public

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleBlack;
}

- (IBAction)tagButtonTouch:(id)sender
{
	PDTagViewController *tagViewController = [[PDTagViewController alloc] initForUniversalDevice];
	
	PDTag *tagObject = [[PDTag alloc] init];
	tagObject.name = [sender titleForState:UIControlStateNormal];
	
	tagViewController.tag = tagObject;
	[self.navigationController pushViewController:tagViewController animated:YES];
	
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

- (void)initGestureRecognizers
{
}

- (NSString *)pageName
{
	return @"Photo";
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

- (void)refreshView
{
	[super refreshView];
	[self refreshTagsView];
	[self.poiButton setTitle:self.photo.poiItem.name forState:UIControlStateNormal];
	self.poiPhotosView.images = self.photo.poiItem.photos;
	self.likeButton.enabled = (self.photo.user.identifier != kPDUserID);
	self.pinButton.enabled = (self.photo.user.identifier != kPDUserID);
	[self refreshDetails];
	[self layoutSubviews];
	self.title = self.photo.title;
}

- (IBAction)slideBottomBar:(id)sender
{
	if (self.slideBottomToolbarButton.selected) {
		[self hideBottomBarAnimated:YES];
	} else {
		[self showPinnedUsers:nil];
	}
}

- (IBAction)showPOIInfo:(id)sender
{
	PDPOIItemViewController *poiViewController = [[PDPOIItemViewController alloc] initForUniversalDevice];
	poiViewController.poiItem = self.photo.poiItem;
	[self.navigationController pushViewController:poiViewController animated:YES];
}

- (IBAction)showUserProfile:(id)sender
{
	[self showUser:self.photo.user];
}

- (void)editPhoto:(id)sender
{
	PDEditPhotoViewController *editPhotoViewController = [[PDEditPhotoViewController alloc] initWithNibName:@"PDUploadPhotoViewController" bundle:nil];
    if (_photoImage.image)
        self.photo.image = _photoImage.image;
    editPhotoViewController.photo = self.photo;
	[self.navigationController pushViewController:editPhotoViewController animated:YES];
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

- (IBAction)goToMap:(id)sender
{
	PDPhotoMapViewController *photoMapViewController = [[PDPhotoMapViewController alloc] initForUniversalDevice];
	photoMapViewController.photo = self.photo;
	[self.navigationController pushViewController:photoMapViewController animated:YES];
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

- (IBAction)showNearbyPhotos:(id)sender
{
	PDPhotoNearbyViewController *photoNearbyViewController = [[PDPhotoNearbyViewController alloc] initWithNibName:@"PDPhotoNearbyViewController" bundle:nil];
	photoNearbyViewController.photo = self.photo;
	[self.navigationController pushViewController:photoNearbyViewController animated:YES];
  
}

- (IBAction)sharePhoto:(id)sender
{
	if (!self.photoImage.image) return;
	PDSharePhotoViewController *sharePhotoViewController = [[PDSharePhotoViewController alloc] initWithNibName:@"PDSharePhotoViewController" bundle:nil];
	sharePhotoViewController.photo = self.photo;
	[self.navigationController pushViewController:sharePhotoViewController animated:YES];
}

- (IBAction)showLikingUsers:(id)sender
{
	if (self.photo.likesCount == 0 || [self.childViewControllers.lastObject isKindOfClass:[PDPhotoLikingUsersViewController class]]) return;
	
	self.likesCountButton.selected = YES;
	self.commentsCountButton.selected = NO;
	self.pinsCountButton.selected = NO;
  
	PDPhotoLikingUsersViewController *likesViewController = [[PDPhotoLikingUsersViewController alloc] initWithNibName:@"PDPhotoUsersViewController" bundle:nil];
  
	[self removeLastChildViewController];
	likesViewController.photo = self.photo;
	[self addChildViewController:likesViewController];
	[self showBottomBarAnimated:YES];
	likesViewController.view.frame = self.slideView.zeroPositionFrame;
	[self.slideView addSubview:likesViewController.view];
}

- (IBAction)showPinnedUsers:(id)sender
{
	if (self.photo.pinsCount == 0 || [self.childViewControllers.lastObject isKindOfClass:[PDPhotoPinnedUsersViewController class]]) return;
	
	self.likesCountButton.selected = NO;
	self.commentsCountButton.selected = NO;
	self.pinsCountButton.selected = YES;
  
	PDPhotoPinnedUsersViewController *pinsViewController = [[PDPhotoPinnedUsersViewController alloc] initWithNibName:@"PDPhotoUsersViewController" bundle:nil];
	
	[self removeLastChildViewController];
	pinsViewController.photo = self.photo;
	[self addChildViewController:pinsViewController];
	[self showBottomBarAnimated:YES];
	pinsViewController.view.frame = self.slideView.zeroPositionFrame;
	[self.slideView addSubview:pinsViewController.view];
}

- (IBAction)showMoreComments:(id)sender
{
	if ([self.childViewControllers.lastObject isKindOfClass:[PDCommentsViewController class]]) return;
	
	self.likesCountButton.selected = NO;
	self.commentsCountButton.selected = YES;
	self.pinsCountButton.selected = NO;
  
	PDCommentsViewController *commentsViewController = [[PDCommentsViewController alloc] initForUniversalDevice];
	[self removeLastChildViewController];
	commentsViewController.photo = self.photo;
	[self addChildViewController:commentsViewController];
	[self showBottomBarAnimated:YES];
	commentsViewController.view.frame = self.slideView.zeroPositionFrame;
	[self.slideView addSubview:commentsViewController.view];
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

- (void)fetchData
{
	[super fetchData];
  if (!self.serverExchange) {
    self.serverExchange = [[PDServerPhotoLoader alloc] initWithDelegate:self];
  }
  
	[self.serverExchange loadPhotoItem:self.photo];
}

- (void)showMoreDescription:(id)sender
{
	_readMoreButton.selected = !_readMoreButton.selected;
	
	[UIView animateWithDuration:0.3 animations:^{
		[self.itemsTableView beginUpdates];
		[self layoutSubviews];
	} completion:^(BOOL finished) {
		[self.itemsTableView endUpdates];
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


#pragma mark - Private

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
		self.collectionsViewController.contentView.y = self.collectionsViewController.view.height - self.collectionsViewController.contentView.height;
	}];
}

- (void)loadPhotoMap
{
	[self.mapPreviewButton sd_setImageWithURL:[NSURL URLWithString:self.photo.mapImageURLString] forState:UIControlStateNormal];
}

- (void)refreshCommentsCount
{
	[self.commentsCountButton setTitle:self.photo.commentsCountInString forState:UIControlStateNormal];
}

- (void)refreshTagsView
{
	for (PDLinedButton *tagButton in self.tagButtons) {
		tagButton.hidden = YES;
	}
	
	if (self.photo.tags.length == 0) {
		self.tagsView.height = 0;
	} else {
		NSArray *tags = [self.photo.tags componentsSeparatedByString:@","];
		int y = 5, x = 36;
		for (int i = 0; i < tags.count; i++) {
			NSString *tag = tags[i];
			PDLinedButton *tagButton;
			if (i < self.tagButtons.count) {
				tagButton = self.tagButtons[i];
				tagButton.hidden = NO;
			} else {
				tagButton = [[PDLinedButton alloc] initWithFrame:CGRectZero];
				[tagButton addTarget:self action:@selector(tagButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
				[tagButton setTitleColor:[UIColor colorWithIntRed:36 green:128 blue:255 alpha:255] forState:UIControlStateNormal];
				tagButton.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:14];
				[self.tagsView addSubview:tagButton];
				[self.tagButtons addObject:tagButton];
			}
			[tagButton setTitle:tag forState:UIControlStateNormal];
			int width = [tag sizeWithFont:tagButton.titleLabel.font].width;
			if (x + width >= self.tagsView.width) {
				x = 8;
				y += 35;
			}
			
			tagButton.frame = CGRectMake(x, y, width, 30);
			x += width + 14;
		}
		self.tagsView.height = y + 35;
	}
}

- (void)setShawdowStyle:(UIView *)view
{
    view.layer.cornerRadius = 3;
	view.layer.shadowOffset = CGSizeMake(1, 1);
	view.layer.shadowOpacity = 0.5;
	view.layer.shadowRadius = 1;
	view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
	view.layer.borderWidth = 0.5;
}


- (void)showBottomBarAnimated:(BOOL)animated
{
	self.slideBottomToolbarButton.selected = YES;
	self.bottomSlideViewVisible = YES;
	self.bottomToolbar.height = self.view.height;
	if (animated) {
		[UIView animateWithDuration:0.2 animations:^{
			self.bottomToolbar.y = 0;
		}];
	} else {
		self.bottomToolbar.y = 0;
	}
}

- (void)hideBottomBarAnimated:(BOOL)animated
{
	self.likesCountButton.selected = NO;
	self.commentsCountButton.selected = NO;
	self.pinsCountButton.selected = NO;
	self.bottomSlideViewVisible = NO;
	self.slideBottomToolbarButton.selected = NO;
	if (animated) {
		[UIView animateWithDuration:0.2 animations:^{
			self.bottomToolbar.y = self.view.height - self.slideView.y;
		} completion:^(BOOL finished) {
			self.bottomToolbar.height = self.slideView.y;
			[self removeLastChildViewController];
		}];
	} else {
		self.bottomToolbar.y = self.view.height - self.slideView.y;
		self.bottomToolbar.height = self.slideView.y;
		[self removeLastChildViewController];
	}
}

- (void)layoutSubviews
{
	self.userView.y = self.photoImage.bottomYPoint;
	self.tagsView.y = self.userView.bottomYPoint;
	self.descriptionView.y = self.tagsView.bottomYPoint;
	CGFloat descriptionHeight = [self.photoDescriptionLabel sizeThatFits:CGSizeMake(self.photoDescriptionLabel.width, MAXFLOAT)].height;
	if (self.photo.details.length == 0) {
		self.descriptionView.height = 0;
		
	} else if (descriptionHeight > kPDMaxDesctiptionHeight) {
		self.readMoreButton.hidden = NO;
		self.photoDescriptionLabel.height = (self.readMoreButton.selected) ? descriptionHeight + 4 : kPDMaxDesctiptionHeight;
		self.readMoreButton.y = self.photoDescriptionLabel.bottomYPoint;
		self.descriptionView.height = self.readMoreButton.bottomYPoint + 5;
		
	} else {
		self.readMoreButton.hidden = YES;
		self.photoDescriptionLabel.height = descriptionHeight + 4;
		self.descriptionView.height = self.photoDescriptionLabel.bottomYPoint;
	}
	
	self.poiView.y = self.descriptionView.bottomYPoint;
	if (self.photo.poiItem) {
		[self.poiButton sizeToFit];
		self.poiButton.height = self.poiInfoButton.height;
		self.poiView.height = self.poiPhotosView.bottomYPoint + 6;
	} else {
		self.poiView.height = 0;
	}
  
	self.locationView.y = self.poiView.bottomYPoint;
	self.photoView.height = self.locationView.bottomYPoint + 4;
	
	self.itemsTableView.tableHeaderView = self.photoView;
	self.bottomToolbar.y = self.view.height - self.bottomToolbar.height;
	
	[self.descriptionView setNeedsDisplay];

}

- (void)resetView
{
	self.userAvatarImageView.image = nil;
	self.poiPhotosView.images = nil;
    [self.photoImage hideActivity];
	[self.mapPreviewButton setImage:nil forState:UIControlStateNormal];
	[self.poiPhotosView.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	[self.itemsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
	self.readMoreButton.selected = NO;
	[self hideBottomBarAnimated:NO];
}

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

- (void)refreshDetails
{
	self.likeButton.selected = self.photo.likedStatus;
	self.pinButton.selected = self.photo.pinnedStatus;
	self.usernameLabel.text = self.photo.user.name;
  
	if ([[PDLocationHelper sharedInstance] isLocationReceived]) {
		if (self.photo.location.length > 0) {
			[self.distanceButton setTitle:[NSString stringWithFormat:@"%@, %@", self.photo.distanceInString, self.photo.location]
                           forState:UIControlStateNormal];
		} else {
			[self.distanceButton setTitle:self.photo.distanceInString forState:UIControlStateNormal];
		}
	} else {
		[self.distanceButton setTitle:self.photo.location forState:UIControlStateNormal];
	}
  
	self.photoDescriptionLabel.text = self.photo.details;
	[self.commentsCountButton setTitle:self.photo.commentsCountInString forState:UIControlStateNormal];
	[self.likesCountButton setTitle:self.photo.likesCountInString forState:UIControlStateNormal];
	[self.pinsCountButton setTitle:self.photo.pinsCountInString forState:UIControlStateNormal];
}

- (void)initPhotoImage
{	self.photoImage.contentMode = UIViewContentModeScaleAspectFill;
	self.photoImage.clipsToBounds = YES;
	self.photoImage.backgroundColor = [UIColor lightGrayColor];
	self.photoImage.userInteractionEnabled = YES;
//	[self.photoImage.fullscreenButton addTarget:self action:@selector(showFullSizePhotoView) forControlEvents:UIControlEventTouchUpInside];
//	[self.photoImage.editButton addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchUpInside];
//	[self.photoImage.shareButton addTarget:self action:@selector(sharePhoto:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initItemsTable
{
	self.tableView = [[PDItemsTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.itemsTableDelegate = self;
	[self.tablePlaceholderView addSubview:self.tableView];
	self.itemsTableView = self.tableView;
}

- (void)removeLastChildViewController
{
	[[self.childViewControllers.lastObject view] removeFromSuperview];
	[self.childViewControllers.lastObject removeFromParentViewController];
	[self viewWillAppear:NO];
}

- (void)initInterface
{
	[self initItemsTable];
	[self initPhotoImage];
	self.userAvatarImageView.layer.cornerRadius = 3;
	self.photoDescriptionLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
  self.photoDescriptionLabel.delegate = self;
	[self.poiInfoButton setTitle:NSLocalizedString(@"photo of", nil) forState:UIControlStateNormal];
	
	_distanceButton.titleLabel.numberOfLines = 3;
	_distanceButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  
	self.mapPreviewButton.layer.borderColor = [UIColor colorWithWhite:0.65 alpha:1].CGColor;
	self.mapPreviewButton.layer.borderWidth = 1;
	
	self.tagButtons = [NSMutableArray array];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleWhiteAngle];
	[self setRightBarButtonToImage:[UIImage imageNamed:@"btn-info.png"] offset:CGSizeMake(3, -3) withAction:@selector(showMenu:)];
	
//	self.poiPhotosView.delegate = self;
  self.snapshotImageView = [[UIImageView alloc] initWithFrame:self.view.zeroPositionFrame];
  self.snapshotImageView.autoresizingMask = kFullAutoresizingMask;
  self.snapshotImageView.hidden = YES;
  [self.view addSubview:self.snapshotImageView];
	
	CGFloat fontSize = 22;
	[self.likesCountButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsOUpIconWithSize:fontSize]
																					 forState:UIControlStateNormal
																				 attributes:@{NSForegroundColorAttributeName : kPDGlobalGrayColor}];
	[self.pinsCountButton setFontAwesomeIconForImage:[FAKFontAwesome folderOpenOIconWithSize:fontSize]
																					forState:UIControlStateNormal
																				attributes:@{NSForegroundColorAttributeName : kPDGlobalGrayColor}];
	[self.commentsCountButton setFontAwesomeIconForImage:[FAKFontAwesome commentsOIconWithSize:fontSize]
																					forState:UIControlStateNormal
																				attributes:@{NSForegroundColorAttributeName : kPDGlobalGrayColor}];
	[self.commentsCountButton setFontAwesomeIconForImage:[FAKFontAwesome commentsOIconWithSize:fontSize]
																					 forState:UIControlStateSelected
																				 attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	[self.likesCountButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsOUpIconWithSize:fontSize]
																					 forState:UIControlStateSelected
																				 attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	[self.pinsCountButton setFontAwesomeIconForImage:[FAKFontAwesome folderOpenOIconWithSize:fontSize]
																					forState:UIControlStateSelected
																				attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	UIImage *blackBackground = [[[UIImage alloc] init] imageWithColor:kPDGlobalGrayColor];
	NSArray *bottomButtons = @[self.likesCountButton, self.pinsCountButton, self.commentsCountButton];
	for (UIButton *button in bottomButtons) {
		button.layer.cornerRadius = 3;
		button.clipsToBounds = YES;
		[button setBackgroundImage:blackBackground forState:UIControlStateSelected];
		[button setBackgroundImage:blackBackground forState:UIControlStateSelected|UIControlStateHighlighted];
		button.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[button setTitleColor:kPDGlobalGrayColor forState:UIControlStateNormal];
		[button setTitleColor:[button titleColorForState:UIControlStateSelected] forState:UIControlStateSelected|UIControlStateHighlighted];
		[button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateSelected|UIControlStateHighlighted];
	}
	
	[self.likeButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsOUpIconWithSize:fontSize]
																		 forState:UIControlStateNormal
																	 attributes:@{NSForegroundColorAttributeName: kPDGlobalGrayColor}];
	[self.likeButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsUpIconWithSize:fontSize]
																		 forState:UIControlStateSelected
																	 attributes:@{NSForegroundColorAttributeName: kPDGlobalGreenColor}];
	
	[self.pinButton setFontAwesomeIconForImage:[FAKFontAwesome folderOpenOIconWithSize:fontSize]
																		forState:UIControlStateNormal
																	attributes:@{NSForegroundColorAttributeName: kPDGlobalGrayColor}];
	[self.pinButton setFontAwesomeIconForImage:[FAKFontAwesome folderIconWithSize:fontSize]
																		forState:UIControlStateSelected
																	attributes:@{NSForegroundColorAttributeName: kPDGlobalGreenColor}];

    NSDictionary *lightGrayColorAttribute = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    [self.readMoreButton setTitle:NSLocalizedString(@"read less", nil) forState:UIControlStateSelected];

    [self.readMoreButton setFontAwesomeIconForImage:[FAKFontAwesome minusIconWithSize:15] forState:UIControlStateSelected attributes:lightGrayColorAttribute];
    [self.readMoreButton setTitle:NSLocalizedString(@"read more", nil) forState:UIControlStateNormal];
    [self.readMoreButton setFontAwesomeIconForImage:[FAKFontAwesome alignJustifyIconWithSize:15] forState:UIControlStateNormal attributes:lightGrayColorAttribute];
    [self setShawdowStyle:self.readMoreButton];
    
}

- (void)showMenu:(id)sender
{
	PDPhotoInfoViewController *infoViewController = [[PDPhotoInfoViewController alloc] initForUniversalDevice];
	
//	infoViewController.ownerViewController = self;
	self.viewDeckController.rightSize = 40;
	self.viewDeckController.rightController = infoViewController;
	[self.viewDeckController toggleRightViewAnimated:YES];
    infoViewController.photo = self.photo;
}

- (void)refreshViewMode
{
}

- (void)refreshNavigationButtons
{
}


#pragma mark - Item select delegate

- (void)itemDidSelect:(PDItem *)item
{
	[self showUser:(PDUser *) item];
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	if ([serverExchange isKindOfClass:[PDServerPhotoLoader class]]) {
//<<<<<<< HEAD
    self.photoImage.photo = self.photo;
    [self loadPhotoMap];
    [self loadPhotoImages];
    [self refreshView];
//=======
//        NSDictionary *dictionary = result[@"photo"];
//        PDPhoto *photoSpot = [[PDPhoto alloc] init];
//        [photoSpot loadShortDataFromDictionary:dictionary];
//        self.photoImage.photo = self.photo;
//        [self loadPhotoMap];
//        [self loadPhotoImages];
//        [self refreshView];
//>>>>>>> Improve-Upload-Cloudinary
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


#pragma mark - POI photos delegate

- (void)itemDidSelectedAtIndex:(NSInteger)index sender:(id)sender
{
	[self showPOIInfo:nil];
}

@end
