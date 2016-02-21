//
//  PDAppRater.m
//  Pashadelic
//
//  Created by TungNT2 on 4/4/14.
//
//

#import "PDAppRater.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>

NSString *const kPDAppRaterFirstUseDate				= @"kPDAppRaterFirstUseDate";
NSString *const kPDAppRaterUseCount					= @"kPDAppRaterUseCount";
NSString *const kPDAppRaterSignificantEventCount	= @"kPDAppRaterSignificantEventCount";
NSString *const kPDAppRaterCurrentVersion			= @"kPDAppRaterCurrentVersion";
NSString *const kPDAppRaterRatedCurrentVersion		= @"kPDAppRaterRatedCurrentVersion";
NSString *const kPDAppRaterRatedAnyVersion          = @"kPDAppRaterRatedAnyVersion";
NSString *const kPDAppRaterDeclinedToRate			= @"kPDAppRaterDeclinedToRate";
NSString *const kPDAppRaterReminderRequestDate		= @"kPDAppRaterReminderRequestDate";

//localisation string keys
NSString *const kPDAppRaterMessageTitleKey          = @"iRateMessageTitle";
NSString *const kPDAppRaterMessageKey               = @"kPDAppRaterAppMessage";
NSString *const kPDAppRaterUpdateMessageKey         = @"kPDAppRaterUpdateMessage";
NSString *const kPDAppRaterCancelButtonKey          = @"kPDAppRaterCancelButton";
NSString *const kPDAppRaterRemindButtonKey          = @"kPDAppRaterRemindButton";
NSString *const kPDAppRaterRateButtonKey            = @"kPDAppRaterRateButton";

NSString *templateReviewURL = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APP_ID";
NSString *templateReviewURLiOS7 = @"itms-apps://itunes.apple.com/app/idAPP_ID";

static NSString *_appId;
static double _daysUntilPrompt = 30;
static NSInteger _usesUntilPrompt = 20;
static NSInteger _significantEventsUntilPrompt = -1;
static double _timeBeforeReminding = 1;
static BOOL _debug = NO;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
static id<AppiraterDelegate> _delegate;
#else
__weak static id<PDAppRaterDelegate> _delegate;
#endif
static BOOL _usesAnimation = TRUE;
static UIStatusBarStyle _statusBarStyle;
static BOOL _modalOpen = false;

@interface PDAppRater ()
@property (nonatomic, readonly) BOOL ratedAnyVersion;

- (BOOL)connectedToNetwork;
+ (PDAppRater *)sharedInstance;
- (void)showPromptWithChecks:(BOOL)withChecks;
- (void)showRatingAlert;
- (BOOL)ratingConditionsHaveBeenMet;
- (void)incrementUseCount;
- (void)hideRatingAlert;
@end
@implementation PDAppRater

@synthesize ratingAlert;

+ (void) setAppId:(NSString *)appId {
    _appId = appId;
}

+ (void)setApplicationName:(NSString *)applicationName {
    [PDAppRater sharedInstance].applicationName = applicationName;
}

+ (void)setApplicationVersion:(NSString *)applicationVersion {
    [PDAppRater sharedInstance].applicationVersion = applicationVersion;
}

+ (void) setDaysUntilPrompt:(double)value {
    _daysUntilPrompt = value;
}

+ (void) setUsesUntilPrompt:(NSInteger)value {
    _usesUntilPrompt = value;
}

+ (void) setSignificantEventsUntilPrompt:(NSInteger)value {
    _significantEventsUntilPrompt = value;
}

+ (void) setTimeBeforeReminding:(double)value {
    _timeBeforeReminding = value;
}

+ (void) setDebug:(BOOL)debug {
    _debug = debug;
}
+ (void)setDelegate:(id<PDAppRaterDelegate>)delegate{
	_delegate = delegate;
}
+ (void)setUsesAnimation:(BOOL)animation {
	_usesAnimation = animation;
}
+ (void)setOpenInAppStore:(BOOL)openInAppStore {
    [PDAppRater sharedInstance].openInAppStore = openInAppStore;
}
+ (void)setStatusBarStyle:(UIStatusBarStyle)style {
	_statusBarStyle = style;
}
+ (void)setModalOpen:(BOOL)open {
	_modalOpen = open;
}

- (NSString *)messageTitle
{
    return [NSLocalizedString(@"Rate %@", nil) stringByReplacingOccurrencesOfString:@"%@" withString:self.applicationName];
}

- (NSString *)message
{
    return [NSLocalizedString(@"If you enjoy using %@, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!", nil) stringByReplacingOccurrencesOfString:@"%@" withString:self.applicationName];
}

- (NSString *)updateMessage
{
    return [NSLocalizedString(@"Are we improving the app? If you are happy with the improvement, please rate us again!", nil) stringByReplacingOccurrencesOfString:@"%@" withString:self.applicationName];
}

- (NSString *)rateButtonLabel
{
    return [NSLocalizedString(@"Rate %@", nil) stringByReplacingOccurrencesOfString:@"%@" withString:self.applicationName];
}

- (NSString *)remindButtonLabel
{
    return NSLocalizedString(@"Not Now", nil);
}

- (NSString *)cancelButtonLabel
{
    return NSLocalizedString(@"Not happy? Please give us your feedback", nil);
}

- (BOOL)userHasDeclinedToRate {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPDAppRaterDeclinedToRate];
}

- (BOOL)userHasRatedCurrentVersion {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPDAppRaterRatedCurrentVersion];
}

- (BOOL)ratedAnyVersion
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPDAppRaterRatedAnyVersion];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
    self = [super init];
    if (self) {
        self.applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        self.applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            self.openInAppStore = YES;
        } else {
            self.openInAppStore = NO;
        }
    }
    
    return self;
}

- (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NSLog(@"Error. Could not recover network reachability flags");
        return NO;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
	
	NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
	NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
	NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
	
    return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
}

+ (PDAppRater *)sharedInstance {
	static PDAppRater *appirater = nil;
	if (appirater == nil)
	{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            appirater = [[PDAppRater alloc] init];
			appirater.delegate = _delegate;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:
             UIApplicationWillResignActiveNotification object:nil];
        });
	}
	
	return appirater;
}

- (void)showRatingAlert
{
    UIAlertView *alertView = nil;
    NSString *message = self.ratedAnyVersion ? self.updateMessage : self.message;
    
    alertView = [[UIAlertView alloc] initWithTitle:self.messageTitle
                                           message:message
                                          delegate:self
                                 cancelButtonTitle:self.cancelButtonLabel
                                 otherButtonTitles:self.rateButtonLabel, self.remindButtonLabel, nil];
    
	self.ratingAlert = alertView;
    [alertView show];
    
    id <PDAppRaterDelegate> delegate = _delegate;
    if (delegate && [delegate respondsToSelector:@selector(appRaterDidDisplayAlert:)]) {
        [delegate appRaterDidDisplayAlert:self];
    }
}

- (BOOL)ratingConditionsHaveBeenMet {
	if (_debug)
		return YES;
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	NSDate *dateOfFirstLaunch = [NSDate dateWithTimeIntervalSince1970:[userDefaults doubleForKey:kPDAppRaterFirstUseDate]];
	NSTimeInterval timeSinceFirstLaunch = [[NSDate date] timeIntervalSinceDate:dateOfFirstLaunch];
	NSTimeInterval timeUntilRate = 60 * 60 * 24 * _daysUntilPrompt;
	if (timeSinceFirstLaunch < timeUntilRate)
		return NO;
	
	// check if the app has been used enough
	NSInteger useCount = [userDefaults integerForKey:kPDAppRaterUseCount];
	if (useCount < _usesUntilPrompt)
		return NO;
	
	// check if the user has done enough significant events
	NSInteger sigEventCount = [userDefaults integerForKey:kPDAppRaterSignificantEventCount];
	if (sigEventCount < _significantEventsUntilPrompt)
		return NO;
	
	// has the user previously declined to rate this version of the app?
	if ([userDefaults boolForKey:kPDAppRaterDeclinedToRate])
		return NO;
	
	// has the user already rated the app?
	if ([self userHasRatedCurrentVersion])
		return NO;
	
	// if the user wanted to be reminded later, has enough time passed?
	NSDate *reminderRequestDate = [NSDate dateWithTimeIntervalSince1970:[userDefaults doubleForKey:kPDAppRaterReminderRequestDate]];
	NSTimeInterval timeSinceReminderRequest = [[NSDate date] timeIntervalSinceDate:reminderRequestDate];
	NSTimeInterval timeUntilReminder = 60 * 60 * 24 * _timeBeforeReminding;
	if (timeSinceReminderRequest < timeUntilReminder)
		return NO;
	
	return YES;
}

- (void)incrementUseCount {
	// get the app's version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kPDAppRaterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kPDAppRaterCurrentVersion];
	}
	
	if (_debug)
		NSLog(@"APPIRATER Tracking version: %@", trackingVersion);
	
	if ([trackingVersion isEqualToString:version])
	{
		// check if the first use date has been set. if not, set it.
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kPDAppRaterFirstUseDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kPDAppRaterFirstUseDate];
		}
		
		// increment the use count
		NSInteger useCount = [userDefaults integerForKey:kPDAppRaterUseCount];
		useCount++;
		[userDefaults setInteger:useCount forKey:kPDAppRaterUseCount];
		if (_debug)
			NSLog(@"APPIRATER Use count: %@", @(useCount));
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kPDAppRaterCurrentVersion];
		[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kPDAppRaterFirstUseDate];
		[userDefaults setInteger:1 forKey:kPDAppRaterUseCount];
		[userDefaults setInteger:0 forKey:kPDAppRaterSignificantEventCount];
		[userDefaults setBool:NO forKey:kPDAppRaterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kPDAppRaterDeclinedToRate];
		[userDefaults setDouble:0 forKey:kPDAppRaterReminderRequestDate];
	}
	
	[userDefaults synchronize];
}

- (void)incrementSignificantEventCount {
	// get the app's version
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
	
	// get the version number that we've been tracking
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *trackingVersion = [userDefaults stringForKey:kPDAppRaterCurrentVersion];
	if (trackingVersion == nil)
	{
		trackingVersion = version;
		[userDefaults setObject:version forKey:kPDAppRaterCurrentVersion];
	}
	
	if (_debug)
		NSLog(@"APPIRATER Tracking version: %@", trackingVersion);
	
	if ([trackingVersion isEqualToString:version])
	{
		// check if the first use date has been set. if not, set it.
		NSTimeInterval timeInterval = [userDefaults doubleForKey:kPDAppRaterFirstUseDate];
		if (timeInterval == 0)
		{
			timeInterval = [[NSDate date] timeIntervalSince1970];
			[userDefaults setDouble:timeInterval forKey:kPDAppRaterFirstUseDate];
		}
		
		// increment the significant event count
		NSInteger sigEventCount = [userDefaults integerForKey:kPDAppRaterSignificantEventCount];
		sigEventCount++;
		[userDefaults setInteger:sigEventCount forKey:kPDAppRaterSignificantEventCount];
		if (_debug)
			NSLog(@"APPIRATER Significant event count: %@", @(sigEventCount));
	}
	else
	{
		// it's a new version of the app, so restart tracking
		[userDefaults setObject:version forKey:kPDAppRaterCurrentVersion];
		[userDefaults setDouble:0 forKey:kPDAppRaterFirstUseDate];
		[userDefaults setInteger:0 forKey:kPDAppRaterUseCount];
		[userDefaults setInteger:1 forKey:kPDAppRaterSignificantEventCount];
		[userDefaults setBool:NO forKey:kPDAppRaterRatedCurrentVersion];
		[userDefaults setBool:NO forKey:kPDAppRaterDeclinedToRate];
		[userDefaults setDouble:0 forKey:kPDAppRaterReminderRequestDate];
	}
	
	[userDefaults synchronize];
}

- (void)incrementAndRate:(BOOL)canPromptForRating {
	[self incrementUseCount];
	
	if (canPromptForRating &&
		[self ratingConditionsHaveBeenMet] &&
		[self connectedToNetwork])
	{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self showRatingAlert];
                       });
	}
}

- (void)incrementSignificantEventAndRate:(BOOL)canPromptForRating {
	[self incrementSignificantEventCount];
	
	if (canPromptForRating &&
		[self ratingConditionsHaveBeenMet] &&
		[self connectedToNetwork])
	{
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self showRatingAlert];
                       });
	}
}

+ (void)appLaunched {
	[PDAppRater appLaunched:YES];
}

+ (void)appLaunched:(BOOL)canPromptForRating {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[PDAppRater sharedInstance] incrementAndRate:canPromptForRating];
                   });
}

- (void)hideRatingAlert {
	if (self.ratingAlert.visible) {
		if (_debug)
			NSLog(@"APPIRATER Hiding Alert");
		[self.ratingAlert dismissWithClickedButtonIndex:-1 animated:NO];
	}
}

+ (void)appWillResignActive {
	if (_debug)
		NSLog(@"APPIRATER appWillResignActive");
	[[PDAppRater sharedInstance] hideRatingAlert];
}

+ (void)appEnteredForeground:(BOOL)canPromptForRating {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[PDAppRater sharedInstance] incrementAndRate:canPromptForRating];
                   });
}

+ (void)userDidSignificantEvent:(BOOL)canPromptForRating {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       [[PDAppRater sharedInstance] incrementSignificantEventAndRate:canPromptForRating];
                   });
}

+ (void)showPrompt {
    [PDAppRater tryToShowPrompt];
}

+ (void)tryToShowPrompt {
    [[PDAppRater sharedInstance] showPromptWithChecks:true];
}

+ (void)forceShowPrompt:(BOOL)displayRateLaterButton {
    [[PDAppRater sharedInstance] showPromptWithChecks:false];
}

- (void)showPromptWithChecks:(BOOL)withChecks {
    bool showPrompt = true;
    if (withChecks) {
        showPrompt = ([self connectedToNetwork]
                      && ![self userHasDeclinedToRate]
                      && ![self userHasRatedCurrentVersion]);
    }
    if (showPrompt) {
        [self showRatingAlert];
    }
}

+ (id)getRootViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                break;
            }
        }
    }
    
    for (UIView *subView in [window subviews])
    {
        UIResponder *responder = [subView nextResponder];
        if([responder isKindOfClass:[UIViewController class]]) {
            return [self topMostViewController: (UIViewController *) responder];
        }
    }
    
    return nil;
}

+ (UIViewController *) topMostViewController: (UIViewController *) controller {
	BOOL isPresenting = NO;
	do {
		// this path is called only on iOS 6+, so -presentedViewController is fine here.
		UIViewController *presented = [controller presentedViewController];
		isPresenting = presented != nil;
		if(presented != nil) {
			controller = presented;
		}
		
	} while (isPresenting);
	
	return controller;
}

+ (void)rateApp {
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:YES forKey:kPDAppRaterRatedCurrentVersion];
    [userDefaults setBool:YES forKey:kPDAppRaterRatedAnyVersion];
	[userDefaults synchronize];
    
	//Use the in-app StoreKit view if available (iOS 6) and imported. This works in the simulator.
	if (![PDAppRater sharedInstance].openInAppStore && NSStringFromClass([SKStoreProductViewController class]) != nil) {
		
		SKStoreProductViewController *storeViewController = [[SKStoreProductViewController alloc] init];
		NSNumber *appId = [NSNumber numberWithInteger:_appId.integerValue];
		[storeViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:nil];
		storeViewController.delegate = self.sharedInstance;
        
        id <PDAppRaterDelegate> delegate = self.sharedInstance.delegate;
		if ([delegate respondsToSelector:@selector(appRaterWillPresentModalView:animated:)]) {
			[delegate appRaterWillPresentModalView:self.sharedInstance animated:_usesAnimation];
		}
		[[self getRootViewController] presentViewController:storeViewController animated:_usesAnimation completion:^{
			[self setModalOpen:YES];
			//Temporarily use a black status bar to match the StoreKit view.
			[self setStatusBarStyle:[UIApplication sharedApplication].statusBarStyle];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
			[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:_usesAnimation];
#endif
		}];
        
        //Use the standard openUrl method if StoreKit is unavailable.
	} else {
		
#if TARGET_IPHONE_SIMULATOR
		NSLog(@"APPIRATER NOTE: iTunes App Store is not supported on the iOS simulator. Unable to open App Store page.");
#else
		NSString *reviewURL = [templateReviewURL stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", _appId]];
        
		// iOS 7 needs a different templateReviewURL @see https://github.com/arashpayan/appirater/issues/131
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
			reviewURL = [templateReviewURLiOS7 stringByReplacingOccurrencesOfString:@"APP_ID" withString:[NSString stringWithFormat:@"%@", _appId]];
		}
        
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:reviewURL]];
#endif
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    id <PDAppRaterDelegate> delegate = _delegate;
	
	switch (buttonIndex) {
		case 0:
		{
			// they don't want to rate it
			[userDefaults setBool:YES forKey:kPDAppRaterDeclinedToRate];
			[userDefaults synchronize];
			if(delegate && [delegate respondsToSelector:@selector(appRaterDidDeclineToRate:)]){
				[delegate appRaterDidDeclineToRate:self];
			}
			break;
		}
		case 1:
		{
			// they want to rate it
			[PDAppRater rateApp];
			if(delegate&& [delegate respondsToSelector:@selector(appRaterDidOptToRate:)]){
				[delegate appRaterDidOptToRate:self];
			}
			break;
		}
		case 2:
			// remind them later
			[userDefaults setDouble:[[NSDate date] timeIntervalSince1970] forKey:kPDAppRaterReminderRequestDate];
			[userDefaults synchronize];
			if(delegate && [delegate respondsToSelector:@selector(appRaterDidOptToRemindLater:)]){
				[delegate appRaterDidOptToRemindLater:self];
			}
			break;
		default:
			break;
	}
}

//Delegate call from the StoreKit view.
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
	[PDAppRater closeModal];
}

//Close the in-app rating (StoreKit) view and restore the previous status bar style.
+ (void)closeModal {
	if (_modalOpen) {
		[[UIApplication sharedApplication]setStatusBarStyle:_statusBarStyle animated:_usesAnimation];
		BOOL usedAnimation = _usesAnimation;
		[self setModalOpen:NO];
		
		// get the top most controller (= the StoreKit Controller) and dismiss it
		UIViewController *presentingController = [UIApplication sharedApplication].keyWindow.rootViewController;
		presentingController = [self topMostViewController: presentingController];
		[presentingController dismissViewControllerAnimated:_usesAnimation completion:^{
            id <PDAppRaterDelegate> delegate = self.sharedInstance.delegate;
			if ([delegate respondsToSelector:@selector(appRaterDidDismissModalView:animated:)]) {
				[delegate appRaterDidDismissModalView:(PDAppRater *)self animated:usedAnimation];
			}
		}];
		[self.class setStatusBarStyle:(UIStatusBarStyle)nil];
	}
}

@end
