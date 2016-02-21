//
//  PDViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDViewController.h"
#import "PDUserViewController.h"
#import "PDUserProfile.h"
#import "PDMainMenuViewController.h"
#import "PDBarButton.h"
#import "PDMeViewController.h"
#import "UIView+Pashadelic.h"

@interface PDViewController ()
{
	PDBarButton *mainMenuButton;
	UIButton *backButton;
}

@property (assign, nonatomic, getter = isGlobalStyleApplied) BOOL globalStyleApplied;
- (void)initNoInternetButton;
- (void)initLoadingView;
- (PDGradientButton *)gradientBarButtonWithTitle:(NSString *)title;
@end


@implementation PDViewController
@synthesize serverExchange, loadingView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.automaticallyAdjustsScrollViewInsets = YES;
	}
    
	UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMainMenu)];
	rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:rightSwipeGesture];
    
	self.leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftGestureHandler)];
	self.leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:self.leftSwipeGesture];
    
	self.rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightGestureHandler)];
	self.rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:self.rightSwipeGesture];
    
    _navigationBarStyle = PDNavigationBarStyleWhite;
	self.loading = NO;
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	self.navigationItem.title = @"";
	[self initLoadingView];
	[self showInitialHelp];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refetchData)
                                                 name:kPDSuccessLoggedInNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshUnreadItemsIcon)
                                                 name:kPDUnreadItemsCountChangedNotification
                                               object:nil];
	self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:20];
}

- (void)hideLoadingView
{
    self.loadingView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    if (!self.isGlobalStyleApplied) {
        self.globalStyleApplied = YES;
        [self.view applyGlobalStyleToAllSubviews];
    }
    
	[self trackCurrentPage];
	if (viewTitle.length > 0) {
		[self setTitle:viewTitle];
	} else {
		[self setTitle:@""];
	}
    
	self.customNavigationBar.titleButton.hidden = YES;
	if ([self respondsToSelector:@selector(toggleToolbarView:)] && self.toolbarView) {
		self.customNavigationBar.titleButton.hidden = NO;
	}
	[self setNavigationBarStyle:self.defaultNavigationBarStyle];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	CGRect rect = [self.view.window convertRect:self.view.zeroPositionFrame fromView:self.view];
	int y = rect.origin.y;
	self.loadingView.frame = CGRectMake(0, -y, self.view.width, self.view.height + y);
    self.noInternetButton.frame = CGRectMakeWithSize(0, 0, self.view.frame.size);
	[self.view bringSubviewToFront:self.loadingView];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)shouldAutorotate
{
	return NO;
}

#pragma mark - Private

- (void)layoutLoadingView
{
}

- (void)trackCurrentPage
{
	NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![bundleIdentifier isEqualToString:kPDAppProductionBundleID]) return;
    
	[[PDGoogleAnalytics sharedInstance] trackPage:self.pageName];
}

- (void)trackEvent:(NSString *)event
{
	NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![bundleIdentifier isEqualToString:kPDAppProductionBundleID]) return;
    
    [[Mixpanel sharedInstance] track:event properties:@{@"Page" : self.pageName}];
	[[PDGoogleAnalytics sharedInstance] trackAction:event atPage:self.pageName];
}

- (void)refreshUnreadItemsIcon
{
	mainMenuButton.selected = (kPDAppDelegate.userProfile.unreadItemsCount > 0);
}

- (NSString *)pageName
{
	NSLog(@"No page name for %@", NSStringFromClass([self class]));
	return [NSString stringWithFormat:@"/%@", NSStringFromClass([self class])];
}

- (void)releaseMapMemory:(MKMapView *)map
{
	if (!map) return;
	
	@autoreleasepool {
		switch (map.mapType) {
			case MKMapTypeHybrid:
				map.mapType = MKMapTypeStandard;
				map.mapType = MKMapTypeHybrid;
				break;
				
			case MKMapTypeStandard:
				map.mapType = MKMapTypeHybrid;
				map.mapType = MKMapTypeStandard;
				break;
				
			case MKMapTypeSatellite:
				map.mapType = MKMapTypeStandard;
				map.mapType = MKMapTypeSatellite;
				break;
                
			default:
				break;
		}
	}
}

- (PDNavigationBar *)customNavigationBar
{
	if ([self.navigationController.navigationBar isKindOfClass:[PDNavigationBar class]]) {
		return (PDNavigationBar *)self.navigationController.navigationBar;
	} else {
		return nil;
	}
}

- (void)setLeftButtonToMainMenu
{
    mainMenuButton = [self setLeftBarButtonToImage:[UIImage imageNamed:@"btn-main-menu.png"]
                                            offset:CGSizeMake(0, -5)
                                        withAction:@selector(showMainMenu)];
	[mainMenuButton setImageForSelectedState:[UIImage imageNamed:@"btn-main-menu-with-notification.png"]];
	[self refreshUnreadItemsIcon];
}

- (void)showMainMenu
{
    [kPDAppDelegate.mainMenuViewController showMainMenu];
}

- (void)swipeLeftGestureHandler
{
}

- (void)swipeRightGestureHandler
{
    [self showMainMenu];
}

- (void)showHelp
{
	kPDAppDelegate.helpView.items = self.helpItems;
	[kPDAppDelegate.helpView showHelp];
}

- (void)showInitialHelp
{
	NSArray *helpItems = self.helpItems;
	if (helpItems.count == 0) return;
	NSMutableArray *items = [NSMutableArray array];
	for (NSDictionary *item in helpItems) {
		if ([item[@"IsInitial"] boolValue]) {
			if (![kPDAppDelegate.shownHelpItems containsObject:item[@"Text"]]) {
				[items addObject:item];
				[kPDAppDelegate.shownHelpItems addObject:item[@"Text"]];
			}
		}
	}
	kPDAppDelegate.helpView.items = items;
	[kPDAppDelegate.helpView showHelp];
}

- (void)applyShadowAndRoundedCornersToToolbarView
{
	if (!self.toolbarView) return;
	
	UIView *roundedCornersView = [self.toolbarView viewWithTag:8726];
	if (!roundedCornersView) {
		roundedCornersView = [[UIView alloc] initWithFrame:self.toolbarView.zeroPositionFrame];
		[roundedCornersView clearBackgroundColor];
		roundedCornersView.clipsToBounds = YES;
		roundedCornersView.layer.cornerRadius = 5;
		roundedCornersView.tag = 8726;
	} else {
		[roundedCornersView removeFromSuperview];
	}
	for (UIView *subview in self.toolbarView.subviews) {
		[roundedCornersView addSubview:subview];
	}
	
	[self.toolbarView addSubview:roundedCornersView];
	self.toolbarView.layer.shadowOffset = CGSizeZero;
	self.toolbarView.layer.shadowOpacity = 0.3;
	self.toolbarView.layer.shadowRadius = 3;
}

- (NSArray *)helpID
{
	return [NSArray array];
}

- (NSArray *)helpItems
{
	return [NSArray array];
}

- (NSString *)title
{
	return viewTitle;
}

- (void)setTitle:(NSString *)title
{
	viewTitle = title;
	self.customNavigationBar.titleLabel.text = [viewTitle uppercaseString];
}

- (void)showErrorMessage:(NSString *)message
{
	[[PDSingleErrorAlertView instance] showErrorMessage:message];

}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)setNavigationBarStyle:(PDNavigationBarStyle)navigationBarStyle
{
	_navigationBarStyle = navigationBarStyle;
	[self.customNavigationBar setCustomBarStyle:navigationBarStyle];
	
	if (navigationBarStyle == PDNavigationBarStyleBlack) {
		[backButton setImage:[UIImage imageNamed:@"btn-back-white.png"] forState:UIControlStateNormal];
        
	} else if (navigationBarStyle == PDNavigationBarStyleWhite) {
		[backButton setImage:[UIImage imageNamed:@"btn-back.png"] forState:UIControlStateNormal];
	} else if (navigationBarStyle == PDNavigationBarStyleOrange) {
        [backButton setImage:[[FAKFontAwesome angleLeftIconWithSize:30] imageWithSize:CGSizeMake(30, 30)]
                    forState:UIControlStateNormal];
    }
}

- (void)setLeftBarButtonToBackWithStyle:(kPDLeftBarButtonStyle)style
{
    switch (style) {
        case kPDLeftBarButtonStyleBlack:
            [self setLeftBarButtonToImage:[UIImage imageNamed:@"btn-back.png"]
                                   offset:CGSizeMake(3, 0)
                               withAction:@selector(goBack:)];
            break;
        case kPDLeftBarButtonStyleWhite:
            [self setLeftBarButtonToImage:[UIImage imageNamed:@"btn-back-white.png"]
                                   offset:CGSizeMake(3, 0)
                               withAction:@selector(goBack:)];
            break;
        case kPDLeftBarButtonStyleWhiteAndBorder:
            [self setLeftBarButtonToImage:[UIImage imageNamed:@"new-btn-back-white.png"]
                                   offset:CGSizeMake(3, 0)
                               withAction:@selector(goBack:)];
            break;
        case kPDLeftBarButtonStyleGrayAngle:
            [self setLeftBackButtonGray:[FAKFontAwesome angleLeftIconWithSize:30]
                                 offset:CGSizeMake(3, 0)
                             withAction:@selector(goBack:)];
            break;
        case kPDLeftBarButtonStyleWhiteAngle:
            [self setLeftBackButtonToIcon:[FAKFontAwesome angleLeftIconWithSize:30]
                                    color:[UIColor whiteColor]
                                   offset:CGSizeMake(3, 0)
                               withAction:@selector(goBack:)];
            break;
        default:
            [self setLeftBarButtonToImage:[UIImage imageNamed:@"btn-back.png"]
                                   offset:CGSizeMake(3, 0)
                               withAction:@selector(goBack:)];
            break;
    }
}

- (UIView *)setLeftButtonToImage:(UIImage *)image offset:(CGSize)offset withAction:(SEL)action
{
	UIButton *button = [UIButton buttonWithImage:image];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	UIView *view = [[UIView alloc] initWithFrame:button.frame];
	view.bounds = CGRectOffset(view.frame, offset.width, offset.height);
	[view addSubview:button];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:view];
	self.navigationItem.leftBarButtonItem = barButton;
    return view;
}

- (UIView *)setRightButtonToImage:(UIImage *)image offset:(CGSize)offset withAction:(SEL)action
{
	UIButton *button = [UIButton buttonWithImage:image];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	UIView *view = [[UIView alloc] initWithFrame:button.frame];
	view.bounds = CGRectOffset(view.frame, offset.width, offset.height);
	[view addSubview:button];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:view];
	self.navigationItem.rightBarButtonItem = barButton;
    return view;
}

- (PDBarButton *)setLeftBarButtonToImage:(UIImage *)image offset:(CGSize)offset withAction:(SEL)action
{
    PDBarButton *button = [[PDBarButton alloc]initWithImage:image withSide:kPDSideLeftBarButton];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButton;
    return button;
}

- (PDBarButton *)setLeftBackButtonToIcon:(FAKIcon *)icon color:(UIColor *)color offset:(CGSize)offset withAction:(SEL)action
{
    PDBarButton *button = [[PDBarButton alloc] initWithImage:[UIImage imageNamed:@"btn-back.png"] withSide:kPDSideLeftBarButton];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setFontAwesomeIconForImage:icon
                              forState:UIControlStateNormal
                            attributes:@{NSForegroundColorAttributeName : color}];
    [button setFontAwesomeIconForImage:icon
                              forState:UIControlStateSelected
                            attributes:@{NSForegroundColorAttributeName : color}];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButton;
    return button;
}

- (PDBarButton *)setRightBarButtonToIcon:(FAKIcon *)icon color:(UIColor *)color offset:(CGSize)offset withAction:(SEL)action
{
    PDBarButton *button = [[PDBarButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    button.sideBarButton = kPDSideRightBarButton;
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setFontAwesomeIconForImage:icon
                              forState:UIControlStateNormal
                            attributes:@{NSForegroundColorAttributeName : color}];
    [button setFontAwesomeIconForImage:icon
                              forState:UIControlStateSelected
                            attributes:@{NSForegroundColorAttributeName : color}];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = barButton;
    return button;
}

- (PDBarButton *)setLeftBackButtonGray:(FAKIcon *)icon offset:(CGSize)offset withAction:(SEL)action
{
    PDBarButton *button = [[PDBarButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    button.sideBarButton = kPDSideLeftGrayAngleBarButton;
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFontAwesomeIconForImage:icon
                              forState:UIControlStateNormal
                            attributes:@{NSForegroundColorAttributeName : kPDGlobalGrayColor}];
    [button setFontAwesomeIconForImage:icon
                              forState:UIControlStateSelected
                            attributes:@{NSForegroundColorAttributeName : kPDGlobalGrayColor}];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.leftBarButtonItem = barButton;
    return button;
}

- (PDBarButton *)setRightBarButtonToImage:(UIImage *)image offset:(CGSize)offset withAction:(SEL)action
{
    PDBarButton *button = [[PDBarButton alloc]initWithImage:image withSide:kPDSideRightBarButton];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = barButton;
    return button;
}

- (void)setLeftBarButtonToButton:(UIButton *)button
{
	UIView *view = [[UIView alloc] initWithFrame:button.frame];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        view.bounds = CGRectOffset(view.frame, 0, 1);
    } else {
        view.bounds = CGRectOffset(view.frame, 10, 2);
    }
	[view addSubview:button];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:view];
	self.navigationItem.leftBarButtonItem = barButton;
}

- (void)setRightBarButtonToButton:(UIButton *)button
{
    UIView *view = [[UIView alloc] initWithFrame:button.frame];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        view.bounds = CGRectOffset(view.frame, 0, 1);
    } else {
      	view.bounds = CGRectOffset(view.frame, - 10, 2);
    }
	[view addSubview:button];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:view];
	self.navigationItem.rightBarButtonItem = barButton;
}

- (PDGradientButton *)redBarButtonWithTitle:(NSString *)title action:(SEL)action
{
	PDGradientButton *button = [self gradientBarButtonWithTitle:title];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	[button setRedGradientButtonStyle];
	return button;
}

- (PDGradientButton *)grayBarButtonWithTitle:(NSString *)title action:(SEL)action
{
	PDGradientButton *button = [self gradientBarButtonWithTitle:title];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	[button setGrayGradientButtonStyle];
	return button;
}

- (PDGradientButton *)gradientBarButtonWithTitle:(NSString *)title
{
	int width = [title sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:12]].width + 10;
	if (width < 50) {
        width = 50;
	}
	PDGradientButton *button = [[PDGradientButton alloc] initWithFrame:CGRectMake(0, 0, width, 26)];
	[button setTitle:title forState:UIControlStateNormal];
	button.titleLabel.font = kPDNavigationBarButtonFont;
	button.layer.cornerRadius = 3;
	button.gradientLayer.cornerRadius = 3;
    button.layer.borderWidth = 1;
	return button;
}

- (void)fullscreenMode:(bool)fullscreenMode animated:(bool)animated
{
	_fullscreenMode = fullscreenMode;
	[self.navigationController setNavigationBarHidden:fullscreenMode animated:animated];
}

- (void)refreshView
{
	self.needRefreshView = NO;
}

- (void)refetchData
{
	self.loading = YES;
	[self fetchData];
}

- (void)fetchData
{
	[self hideNoInternetButton];
}

- (void)goBack:(id)sender
{
	if (self.presentingViewController
        && [[self.navigationController.viewControllers firstObject] isEqual:self]) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (UIViewController *)previousViewController
{
    NSUInteger index = [self.navigationController.viewControllers indexOfObject:self];
    if (index <= 0) return nil;
    return self.navigationController.viewControllers[index - 1];
}

- (void)showUser:(PDUser *)user
{
	if (kPDUserID == user.identifier) {
        PDMeViewController *meViewController = [[PDMeViewController alloc] initWithNibName:@"PDMeViewController" bundle:nil];
        
        [self.navigationController pushViewController:meViewController animated:YES];
        [meViewController setIsLeftButtonToBack:YES];
    }
    else {
        PDUserViewController *userViewController = [[PDUserViewController alloc] initWithNibName:@"PDUserViewController" bundle:nil];
        userViewController.user = user;
        [self.navigationController pushViewController:userViewController animated:YES];
    }
}

- (void)showPhoto:(PDPhoto *)photo
{
	PDPhotoSpotViewController *photoViewController = [[PDPhotoSpotViewController alloc] initWithNibName:@"PDPhotoSpotViewController" bundle:nil];
	photoViewController.photo = photo;
	[self.navigationController pushViewController:photoViewController animated:YES];
}

- (void)initNoInternetButton
{
	_noInternetButton = [[UIButton alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.view.frame.size)];
	_noInternetButton.backgroundColor = [UIColor whiteColor];
	[_noInternetButton addTarget:self action:@selector(fetchData) forControlEvents:UIControlEventTouchUpInside];
	[_noInternetButton setImage:[UIImage imageNamed:@"btn_no_internet_connection_off.png"] forState:UIControlStateNormal];
	_noInternetButton.hidden = YES;
	[self.view addSubview:_noInternetButton];
}

- (void)showNoInternetButton
{
	if (!self.noInternetButton) {
		[self initNoInternetButton];
	}
	_noInternetButton.hidden = NO;
	[self.view bringSubviewToFront:_noInternetButton];
}

- (void)hideNoInternetButton
{
	_noInternetButton.hidden = YES;
}

- (void)setLoading:(BOOL)loading
{
	if (_loading == loading) return;
	
	_loading = loading;
	
	if (loading) {
		if (!kPDAppDelegate.waitingSpinnerView.isHidden) return;
		if (!self.loadingView) {
			[self initLoadingView];
		}
		[self.loadingView show];
		self.loadingView.frame = CGRectMake(0, -self.view.y, self.view.width, self.view.height + self.view.y);
        
	} else {
		[self.loadingView hide];
	}
	
}

- (void)initLoadingView
{
	loadingView = [[MGRotatingWaitingSpinner alloc] initWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
	loadingView.backgroundColor = [UIColor clearColor];
	loadingView.userInteractionEnabled = NO;
	[self.view addSubview:loadingView];
}

- (void)presentViewControllerWithName:(NSString *)name withStyle:(UIModalTransitionStyle)style
{
	id viewController = [[NSClassFromString(name) alloc] initWithNibName:name bundle:nil];
	if (viewController) {
		[viewController setModalTransitionStyle:style];
		[self presentViewController:viewController animated:YES completion:nil];
	}
}

- (void)showMenu:(id)sender
{
	
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}

- (NSDate *)currentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *timeComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit |
                                                        NSMonthCalendarUnit | NSYearCalendarUnit)
                                              fromDate:date];
    NSInteger  day = [timeComp day];
    NSInteger  month = [timeComp month];
    NSInteger  year = [timeComp year];
    NSInteger hour = [timeComp hour];
    NSInteger minute = [timeComp minute];
    
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld", (long)year, (long)month, (long)day,(long)hour,(long)minute];
    NSDate *currentDate = [dateFormatter dateFromString:dateString];
    return currentDate;
}

#pragma mark - Menu view delegate

- (void)menuViewDidFinish:(UIMenuView *)menuView
{
	if (menuView.needRefetchData) {
		[self refetchData];
		return;
	}
	
	if (menuView.needFetchData) {
		[self fetchData];
		return;
	}
	
	if (menuView.needRefreshSuperview) {
		[self refreshView];
	}
}

#pragma mark - Location Services

- (void)initLocationService
{
    isLocationReceived = [[PDLocationHelper sharedInstance] isLocationReceived];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationChanged:)
                                                 name:LTTLocationChangedNotification
                                               object:nil];
    if (!isLocationReceived) {
        [self updateLocation];
    }
}

- (void)updateLocation
{
}

- (void)locationChanged:(NSNotification *)notification
{
    isLocationReceived = YES;
}

- (void)updateLocationDidFailWithError:(NSError *)error
{
    isLocationReceived = NO;
    [kPDAppDelegate updateLocationDidFailWithError:error];
}

@end
