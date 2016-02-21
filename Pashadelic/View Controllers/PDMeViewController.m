//
//  PDMeViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 8/11/12.
//
//

#import "PDMeViewController.h"
#import "PDServerCheckStatusPhotos.h"

enum PDMeViewSource {
	PDMeViewSourcePhotos = 0,
	PDMeViewSourcePins,
	PDMeViewSourceFollowers,
	PDMeViewSourceFollowings
};

@interface PDMeViewController ()

@property (strong, nonatomic) UIView *buttonSelectionView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *photosNeedCheck;
- (void)initUsersTable;
- (void)refreshCurrentTable;
- (void)showSettings;
- (void)refreshUserProfile;
- (void)initToolbarView;
- (void)initPhotoUserTableView;
- (void)startTimer;
- (void)stopTimer;

@end

@implementation PDMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
		self.myFeedViewSource = PDMeViewSourcePhotos;
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Me", nil);
    [self initToolbarView];
	[self initUsersTable];
    [self initPhotoUserTableView];
	[self refreshSourceButtons];
	if (!_isLeftButtonToBack) {
        [self setLeftButtonToMainMenu];
    }
    else [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[self refreshView];
	[self refetchData];
    self.toolbarView.backgroundColor = self.tablePlaceholderView.backgroundColor;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserProfile)
                                                 name:kPDSuccessLoggedInNotification
                                               object:nil];
}

- (void)setIsLeftButtonToBack:(BOOL)isLeftButtonToBack
{
    _isLeftButtonToBack = isLeftButtonToBack;
    if (_isLeftButtonToBack) {
        [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    }

}



- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.profile = kPDAppDelegate.userProfile;
	[self refreshSourceButtons];
}


#pragma mark - Private

- (void)initToolbarView
{
    NSArray *buttons = @[self.sourceFollowersButton, self.sourceFollowingsButton, self.sourcePhotosButton, self.sourcePinsButton];
    for (UIButton *button in buttons) {
        [button applyGlobalFont];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:kPDGlobalRedColor forState:UIControlStateSelected];
        [button setTitleColor:kPDGlobalRedColor forState:UIControlStateSelected|UIControlStateHighlighted];
    }
	self.sourceFollowingsButton.titleLabel.numberOfLines = self.sourceFollowersButton.titleLabel.numberOfLines = self.sourcePhotosButton.titleLabel.numberOfLines = self.sourcePinsButton.titleLabel.numberOfLines = 0;
	self.sourceFollowingsButton.titleLabel.textAlignment = self.sourceFollowersButton.titleLabel.textAlignment = self.sourcePhotosButton.titleLabel.textAlignment = self.sourcePinsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
  
    self.buttonSelectionView = [[UIView alloc] initWithFrame:CGRectZero];
    self.buttonSelectionView.backgroundColor = kPDGlobalRedColor;
    [self.toolbarView addSubview:self.buttonSelectionView];
}

- (void)refreshUserProfile
{
	self.profile = kPDAppDelegate.userProfile;
	[self refreshView];
}

- (void)showSettings
{
	if (!_profileSettingsViewController) {
		_profileSettingsViewController = [[PDProfileSettingsViewController alloc] initWithNibName:@"PDProfileSettingsViewController" bundle:nil];
	}
	_profileSettingsViewController.profile = _profile;
	[self.navigationController pushViewController:_profileSettingsViewController animated:YES];
	[_profileSettingsViewController fetchData];
}

- (void)initPhotoUserTableView
{
    self.photoUsersTableView = [[PDPhotoUserTableView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.tablePlaceholderView.frame.size)];
	self.photoUsersTableView.itemsTableDelegate = self;
    self.photoUsersTableView.photoViewDelegate = self;
	[self.tablePlaceholderView addSubview:_photoUsersTableView];
    self.photoUsersTableView.tableViewMode = PDItemsTableViewModeList;
}

- (void)initUsersTable
{
	self.usersTableView = [[PDUsersTableView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.tablePlaceholderView.frame.size)];
	_usersTableView.itemsTableDelegate = self;
	[self.tablePlaceholderView addSubview:_usersTableView];
}

- (void)refreshCurrentTable
{
	if (self.myFeedViewSource == PDMeViewSourceFollowings || self.myFeedViewSource == PDMeViewSourceFollowers) {
		self.photoUsersTableView.hidden = YES;
        self.photosTableView.hidden = YES;
		self.usersTableView.hidden = NO;
		self.itemsTableView = self.usersTableView;
		
	} else if (self.myFeedViewSource == PDMeViewSourcePhotos ) {
		self.usersTableView.hidden = YES;
        self.photosTableView.hidden = YES;
		self.photoUsersTableView.hidden = NO;
		self.itemsTableView = self.photoUsersTableView;
	} else if (self.myFeedViewSource == PDMeViewSourcePins) {
        self.usersTableView.hidden = YES;
        self.photosTableView.hidden = NO;
		self.photoUsersTableView.hidden = YES;
		self.itemsTableView = self.photosTableView;
    }
	[self.tablePlaceholderView bringSubviewToFront:self.itemsTableView];
}

- (void)startTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                             target:self
                                            selector:@selector(fetchStatusListPhotos)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)stopTimer
{
    [self.photosNeedCheck removeAllObjects];
    [_timer invalidate];
    _timer = nil;
}

- (void)photo:(PDPhoto *)photo didSelectInView:(UIView *)view image:(UIImage *)image
{
    if (!photo.spotId) return;
    [super photo:photo didSelectInView:view image:image];
}

#pragma mark - Public

- (void)showMainMenu
{
	[super showMainMenu];
	self.profileSettingsViewController = nil;
	self.userViewController = nil;
}

- (void)setProfile:(PDUserProfile *)profile
{
	_profile = profile;
	self.item = profile;
}

- (void)userChangedNotification:(NSNotification *)notification
{
	if ([notification.userInfo intForKey:@"identifier"] == _profile.identifier) {
		[self refreshView];
	}
}

- (NSString *)pageName
{
	switch (_myFeedViewSource) {
		case PDMeViewSourceFollowings:
			return @"My Followings";
			
		case PDMeViewSourcePhotos:
			return @"My Photos";
      
		case PDMeViewSourcePins:
			return @"My Pins";
      
		case PDMeViewSourceFollowers:
			return @"My Followers";
      
	}
	return @"Me";
}

- (IBAction)changeSource:(id)sender
{
	if ([sender isEqual:self.sourceFollowingsButton]) {
		if (_myFeedViewSource == PDMeViewSourceFollowings) return;
		_myFeedViewSource = PDMeViewSourceFollowings;
		self.title = NSLocalizedString(@"My Followings", nil);
		
	} else if ([sender isEqual:_sourcePhotosButton]) {
		if (_myFeedViewSource == PDMeViewSourcePhotos) return;
		_myFeedViewSource = PDMeViewSourcePhotos;
		self.title = NSLocalizedString(@"My Photo spots", nil);
		
	} else if ([sender isEqual:_sourcePinsButton]) {
		if (_myFeedViewSource == PDMeViewSourcePins) return;
		_myFeedViewSource = PDMeViewSourcePins;
		self.title = NSLocalizedString(@"My Wannago", nil);
		
	} else if ([sender isEqual:_sourceFollowersButton]) {
		if (_myFeedViewSource == PDMeViewSourceFollowers) return;
		_myFeedViewSource = PDMeViewSourceFollowers;
		self.title = NSLocalizedString(@"My Followers", nil);
	}
	self.itemsTableView.items = nil;
	[self refreshSourceButtons];
	[self refetchData];
	[self trackCurrentPage];
}

- (void)refreshView
{
	if (!self.isViewLoaded) return;
	
	[super refreshView];
	[self refreshSourceButtons];
}

- (void)refreshSourceButtons
{
	_sourceFollowingsButton.selected = (_myFeedViewSource == PDMeViewSourceFollowings);
	_sourceFollowersButton.selected = (_myFeedViewSource == PDMeViewSourceFollowers);
	_sourcePhotosButton.selected = (_myFeedViewSource == PDMeViewSourcePhotos);
	_sourcePinsButton.selected = (_myFeedViewSource == PDMeViewSourcePins);
  
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"followings\n%@", nil),
                    [_profile countValueInString:_profile.followingsCount]] forButton:_sourceFollowingsButton];
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"followers\n%@", nil),
                    [_profile countValueInString:_profile.followersCount]] forButton:_sourceFollowersButton];
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"photos\n%@", nil),
                    [_profile countValueInString:_profile.photosCount]] forButton:_sourcePhotosButton];
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"wannagos\n%@", nil),
                    [_profile countValueInString:_profile.pinsCount]] forButton:_sourcePinsButton];
  
  NSArray *buttons = @[self.sourceFollowersButton, self.sourceFollowingsButton, self.sourcePhotosButton, self.sourcePinsButton];
  
  for (UIButton *button in buttons) {
    if (button.isSelected) {
      [UIView animateWithDuration:0.15 animations:^{
      self.buttonSelectionView.frame = CGRectMake(button.x + 10, button.y, button.width - 20, 8);
      }];
    }
  }
}

- (void)setTitle:(NSString *)title forButton:(PDToolbarGradientButton *)button
{
    [button setTitle:title forState:UIControlStateSelected];
	[button setTitle:title forState:UIControlStateNormal];
}

- (void)refetchData
{
	[self refreshCurrentTable];
	[super refetchData];
}

- (void)fetchData
{
	[super fetchData];
	switch (_myFeedViewSource) {
		case PDMeViewSourceFollowings: {
			self.serverExchange = [[PDServerProfileUsersLoader alloc] initWithDelegate:self];
			[self.serverExchange loadUsersForProfile:_profile page:self.currentPage usersType:@"followed_users"];
			break;
		}
			
		case PDMeViewSourcePhotos: {
			self.serverExchange = [[PDServerProfilePhotosLoader alloc] initWithDelegate:self];
			[self.serverExchange loadPhotosForProfile:_profile page:self.currentPage];
			break;
		}
			
		case PDMeViewSourcePins : {
			self.serverExchange = [[PDServerGetMyPins alloc] initWithDelegate:self];
			[self.serverExchange loadPinnedPhotosForProfile:_profile page:self.currentPage];
			break;
		}
			
		case PDMeViewSourceFollowers : {
			self.serverExchange = [[PDServerProfileUsersLoader alloc] initWithDelegate:self];
			[self.serverExchange loadUsersForProfile:_profile page:self.currentPage usersType:@"followers"];
			break;
		}
			
		default : {
		}
	}
}

- (void)checkSpotIDphoto
{

    if (!self.photosNeedCheck) {
        self.photosNeedCheck = [[NSMutableArray alloc] init];
    }
    for (int i = 0; i < self.items.count; i ++) {
        PDPhoto *photo = (PDPhoto *)[self.items objectAtIndex:i];
        if (photo.identifier == [kPDUserDefaults integerForKey:kPDPhotoUploadedIdKey]) {
            [self.photosNeedCheck addObject:photo];
        }
    }
    if (self.photosNeedCheck.count > 0) {
        [self startTimer];
    }
}

- (void)fetchStatusListPhotos
{
    if (self.photosNeedCheck.count == 0) {
        [self stopTimer];
        return;
    }
    
    _turnCheckSpotID ++;
    self.serverExchange = [[PDServerCheckStatusPhotos alloc] initWithDelegate:self];
    [self.serverExchange checkStatusListPhotos:self.photosNeedCheck];
    if (_turnCheckSpotID == 10) {
        _turnCheckSpotID = 0;
        [self stopTimer];
    }
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	if (![self.serverExchange isEqual:serverExchange]) return;
	
	[super serverExchange:serverExchange didParseResult:result];
    if ([serverExchange isKindOfClass:[PDServerCheckStatusPhotos class]]) {
        NSArray *photos = result[@"photos"];
        if (photos.count == 0) {
            [self refreshView];
            [self stopTimer];
            return ;
        }
        
        for (int  i = 0; i < self.photosNeedCheck.count; i ++) {
            for (int j = 0; j < photos.count; j ++) {
                PDPhoto *photo = (PDPhoto *)self.photosNeedCheck[i];
                NSDictionary *resultPhoto = (NSDictionary *)photos[j];
                int photoID = [resultPhoto intForKey:@"id"];
                
                if (photoID == photo.identifier ) {
                    if ([resultPhoto intForKey:@"spot_id"] != 0) {
                        photo.spotId = [resultPhoto intForKey:@"spot_id"];
                        [self refreshView];
                        [self.photosNeedCheck removeObject:photo];
                    }
                }
            }
            
        }
        
    } else {
        if ([serverExchange isKindOfClass:[PDServerProfileUsersLoader class]]) {
            self.items = [serverExchange loadUsersFromArray:result[@"users"]];
        } else {
            self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
            if (self.myFeedViewSource == PDMeViewSourcePhotos) {
                [self checkSpotIDphoto];
            }
        }
        NSInteger totalCount = [result intForKey:@"total_count"];
        
        switch (self.myFeedViewSource) {
            case PDMeViewSourceFollowers:
                kPDAppDelegate.userProfile.followersCount = totalCount;
                break;
                
            case PDMeViewSourceFollowings:
                kPDAppDelegate.userProfile.followingsCount = totalCount;
                break;
                
            case PDMeViewSourcePhotos:
                kPDAppDelegate.userProfile.photosCount = totalCount;
                break;
                
            case PDMeViewSourcePins:
                kPDAppDelegate.userProfile.pinsCount = totalCount;
                break;
        }
        self.totalPages = [result intForKey:@"total_pages"];
        [self refreshView];
    }
	
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	[super serverExchange:serverExchange didFailWithError:error];
}


#pragma mark - Item select delegate

- (void)itemDidSelect:(PDItem *)item
{
	if ([item isKindOfClass:[PDPhoto class]]) {
		[super itemDidSelect:item];
		
	} else 	if ([item isKindOfClass:[PDUser class]]) {
		if (!self.userViewController) {
			self.userViewController = [[PDUserViewController alloc] initWithNibName:@"PDUserViewController" bundle:nil];
		}
		self.userViewController.user = (PDUser *) item;
		[self.navigationController pushViewController:self.userViewController animated:YES];
	}
}

@end
