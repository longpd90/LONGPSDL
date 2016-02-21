//
//  PDUserViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 27/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDUserViewController.h"
#import "PDServerUserInfoLoader.h"
#import "PDUserMapViewController.h"
#import "Globals.h"

#define MaxHeightLocationLabel 37
#define MaxHeightDescriptionLabel 230
#define kPDUserNoSource -1

@interface PDUserViewController ()
@property (weak, nonatomic) IBOutlet UIView *selectionMarkerView;

@end

@implementation PDUserViewController
@synthesize userAvatarImageView;
@synthesize user;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosTableView.tableViewMode = PDItemsTableViewModeList;
    [self initInterface];
    [self initAboutView];
    [self initUserTableView];
    [self initPhotoUserTableView];
    if (self.user) {
		self.user = self.user;
	}
}

- (void)viewDidUnload
{
	[self setUser:nil];
    [self setFollowButton:nil];
    [self setUserAvatarImageView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    
	if (isUserInfoLoaded && !userAvatarImageView.image) {
		[userAvatarImageView showActivityWithStyle:UIActivityIndicatorViewStyleGray];
		userAvatarImageView.image = user.cachedThumbnailImage;
		[userAvatarImageView sd_setImageWithURL:user.fullImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			[userAvatarImageView hideActivity];
		}];
	}
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)dealloc
{
	self.photoViewController = nil;
	self.photoUsersTableView = nil;
	self.usersTableView = nil;
	self.toolbarView = nil;
}


#pragma mark - Private

- (void)initUserTableView
{
    self.usersTableView = [[PDUsersTableView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.tablePlaceholderView.frame.size)];
	_usersTableView.itemsTableDelegate = self;
	[self.tablePlaceholderView addSubview:_usersTableView];
}

- (void)initPhotoUserTableView
{
    self.photoUsersTableView = [[PDPhotoUserTableView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.tablePlaceholderView.frame.size)];
	self.photoUsersTableView.itemsTableDelegate = self;
    self.photoUsersTableView.photoViewDelegate = self;
	[self.tablePlaceholderView addSubview:_photoUsersTableView];
    self.photoUsersTableView.tableViewMode = PDItemsTableViewModeList;
}

- (void)initAboutView
{
    self.aboutView.hidden = YES;
    [self.descriptionTextview setEditable:NO];
    [self.descriptionTextview setScrollsToTop:NO];
    self.levelTitleLabel.text = NSLocalizedString(@"Level", nil);
    self.interestsTitleLabel.text = NSLocalizedString(@"Interests", nil);
    self.detailsTitleLabel.text = NSLocalizedString(@"Details", nil);
    
    [self.tablePlaceholderView addSubview:self.aboutView];
}

- (void)initInterface
{
    if (user.name.length ==  0) {
		self.title = NSLocalizedString(@"User", nil);
	} else {
		self.title = user.name;
	}
    NSArray *buttons = @[self.userPhotosButton, self.collectionsButton, self.followerButton, self.aboutButton];
    
    for (UIButton *button in buttons) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:kPDGlobalRedColor forState:UIControlStateSelected];
        [button setTitleColor:kPDGlobalRedColor forState:UIControlStateSelected|UIControlStateHighlighted];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button applyGlobalFont];
    }
  
    [self.showUserMapButton setTitle:NSLocalizedString(@"map", nil) forState:UIControlStateNormal];
    [self.showUserMapButton applyGlobalFont];
    [self.fullnameLabel applyGlobalFont];
    [self.addressLabel applyGlobalFont];
    [self.levelLabel applyGlobalFont];
    [self.interestesLabel applyGlobalFont];
    [self.levelTitleLabel applyGlobalFont];
    [self.levelLabel applyGlobalFont];
    [self.detailsTitleLabel applyGlobalFont];
    
    self.userMapMarkerView.layer.shadowOffset = CGSizeMake(1, 1);
    self.userMapMarkerView.layer.shadowOpacity = 0.5;
    self.userMapMarkerView.layer.shadowRadius = 3;
    self.userMapMarkerView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.userMapMarkerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.userMapMarkerView.layer.borderWidth = 0.5;
    self.userMapMarkerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.userMapMarkerView.layer.shouldRasterize = YES;
    
    self.selectionMarkerView.backgroundColor = kPDGlobalRedColor;
    
    CGFloat fontSize = 16;
    NSDictionary *lightGrayColorAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	[self.mapMakerImageView setFontAwesomeIconForImage:[FAKFontAwesome mapMarkerIconWithSize:fontSize] withAttributes:lightGrayColorAttribute];
    
    [self.aboutButton setTitle:NSLocalizedString(@"about", nil) forState:UIControlStateNormal];
}

- (void)refreshSourceButtons
{
    _userPhotosButton.selected = (_userViewSource == PDUserViewSourcePhotos);
    _collectionsButton.selected = (_userViewSource == PDUserViewSourceCollections);
    _followerButton.selected = (_userViewSource == PDUserViewSourceFollowers);
    _aboutButton.selected = (_userViewSource == PDUserViewSourceAbout);
    
    
    self.userMapMarkerView.hidden =! _userPhotosButton.selected;
    
    NSArray *buttons = @[self.userPhotosButton, self.collectionsButton, self.followerButton, self.aboutButton];
    
    for (UIButton *button in buttons) {
        if (button.isSelected) {
            [UIView animateWithDuration:0.15 animations:^{
                self.selectionMarkerView.frame = CGRectMake(button.x + 10, button.y, button.width - 20, 8);
            }];
        }
    }
}

- (void)loadImages
{
	userAvatarImageView.image = [self.user cachedThumbnailImage];
	[userAvatarImageView showActivityWithStyle:UIActivityIndicatorViewStyleGray];
	[userAvatarImageView sd_setImageWithURL:self.user.fullImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		[userAvatarImageView hideActivity];
	}];
}

#pragma mark - Public

- (NSString *)pageName
{
    if (self.userViewSource == PDUserViewSourcePhotos)
        return @"User Photos";
    else if (self.userViewSource == PDUserViewSourceCollections)
        return @"User Collections";
    else if (self.userViewSource == PDUserViewSourceFollowers)
        return @"User Followers";
    else
        return @"User About";
}

- (void)refreshCurrentTable
{
	if (self.userViewSource == PDUserViewSourceFollowers) {
		self.photosTableView.hidden = YES;
        self.photoUsersTableView.hidden = YES;
		self.usersTableView.hidden = NO;
		self.itemsTableView = self.usersTableView;
	} else if (self.userViewSource == PDUserViewSourcePhotos ) {
		self.usersTableView.hidden = YES;
		self.photosTableView.hidden = YES;
        self.photoUsersTableView.hidden = NO;
		self.itemsTableView = self.photoUsersTableView;
	} else if (self.userViewSource == PDUserViewSourceCollections){
		self.usersTableView.hidden = YES;
        self.photoUsersTableView.hidden = YES;
        self.photosTableView.hidden = NO;
        self.itemsTableView = self.photosTableView;
    } else
    {
        self.aboutView.hidden = NO;
        self.itemsTableView.hidden = YES;
    }
	[self.tablePlaceholderView bringSubviewToFront:self.itemsTableView];
}

- (void)refetchData
{
	[self refreshCurrentTable];
	[super refetchData];
}

- (void)fetchData
{
	[super fetchData];
    switch (_userViewSource) {
        case PDUserViewSourcePhotos: {
            self.serverExchange = [[PDServerUserLoader alloc] initWithDelegate:self];
            [self.serverExchange loadUser:user page:self.currentPage sorting:kPDDefaultUserSort];
			break;
        }
        case PDUserViewSourceCollections : {
            self.serverExchange = [[PDServerGetUserPins alloc] initWithDelegate:self];
            [self.serverExchange loadPinnedPhotosForUser:user page:self.currentPage sorting:kPDDefaultUserSort];
			break;
        }
        case PDUserViewSourceFollowers : {
            self.serverExchange = [[PDServerUserFollowersLoader alloc] initWithDelegate:self];
            [self.serverExchange loadUserFollowers:user page:self.currentPage];
            break;
        }
        default : {
            break;
        }
    }
}

- (void)setUser:(PDUser *)newUser
{
	user = newUser;
	isUserInfoLoaded = NO;
	self.item = newUser;
	if (self.isViewLoaded) {
        _userViewSource = kPDUserNoSource;
        [self changeSource:self.userPhotosButton];
	}
}

- (void)refreshUserInfo
{
    if (!user) return;
    
	if (user.name.length ==  0) {
		self.title = NSLocalizedString(@"User", nil);
	} else {
		self.title = user.name;
	}
    
    [_userPhotosButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@\nphotos", nil),
                                 [user countValueInString:user.photosCount]] forState:UIControlStateNormal];
	[self.userPhotosButton setTitle:[self.userPhotosButton titleForState:UIControlStateNormal] forState:UIControlStateSelected];
    
	[_collectionsButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@\ncollections", nil),
                                  [user countValueInString:user.pinsCount]] forState:UIControlStateNormal];
    
	[_followerButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@\nfollowers", nil),
                               [user countValueInString:user.followersCount]] forState:UIControlStateNormal];
    
    _followButton.hidden = NO;
    _followButton.item = user;
    self.addressLabel.text = user.address;
    self.fullnameLabel.text = user.fullName;
    self.levelLabel.text = user.photoLevel;
    self.interestesLabel.text = user.interests;
    self.descriptionTextview.text = user.details;
    
}


#pragma mark - Action

- (IBAction)changeSource:(id)sender
{
    if ([sender isEqual:self.userPhotosButton]) {
        if (_userViewSource == PDUserViewSourcePhotos) return;
        _userViewSource = PDUserViewSourcePhotos;
    } else if ([sender isEqual:self.collectionsButton]) {
        if (_userViewSource == PDUserViewSourceCollections) return;
        _userViewSource = PDUserViewSourceCollections;
    } else if ([sender isEqual:self.followerButton]) {
        if (_userViewSource == PDUserViewSourceFollowers) return;
        _userViewSource = PDUserViewSourceFollowers;
    }
    [self refetchData];
	[self refreshSourceButtons];
	[self trackCurrentPage];
    self.itemsTableView.hidden = NO;
    self.aboutView.hidden = YES;
    self.itemsTableView.tableHeaderView = self.toolbarView;
}

- (IBAction)showUserMap:(id)sender
{
    PDUserMapViewController *userMapViewController = [[PDUserMapViewController alloc]initWithNibName:@"PDUserMapViewController" bundle:nil];
    userMapViewController.user = user;
    [self.navigationController pushViewController:userMapViewController animated:YES];
}

- (IBAction)showAboutUser:(id)sender
{
    self.aboutView.hidden = NO;
    self.itemsTableView.tableHeaderView = nil;
    [self.aboutView addSubview:self.toolbarView];
    self.itemsTableView.hidden = YES;
    _userViewSource = PDUserViewSourceAbout;
    [self refreshSourceButtons];
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    self.itemsTableView.hidden = NO;
    [super serverExchange:serverExchange didParseResult:result];
    switch (self.userViewSource) {
        case PDUserViewSourcePhotos:{
            if ([serverExchange isKindOfClass:[PDServerUserLoader class]]) {
                self.items = [serverExchange loadPhotosFromArray:[result objectForKey:@"user"][@"photos"]];
                self.totalPages = [[result objectForKey:@"user"] intForKey:@"total_pages"];
                isUserInfoLoaded = YES;
                [self loadImages];
                [self refreshUserInfo];
            }
            break;
        }
        case PDUserViewSourceCollections:{
            if ([serverExchange isKindOfClass:[PDServerGetUserPins class]]) {
                self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
                self.totalPages = [result intForKey:@"total_pages"];
            }
            break;
        }
        case PDUserViewSourceFollowers:{
            if ([serverExchange isKindOfClass:[PDServerUserFollowersLoader class]]) {
                self.items = [serverExchange loadUsersFromArray:result[@"users"]];
                self.totalPages = [result intForKey:@"total_pages"];
            }
            break;
        }
        default:
            break;
    }
    [self refreshView];
    
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error
{
    [super serverExchange:serverExchange didFailWithError:error];
    self.itemsTableView.hidden = NO;
}

@end
