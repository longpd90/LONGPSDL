//
//  PDAppDelegate.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Reachability.h"
#import "PDMainMenuViewController.h"
#import "PDSplashViewController.h"
#import "PDLocationHelper.h"
#import "PDUserViewController.h"
#import "PDCameraViewController.h"
#import "PDServerPhotoUploader.h"
#import "MyVersion.h"
#import "PDServerGetMyPins.h"
#import "PDServerProfileLoader.h"
#import <Crashlytics/Crashlytics.h>
#import "PDRegisterDeviceToken.h"
#import "PDServerDeactiveAccountFeedback.h"
#import "PDTodayPhotoViewController.h"
#import "PDFeedbackAlertView.h"
#import "PDAppRater.h"

@interface PDAppDelegate () <MGServerExchangeDelegate, PDAppRaterDelegate>
{
	PDServerProfileLoader *profileLoader;
	NSTimer *spinnerTimeoutTimer;
	NSDictionary *notificationUserInfo;
}
@property (strong, nonatomic) ATReachability *internetReachability;
@property (strong, nonatomic) PDPhoto *notificationPhoto;
@property (strong, nonatomic) PDUser *notificationUser;
@property (strong, nonatomic) PDServerGetMyPins *serverGetMyPins;
@property (strong, nonatomic) PDRegisterDeviceToken *urbanRegisterDeviceToken;
@property (strong, nonatomic) PDTodayPhotoViewController *todaysPhotoViewController;
@property (strong, nonatomic) PDNavigationController *todaysPhotoNavigationController;

- (void)handleRemoteNotification:(NSDictionary *)userInfo;
- (void)checkNewVersionAvaiable;
- (void)userDidLogin;
- (void)reachabilityChanged:(NSNotification *)notification;
- (void)getAppInformation;
- (void)showTodaysPhotoIfNeeded;
- (void)getMyPins;
- (void)registerDeviceToken:(NSString *)deviceToken;
- (void)showTodaysPhotoViewController;
- (void)configuratedAppRater;
- (void)clearAllUsersData;

@end


@implementation PDAppDelegate
@synthesize window;
@synthesize userProfile;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[PDGoogleAnalytics sharedInstance];
	[self initialize];
    [Mixpanel sharedInstanceWithToken:kPDMixpanelToken];
    [Crashlytics startWithAPIKey:kPDCrashlyticsAPIKey];
	
#if DEBUG
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#endif
    
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.mainMenuViewController = [[PDMainMenuViewController alloc] initForUniversalDevice];
	self.viewDeckController = [[PDDeckViewController alloc] initWithCenterViewController:self.mainMenuViewController.homeViewController];
	self.viewDeckController.panningMode = IIViewDeckNavigationBarPanning;
	self.viewDeckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
	self.viewDeckController.leftSize = kPDMenuLeftEdgeSize;
	self.window.rootViewController = self.viewDeckController;
	self.userProfile = [[PDUserProfile alloc] init];
    [self.window makeKeyAndVisible];
    
	[self.viewDeckController addChildViewController:self.mainMenuViewController];
	[self.viewDeckController.view addSubview:self.mainMenuViewController.view];
	self.mainMenuViewController.view.frame = self.viewDeckController.view.zeroPositionFrame;
	self.mainMenuViewController.view.x = self.viewDeckController.centerController.view.x - self.mainMenuViewController.view.width;
    
	if ([kPDAuthToken length] == 0) {
		[self login];
	} else {
		[[Mixpanel sharedInstance] identify:[NSString stringWithFormat:@"%ld", (long)kPDUserID]];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPDSuccessLoggedInNotification object:self];
	}
    
	[[PDServerPhotoUploader sharedInstance] loadQueueFromDisk];
    
#if !(TARGET_IPHONE_SIMULATOR)
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
#endif
	
	if (launchOptions) {
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary) {
			[self handleRemoteNotification:dictionary];
		}
	}
    
	[[PDUnreadItemsManager instance] initialize];
	self.uploadPhotoView = [[PDUploadPhotoView alloc] initWithFrame:CGRectZero];
	[self.window addSubview:self.uploadPhotoView];
	[self.uploadPhotoView reset];
	[self performSelectorInBackground:@selector(checkNewVersionAvaiable) withObject:nil];
    [self configuratedAppRater];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[[PDServerPhotoUploader sharedInstance] saveQueueToDisk];
	[self.shownHelpItems writeToFile:[self.documentsPath stringByAppendingPathComponent:@"shown_help.plist"] atomically:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[self setInternetActivitiesCount:0];
	[self showTodaysPhotoIfNeeded];
    [PDAppRater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (!self.isUnreadItemsLoaded) {
        [[PDUnreadItemsManager instance] fetchData];
    }
    else {
        self.isUnreadItemsLoaded = NO;
    }
    
    [[PDLocationHelper sharedInstance] updateLocation:^(NSError *error, CLLocation *location){
        if (error)
            [self updateLocationDidFailWithError:error];
        else {
            NSDictionary *locationInfo = [NSDictionary dictionaryWithObject:location forKey:@"location"];
            [[NSNotificationCenter defaultCenter] postNotificationName:LTTLocationChangedNotification
                                                                object:nil
                                                              userInfo:locationInfo];
        }
    }];
    
	[self getMyPins];
	[self hideWaitingSpinner];
	[[PDServerPhotoUploader sharedInstance] startUploadQueue];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
	BOOL facebookHandle = [FBSession.activeSession handleOpenURL:url];
	if (facebookHandle) return facebookHandle;
	
	return NO;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [kPDUserDefaults setValue:token forKey:kPDDeviceTokenKey];
    [kPDUserDefaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Apple Registration Failed %@", [error description]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
	notificationUserInfo = userInfo;
	NSString *message = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"You received notification", nil)
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"View", nil), nil];
	[alertView show];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
	return UIInterfaceOrientationMaskAll;
}


#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) return;
    
	[self handleRemoteNotification:notificationUserInfo];
}


#pragma mark - Public

- (void)initialize
{
	[super initialize];
	self.helpItems = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Help Items" ofType:@"plist"]];
	self.shownHelpItems = [NSMutableArray arrayWithContentsOfFile:[self.documentsPath stringByAppendingPathComponent:@"shown_help.plist"]];
	if (!self.shownHelpItems) {
		self.shownHelpItems = [NSMutableArray array];
	}
	self.internetActivitiesCount = 0;
	[self registerDefaults];
	self.internetReachability = [ATReachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
    
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login)
                                                 name:kPDNeedLoginNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin)
                                                 name:kPDSuccessLoggedInNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
}

- (void)registerDefaults
{
	NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:PDItemsTableViewModeTile], kPDDefaultTableViewModeKey,
                              [NSNumber numberWithInt:PDNearbySortTypeByDate], kPDDefaultUserSortKey,
                              [NSNumber numberWithInt:1], kPDNearbySeasonKey,
                              [NSNumber numberWithFloat:25], kPDNearbyRangeKey,
                              [NSNumber numberWithFloat:25], kPDSearchRangeKey,
                              [NSNumber numberWithBool:YES], kPDFacebookShareEnabledKey,
                              [NSNumber numberWithBool:YES], kPDTwitterShareEnabledKey,
                              [NSNumber numberWithBool:YES], kPDShowNearbyPinEnabledKey,
                              [NSNumber numberWithBool:5.0], kPDShowNearbyPinDistanceKey,
                              [NSNumber numberWithFloat:500], kPDFilterNearbyRangeKey, nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (void)hideWaitingSpinner
{
	[spinnerTimeoutTimer invalidate];
	[super hideWaitingSpinner];
}

- (void)showWaitingSpinner
{
	[super showWaitingSpinner];
	spinnerTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
                                                         selector:@selector(hideWaitingSpinner)
                                                         userInfo:nil repeats:NO];
}

- (void)login
{
	[self hideWaitingSpinner];
    [self clearAllUsersData];
	self.userLoggedIn = NO;
	if (!self.viewDeckController.presentedViewController) {
		PDSplashViewController *splashViewController = [[PDSplashViewController alloc] initWithNibName:@"PDSplashViewController" bundle:nil];
        splashViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		[self.viewDeckController presentViewController:splashViewController animated:NO completion:^{}];
	}
}

- (void)reachabilityChanged:(NSNotification *)notification
{
	ATReachability *reachability = notification.object;
	if ([reachability currentReachabilityStatus] != NotReachable && self.userProfile.name.length == 0) {
		[self userDidLogin];
	}
}

- (void)fetchUserData
{
	
}

- (PDHelpView *)helpView
{
	if (!_helpView) {
		_helpView = [[PDHelpView alloc] initWithFrame:self.window.zeroPositionFrame];
	}
	return _helpView;
}

- (void)sendDeactiveAccountFeedbackWithBody:(NSString *)body
{
    PDServerDeactiveAccountFeedback *serverDeactiveAccountFeedback = [[PDServerDeactiveAccountFeedback alloc] initWithDelegate:self];
    [serverDeactiveAccountFeedback sendDeactiveAccountFeedbackWithBody:body];
}


#pragma mark - Private

- (void)clearAllUsersData
{
    [kPDUserDefaults setObject:@"" forKey:kPDAuthTokenKey];
	[kPDUserDefaults setInteger:0 forKey:kPDUserIDKey];
	kPDAppDelegate.userProfile = nil;
	[PDFacebookExchange logout];
}

- (void)getMyPins
{
    if (!self.isUserLoggedIn) return;
    
	if (!self.serverGetMyPins) {
		self.serverGetMyPins = [[PDServerGetMyPins alloc] initWithDelegate:self];
	}
	[self.serverGetMyPins loadPinnedPhotosForProfile:self.userProfile page:1];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
	NSDictionary *object = [userInfo objectForKey:@"target"];
	NSString *type = [object stringForKey:@"object"];
	NSInteger identifier = [object intForKey:@"id"];
	if (type.length == 0 || identifier == 0) {
		[UIAlertView showAlertWithTitle:nil message:[NSString stringWithFormat:@"No info in push notification:\n%@", userInfo]];
		return;
	}
	
	if (self.viewDeckController.presentedViewController) {
		[self.viewDeckController dismissViewControllerAnimated:NO completion:^{}];
	}
	
	PDDeckViewController *deckViewController;
	PDNavigationController *navigationController;
	
	if ([type isEqualToString:@"photo"]) {
		PDPhotoSpotViewController *photoViewController = [[PDPhotoSpotViewController alloc] initWithNibName:@"PDPhotoSpotViewController" bundle:nil];
		self.notificationPhoto = [[PDPhoto alloc] init];
		self.notificationPhoto.identifier = identifier;
		photoViewController.photo = self.notificationPhoto;
		navigationController = [[PDNavigationController alloc] initWithRootViewController:photoViewController];
		deckViewController = [[PDDeckViewController alloc] initWithCenterViewController:navigationController];
		
	} else if ([type isEqualToString:@"user"]) {
		PDUserViewController *userViewController = [[PDUserViewController alloc] initWithNibName:@"PDUserViewController" bundle:nil];
		self.notificationUser = [[PDUser alloc] init];
		self.notificationUser.identifier = identifier;
		userViewController.user = self.notificationUser;
		navigationController = [[PDNavigationController alloc] initWithRootViewController:userViewController];
		deckViewController = [[PDDeckViewController alloc] initWithCenterViewController:navigationController];
	}
	
	[self.viewDeckController presentViewController:deckViewController animated:YES completion:^{}];
}

- (void)checkNewVersionAvaiable
{
    [MyVersion shareMyInstance].appStoreID = [kPDAppID intValue];
    [[MyVersion shareMyInstance] checkNewVersionInBackground];
}

- (void)configuratedAppRater
{
    [PDAppRater setAppId:kPDAppID];
    [PDAppRater setDelegate:self];
    [PDAppRater setDaysUntilPrompt:3];
    [PDAppRater setUsesUntilPrompt:10];
    [PDAppRater setSignificantEventsUntilPrompt:20];
    [PDAppRater setTimeBeforeReminding:2];
    [PDAppRater appLaunched:YES];
}

- (void)userDidLogin
{
	self.userLoggedIn = YES;
    [self getAppInformation];
    [[PDUnreadItemsManager instance] fetchData];
    self.isUnreadItemsLoaded = YES;
	if (!profileLoader) {
		profileLoader = [[PDServerProfileLoader alloc] initWithDelegate:self];
	}
	[profileLoader loadUserProfile:self.userProfile];
	[self showTodaysPhotoIfNeeded];
	[self getMyPins];
}

- (void)registerDeviceToken:(NSString *)deviceToken
{
    if (!deviceToken) return;
    if (!self.urbanRegisterDeviceToken) {
        self.urbanRegisterDeviceToken = [[PDRegisterDeviceToken alloc] initWithDelegate:self];
    }
    [self.urbanRegisterDeviceToken registerDeviceToken:deviceToken
                                             WithAlias:[NSString stringWithFormat:@"%ld", (long)self.userProfile.identifier]
                                               andTags:[NSArray arrayWithObjects:[[NSLocale preferredLanguages] objectAtIndex:0], nil]];
}

- (void)getAppInformation
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    [kPDUserDefaults setValue:appVersion forKey:kPDAppVersionKey];
    [kPDUserDefaults setValue:iOSVersion forKey:kPDIOSVersionKey];
}

- (void)showTodaysPhotoIfNeeded
{
	if (!self.userLoggedIn) return;
	if ([kPDLastAppLaunchDate isKindOfClass:[NSDate class]]) {
		if ([[NSDate date] compareDay:kPDLastAppLaunchDate] != NSOrderedSame) {
            [self showTodaysPhotoViewController];
        }
	} else {
        [self showTodaysPhotoViewController];
    }
    
	[kPDUserDefaults setObject:[NSDate date] forKey:kPDLastAppLaunchDateKey];
	[kPDUserDefaults synchronize];
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

- (void)showTodaysPhotoViewController
{
    if (!self.userLoggedIn) return;
    if ([self.viewDeckController.presentedViewController isEqual:self.todaysPhotoNavigationController]) {
		[self.todaysPhotoViewController fetchData];
		return;
	}
    self.viewDeckController.centerController = self.mainMenuViewController.homeViewController;
    [self.mainMenuViewController.homeViewController popToRootViewControllerAnimated:NO];
    if (!self.todaysPhotoViewController) {
        self.todaysPhotoViewController = [[PDTodayPhotoViewController alloc] initForUniversalDevice];
        self.todaysPhotoNavigationController = [[PDNavigationController alloc] initWithRootViewController:self.todaysPhotoViewController];
    }
    [self.todaysPhotoViewController fetchData];
    [self.mainMenuViewController.homeViewController presentViewController:self.todaysPhotoNavigationController animated:NO completion:nil];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - Location Services

- (void)updateLocationDidFailWithError:(NSError *)error
{
    if (!error) return;
    
	if (error.code == kCLErrorDenied) {
		[[PDSingleErrorAlertView instance] showErrorMessage:NSLocalizedString(@"Enable location service for Pashadelic.\nImprove your experience on pashadelic and find photo-spots close to you!", nil)];
	} else {
		if (error.code == kCLErrorLocationUnknown) {
			[[PDSingleErrorAlertView instance] showErrorMessage:NSLocalizedString(@"Location is currently unknown", nil)];
		} else {
			[[PDSingleErrorAlertView instance] showErrorMessage:[NSString stringWithFormat:NSLocalizedString(@"Error receiving location:\n%@", nil), error.description]];
		}
	}
}

- (void)trackEvent:(NSString *)event
{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![bundleIdentifier isEqualToString:kPDAppProductionBundleID]) return;
    
    [[Mixpanel sharedInstance] track:event properties:@{@"Page" : @"App delegate"}];
	[[PDGoogleAnalytics sharedInstance] trackAction:event atPage:@"App delegate"];
}

#pragma mark - iRate delegate

- (void)appRaterDidOptToRate:(PDAppRater *)appRater
{
    [self trackEvent:@"Rated"];
}

- (void)appRaterDidOptToRemindLater:(PDAppRater *)appRater
{
    [self trackEvent:@"Rate not now"];
}

- (void)appRaterDidDeclineToRate:(PDAppRater *)appRater
{
    [self trackEvent:@"Rate feedback"];
    PDFeedbackAlertView *feedbackAlertView = [[PDFeedbackAlertView alloc] init];
    [feedbackAlertView.messageLabel setText:NSLocalizedString(@"Please give us your feedback", nil)];
    [feedbackAlertView show];
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[self hideWaitingSpinner];
	[[PDSingleErrorAlertView instance] showErrorMessage:error];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if ([serverExchange isKindOfClass:[PDServerProfileLoader class]]) {
		[self.userProfile loadFullDataFromDictionary:result[@"user"]];
		[self.mainMenuViewController.userAvatarImageView sd_setImageWithURL:self.userProfile.thumbnailURL];
        self.userAvatarURL = self.userProfile.thumbnailURL;
		[self.mainMenuViewController refreshView];
        [self registerDeviceToken:kPDDeviceToken];
	} else if ([serverExchange isKindOfClass:[PDServerGetMyPins class]]) {
		@synchronized(self.userProfile.pins) {
			[self.userProfile.pins removeAllObjects];
			[self.userProfile.pins addObjectsFromArray:[serverExchange loadPhotosFromArray:result[@"photos"]]];
		}
	}
}

@end
