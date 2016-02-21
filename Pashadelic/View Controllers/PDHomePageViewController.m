//
//  PDHomepageViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.09.13.
//
//

#import "PDHomePageViewController.h"
#import "UIImage+Extra.h"
#import "PDServerGetFeed.h"
#import "PDServerGetActivities.h"
#import "PDServerGetMyPins.h"
#import "PDActivityItem.h"
#define TopOffset 5

@interface PDHomePageViewController ()

@property (strong, nonatomic) PDDrawMoon *moonView;

@property (nonatomic, strong) PDWeatherLoader *weatherLoader;
@property (strong, nonatomic) PDForeCastWeatherViewController *forecastViewController;
@property (strong, nonatomic) PDServerGetFeed *serverGetFeed;
@property (strong, nonatomic) PDServerGetActivities *serverGetActivities;
@property (strong, nonatomic) NSTimer *refreshNearbyTimer;

- (void)initFeedTableView;
- (void)initSourceButtons;
- (void)initTopBar;
- (void)initMoonView;
- (void)refreshNearbyPinsInfo;
- (void)invalidateRefreshNearbyTimer;
- (void)initNearbyCollectView;
- (void)refreshTopBar;
- (void)refreshUpcomingAcivityView;
- (void)fetchWeatherInfo;
- (void)refreshMoon;
- (void)refreshCurrentTable;

@end

@implementation PDHomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initSourceButtons];
	[self initNearbyCollectView];
    
	[self changeSource:self.sourceFeedButton];
    [self initTopBar];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUnreadItemsIcon)
                                                 name:kPDUnreadItemsCountChangedNotification
                                               object:nil];
    [self initLocationService];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	self.dateLabel.text = [[NSDate date] stringValueFormattedBy:@"MMM\nd"];
	[self setValueForDateLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.tablePlaceholderView.y = self.topBarView.height;
	self.tablePlaceholderView.height = self.view.height - self.tablePlaceholderView.y;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.noInternetButton.frame = CGRectMakeWithSize(0, self.topBarView.bottomYPoint, self.tablePlaceholderView.frame.size);

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleBlack;
}

- (void)applyOffsetToInitialThumbnailFrame
{
}

#pragma mark - Private

- (void)initTopBar
{
    [self initMoonView];
    [self.showMenuButton addTarget:self action:@selector(showMainMenu) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
	[self.forecastButton setFontAwesomeIconForImage:[FAKFontAwesome ellipsisVIconWithSize:self.forecastButton.height - 6]
                                           forState:UIControlStateNormal
                                         attributes:attributes];
    self.forecastButton.enabled = NO;
    self.forecastButtonOverlay.enabled = NO;
    self.topBarView.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1];
}

//- (void)initNoInternetButton
//{
//	self.noInternetButton = [[UIButton alloc] initWithFrame:CGRectMakeWithSize(0, self.topBarView.bottomYPoint, self.tablePlaceholderView.frame.size)];
//	self.noInternetButton.backgroundColor = [UIColor whiteColor];
//	[self.noInternetButton addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventTouchUpInside];
//	[self.noInternetButton setImage:[UIImage imageNamed:@"btn_no_internet_connection_off.png"] forState:UIControlStateNormal];
//	self.noInternetButton.hidden = YES;
//	[self.view addSubview:self.noInternetButton];
//}

- (void)initMoonView
{
	self.moonView = [[PDDrawMoon alloc] initWithFrame:self.moonViewPlaceholder.zeroPositionFrame andRadius:10 option:0];
	[self.moonView clearBackgroundColor];
	[self.moonViewPlaceholder addSubview:self.moonView];
}

- (void)fetchWeatherInfo
{
    if (self.weatherLoader) {
        self.weatherLoader.delegate = nil;
        self.weatherLoader = nil;
    }
    self.weatherLoader = [[PDWeatherLoader alloc] initWithDelegate:self];
    [self.weatherLoader loadCurrentWeatherWithLatitude:[[PDLocationHelper sharedInstance] latitudes]
                                             longitude:[[PDLocationHelper sharedInstance] longitudes]];
}

- (void)refreshUnreadItemsIcon
{
    [super refreshUnreadItemsIcon];
    BOOL unreadItems = (kPDAppDelegate.userProfile.unreadItemsCount > 0);
    [self.showMenuButton setImage:[UIImage imageNamed:unreadItems ? @"btn-main-menu-white-with-notification.png"
                                                     :@"btn-main-menu-white.png"]
                         forState:UIControlStateNormal];
}

- (void)setValueForDateLabel
{
    NSString *monthString =[ [NSDate date] stringValueFormattedBy:@"MMM"];
    monthString = [monthString stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.dateLabel.text = monthString;
    self.dayLabel.text = [NSString stringWithFormat:@"%zd",[[[NSDate date] stringValueFormattedBy:@"dd"]intValue]];
}

- (void)refreshTopBar
{
    self.forecastButton.enabled = YES;
    self.forecastButtonOverlay.enabled = YES;
    [self setValueForDateLabel];
    [self fetchWeatherInfo];
    [self refreshMoon];
    [self refreshUpcomingAcivityView];
}

- (void)refreshUpcomingAcivityView
{
 	__block NSDate *now = [NSDate date];
	__block NSDate *upcomingEvent = [now dateByAddingTimeInterval:kNSDateOneWeekInterval];
	__block NSString *name;
	SunMoonCalcGobal *sunMoonCalculator = [[SunMoonCalcGobal alloc] init];
	NSInteger i = 0;
	while ([upcomingEvent isEqualToDate:[now dateByAddingTimeInterval:kNSDateOneWeekInterval]]) {
		NSMutableDictionary *upcomingEvents = [[sunMoonCalculator getSunTimesWithDate:[now dateByAddingTimeInterval:kNSDateOneDayInterval * i]
                                                                          andLatitude:[[PDLocationHelper sharedInstance] latitudes]
                                                                          andLogitude:[[PDLocationHelper sharedInstance] longitudes]] mutableCopy];
        [upcomingEvents removeObjectForKey:@"nadir"];
        [upcomingEvents removeObjectForKey:@"nauticalDawn"];
        [upcomingEvents removeObjectForKey:@"nauticalDusk"];
        [upcomingEvents removeObjectForKey:@"night"];
        [upcomingEvents removeObjectForKey:@"nightEnd"];
        [upcomingEvents removeObjectForKey:@"solarNoon"];
		
		[upcomingEvents enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			if ([obj isKindOfClass:[NSDate class]]) {
				NSDate *date = obj;
                
				if ([date isLaterThanDate:now]) {
					if ([date isEarlierThanDate:upcomingEvent]) {
						upcomingEvent = date;
                        if ([key isEqualToString:@"dawn"] || [key isEqualToString:@"sunset"]) {
                            name = @"blue hour";
                        }
                        else if ([key isEqualToString:@"sunrise"] || [key isEqualToString:@"dusk"]){
                            name = @"blue hour end";
                        }
                        else if ([key isEqualToString:@"sunriseEnd"] || [key isEqualToString:@"goldenHour"]){
                            name = @"golden hour";
                            
                        }
                        else if ([key isEqualToString:@"goldenHourEnd"] || [key isEqualToString:@"sunsetStart"]){
                            name = @"golden hour end";
                        }
                        
					}
				}
			}
		}];
		i++;
	}
	if (name.length > 0) {
		NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-z])([A-Z])" options:0 error:NULL];
		name = [[regexp stringByReplacingMatchesInString:name options:0 range:NSMakeRange(0, name.length) withTemplate:@"$1 $2"] lowercaseString];
	}
	self.upcomingEventLabel.text = NSLocalizedString(name, nil);
	self.upcomingEventTimeLabel.text = [upcomingEvent stringValueFormattedBy:@"HH:mm"];
	self.upcomingEventTimeLabel.x = self.upcomingEventLabel.rightXPoint + 2;
}

- (void)refreshMoon
{
	SunMoonCalcGobal *sunMoonCalculator = [[SunMoonCalcGobal alloc] init];
	NSDate *date = [NSDate date];
	double fraction = [sunMoonCalculator getMoonFraction:date];
	double fractionNext = [sunMoonCalculator getMoonFraction:[date dateByAddingTimeInterval:kNSDateOneHourInterval]];
	BOOL firstQuarterPhase = (fractionNext - fraction) > 0;
	self.moonView.option = fraction;
	
	if (([[PDLocationHelper sharedInstance] longitudes] > 0 && firstQuarterPhase)
        || ([[PDLocationHelper sharedInstance] latitudes] < 0 && !firstQuarterPhase)) {
        self.moonView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)initUsersTable
{
	self.usersTableView = [[PDUsersTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.usersTableView.itemsTableDelegate = self;
	self.usersTableView.firstSectionHeader = self.recommendedView;
	[self.tablePlaceholderView addSubview:self.usersTableView];
}

- (void)initFeedTableView
{
	self.feedTableView = [[PDFeedTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.feedTableView.itemsTableDelegate = self;
	self.feedTableView.photoViewDelegate = self;
	[self.tablePlaceholderView addSubview:self.feedTableView];
}

- (void)initActivitiesTable
{
	self.activitesTableView = [[PDActivitiesTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.activitesTableView.itemsTableDelegate = self;
	self.activitesTableView.photoViewDelegate = self;
	[self.tablePlaceholderView addSubview:self.activitesTableView];
}

- (void)initNearbyCollectView
{
	[self.nearbyCollectContentView setRoundedCornersWithShadowStyle];
	[self.nearbyCollectDisclosureImage setFontAwesomeIconForImage:[FAKFontAwesome ellipsisVIconWithSize:35]
                                                   withAttributes:@{NSForegroundColorAttributeName : kPDGlobalRedColor}];
}

- (void)initSourceButtons
{
    [self.sourceFeedButton setTitle:NSLocalizedString(@"Feed", nil) forState:UIControlStateNormal];
    [self.sourceActivitiesButton setTitle:NSLocalizedString(@"Activities", nil) forState:UIControlStateNormal];
	NSArray *buttons = @[self.sourceActivitiesButton, self.sourceFeedButton];
	[self applyDefaultStyleToButtons:buttons];
}

- (void)fullscreenMode:(bool)fullscreenMode animated:(bool)animated
{
	if (self.parentViewController) {
		self.fullscreenMode = fullscreenMode;
		[(PDViewController *) self.parentViewController fullscreenMode:fullscreenMode animated:animated];
	} else {
		[super fullscreenMode:fullscreenMode animated:animated];
	}
}

- (void)refreshNearbyPinsInfo
{
	if (self.refreshNearbyTimer) return;
	self.refreshNearbyTimer = [NSTimer scheduledTimerWithTimeInterval:10
                                                               target:self
                                                             selector:@selector(invalidateRefreshNearbyTimer)
                                                             userInfo:nil
                                                              repeats:NO];
	
    
	[kPDAppDelegate.userProfile.nearbyPins removeAllObjects];
	@synchronized(kPDAppDelegate.userProfile.pins) {
		for (PDPhoto *photo in kPDAppDelegate.userProfile.pins) {
			if (photo.distanceInMeters <= kPDShowNearbyPinDistance * 1000) {
				[kPDAppDelegate.userProfile.nearbyPins addObject:photo];
			}
		}
	}
	NSUInteger oldHeight = self.itemsTableView.tableHeaderView.height;
	if (kPDAppDelegate.userProfile.nearbyPins.count == 0) {
		[self.nearbyCollectView removeFromSuperview];
		self.toolbarView.height = self.sourceFeedButton.height + TopOffset * 2;
	} else {
		[self.nearbyCollectImage1 sd_setImageWithURL:[[kPDAppDelegate.userProfile.nearbyPins objectAtIndexOrNil:0] thumbnailURL]];
		[self.nearbyCollectImage2 sd_setImageWithURL:[[kPDAppDelegate.userProfile.nearbyPins objectAtIndexOrNil:1] thumbnailURL]];
		[self.nearbyCollectImage3 sd_setImageWithURL:[[kPDAppDelegate.userProfile.nearbyPins objectAtIndexOrNil:2] thumbnailURL]];
		self.nearbyCollectLabel.text = [NSString stringWithFormat:MGLocalized(@"%zd nearby + collect"), kPDAppDelegate.userProfile.nearbyPins.count];
		self.toolbarView.height = self.nearbyCollectView.height + self.sourceFeedButton.height + TopOffset;
		[self.toolbarView addSubview:self.nearbyCollectView];
	}
	if (oldHeight != self.toolbarView.height) {
		self.itemsTableView.tableHeaderView = self.toolbarView;
	}
    
}

- (void)refreshCurrentTable
{
    if (self.sourceFeedButton.isSelected) {
		if (!self.feedTableView) {
			[self initFeedTableView];
		}
		self.feedTableView.hidden = NO;
		self.photosTableView.hidden = YES;
		self.activitesTableView.hidden = YES;
		self.itemsTableView = self.feedTableView;
		
	} else if (self.sourceActivitiesButton.isSelected) {
		if (!self.activitesTableView) {
			[self initActivitiesTable];
		}
		self.activitesTableView.hidden = NO;
		self.photosTableView.hidden = YES;
		self.feedTableView.hidden = YES;
		self.itemsTableView = self.activitesTableView;
	}
}

- (void)invalidateRefreshNearbyTimer
{
	[self.refreshNearbyTimer invalidate];
	self.refreshNearbyTimer = nil;
}

#pragma mark - Override

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    [self refreshTopBar];
    [self refreshNearbyPinsInfo];
}

- (void)updateLocation
{
    [super updateLocation];
    [[PDLocationHelper sharedInstance] updateLocation:^(NSError *error, CLLocation *location){
        if (error) {
            self.forecastButton.enabled = NO;
            self.forecastButtonOverlay.enabled = NO;
            [self updateLocationDidFailWithError:error];
            return;
        }
        isLocationReceived = YES;
        [self refreshTopBar];
        [self refreshNearbyPinsInfo];
    }];
    
}

- (void)locationChanged:(NSNotification *)notification
{
    [super locationChanged:notification];
    [self refreshTopBar];
    [self refreshNearbyPinsInfo];
}

- (void)fetchData
{
    if (!kPDAppDelegate.userLoggedIn) return;
    [super fetchData];
	[self.serverGetFeed cancel];
	[self.serverGetActivities cancel];
    
	if (self.sourceFeedButton.isSelected) {
        if (!self.serverGetFeed) {
            self.serverGetFeed = [[PDServerGetFeed alloc] initWithDelegate:self];
        }
        [self.serverGetFeed getFeedPage:self.currentPage];
    } else if (self.sourceActivitiesButton.isSelected) {
		if (!self.serverGetActivities) {
			self.serverGetActivities = [[PDServerGetActivities alloc] initWithDelegate:self];
		}
        if (self.currentPage == 1)
            self.firstActivitiesLoadedDateTime = self.currentDate;
        
        [self.serverGetActivities getFeedAndActivitiesPage:self.currentPage firstLoadedTime:self.firstActivitiesLoadedDateTime];
    }
}

- (NSString *)pageName
{
	if (self.sourceFeedButton.selected) {
		return @"Home Feed";
	} else if (self.sourceActivitiesButton.selected) {
		return @"Home Activities";
	}
	return @"Home";
}

#pragma mark - Actions

- (void)showForecast:(id)sender
{
	if (!self.forecastViewController) {
		self.forecastViewController = [[PDForeCastWeatherViewController alloc] initForUniversalDevice];
	}
    self.forecastViewController.currentDate = [self currentDate];
	CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:[[PDLocationHelper sharedInstance] latitudes]
                                                          longitude:[[PDLocationHelper sharedInstance] longitudes]];
	self.forecastViewController.userLocation = userLocation;
	PDWeather *todayWeather = [[PDWeather alloc] init];
	todayWeather.iconImage = self.weatherImageView.image;
	self.forecastViewController.todayWeather = todayWeather;
    [self.navigationController pushViewController:self.forecastViewController animated:YES];
    [self.forecastViewController fetchData];
}

- (IBAction)changeSource:(id)sender
{
	if ([sender isSelected]) return;
	
	self.sourceFeedButton.selected = NO;
    self.sourceActivitiesButton.selected = NO;
	[sender setSelected:YES];
	[self refreshCurrentTable];
	[self refetchData];
}

- (IBAction)showNearbyCollect:(id)sender
{
	[self.navigationController pushViewControllerWithName:@"PDNearbyPinsViewController" animated:YES];
}

#pragma mark - Gesture Recognizer

- (void)swipeLeftGestureHandler
{
    if (self.sourceFeedButton.isSelected) {
        [self changeSource:self.sourceActivitiesButton];
    } else if (self.sourceActivitiesButton.isSelected) {
        return;
    }
}

- (void)swipeRightGestureHandler
{
    CGPoint gestureLocation = [self.rightSwipeGesture locationInView:self.view];
    if (gestureLocation.x < 5) {
        [super swipeRightGestureHandler];
    } else {
        if (self.sourceActivitiesButton.selected)
            [self changeSource:self.sourceFeedButton];
        else if (self.sourceFeedButton.isSelected)
            return;
    }
}

#pragma mark - Server exchange

- (void)serverExchange:(id)serverExchange didParseResult:(id)result
{
	if ([serverExchange isEqual:self.weatherLoader]) {
        PDWeather *currentWeather = (PDWeather *)[self.weatherLoader loadCurrentWeatherFromResult];
        self.weatherImageView.image = currentWeather.iconImage;
        [self.locationButton setTitle:[NSString stringWithFormat:@"%@, %@", currentWeather.name, currentWeather.country]
                             forState:UIControlStateNormal];
		return;
    }
    
	if ([result objectForKey:@"users"]) {
		if (!self.usersTableView) {
			[self initUsersTable];
		}
		self.usersTableView.hidden = NO;
		self.photosTableView.hidden = YES;
        self.feedTableView.hidden = YES;
        self.activitesTableView.hidden = YES;
		self.itemsTableView = self.usersTableView;
		self.totalPages = [result intForKey:@"total_pages"];
		self.items = [serverExchange loadUsersFromResult:result];
	} else {
        self.usersTableView.hidden = YES;
        if (self.sourceFeedButton.isSelected && [serverExchange isKindOfClass:[PDServerGetFeed class]]) {
            self.totalPages = [result intForKey:@"total_pages"];
            self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
			
		} else if (self.sourceActivitiesButton.isSelected && [serverExchange isKindOfClass:[PDServerGetActivities class]]) {
			self.totalPages = self.currentPage + [result boolForKey:@"try_paginate"];
			self.items = [serverExchange loadActivityItemsFromArray:result[@"activities"]];
		}
	}
    
    [super serverExchange:serverExchange didParseResult:result];
    [self refreshView];
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error
{
    [super serverExchange:serverExchange didFailWithError:error];
}

@end
