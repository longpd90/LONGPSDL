//
//  Globals.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Pashadelic_Globals_h
#define Pashadelic_Globals_h

#import "PDAppDelegate.h"

// Other constants

extern NSString *const kPDServerAddress;

extern NSString *const kPDMixpanelToken;

extern NSString *const kPDGoogleMapsAPIToken;

extern NSString *const kPDBaseURL;

extern NSString *const kPDUrbanAirshipAppKey;

extern NSString *const kPDUrbanAirshipAppSecret;

extern NSString *const kPDGoogleAPIKey;

extern NSString *const kPDGoogleAnalyticsKey;

extern NSString *const kPDWeatherUndergroundAPIKey;

extern NSString *const kPDCrashlyticsAPIKey;

extern NSString *const PDGlobalNormalFontName;
extern NSString *const PDGlobalLightFontName;
extern NSString *const PDGlobalBoldFontName;
extern NSString *const PDGlobalNormalItalicFontName;
extern NSString *const PDGlobalLightItalicFontName;
extern NSString *const PDGlobalBoldItalicFontName;

extern NSString *const kPDCloudinaryAPIKey;

extern NSString *const kPDCloudinaryAPISecret;

extern NSString *const kPDCloudinaryURL;

#define kPDUrbanAirshipAddress              @"https://go.urbanairship.com/api/"
#define kPDGoogleAddress                    @"https://maps.googleapis.com/maps/api/"
#define kPDWeatherUndergroundAddress        @"http://api.wunderground.com/api/"

#define kPDAppDelegate                      ((PDAppDelegate *) [UIApplication sharedApplication].delegate)
#define kPDUserProfile                      [kPDAppDelegate userProfile]
#define kPDAnnotationSpan                   0.1
#define kPDMaxPhotoSize                     1260
#define kPDMinFacebookCoverWidth            355
#define kPDRefreshYOffsetValue              60
#define kPDMaxItemsPerPage                  36
#define kPDServerTimeoutInterval            30
#define kPDMenuLeftEdgeSize                 44
#define kPDMaxPhotoTagsNumber               3
#define kPDUnreadItemsRefetchTimer          300
#define kPDNoTip                            -1
#define kPDLibraryPath                      kPDAppDelegate.libraryPath
#define kPDCachePath                        kPDAppDelegate.cachePath
#define kPDAppName                          @"Pashadelic"
#define kPDAppProductionBundleID            @"com.pashadelic.app"
#define kPDAppWebPage                       @"www.pashadelic.com"
#define kPDPhotoUploadQueueFilename         @"photo_upload_queue.plist"
#define kPDNavigationBarButtonFont          [UIFont fontWithName:PDGlobalLightFontName size:12]
#define kPDNewNavigationBarButtonFont       [UIFont fontWithName:PDGlobalLightFontName size:14]

#define kPDAppID                            @"572422703"
#define kPDRateAppLink                      [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&type=Purple+Software&onlyLatestVersion=true&pageNumber=0&sortOrdering=1", kPDAppID]

#define kPDInternetNotReachableText         NSLocalizedString(@"Check your internet connection.", nil)
#define kPDCommentsPlaceholderText          NSLocalizedString(@"Comments, tips, hints : Describe your experience at this photo-spot and help others", nil)
#define kPDGlobalBackgroundGrayColor        [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]
#define kPDGlobalRedColor					[UIColor colorWithRed:0.796 green:0.125 blue:0.153 alpha:1]
#define kPDGlobalYellowColor				[UIColor colorWithRed:255/255.0 green:170/255.0 blue:0 alpha:1]
#define kPDGlobalGreenUploadColor                 [UIColor colorWithRed:0/255.0 green:180/255.0 blue:95/255.0 alpha:1]
#define kPDGlobalBlueColor                  [UIColor colorWithRed:51.0/255 green:102.0/255 blue:1 alpha:1]
#define kPDGlobalGrayColor                  [UIColor colorWithRed:102/255.0 green:121/255.0 blue:131/255.0 alpha:1]
#define kPDGlobalComfortColor               [UIColor colorWithRed:208/255.0 green:215/255.0 blue:219/255.0 alpha:1]
#define kPDGlobalLightGrayColor             [UIColor colorWithRed:236/255.0 green:242/255.0 blue:245/255.0 alpha:1]
#define kPDGlobalDarkGrayColor              [UIColor colorWithRed:0.204 green:0.235 blue:0.251 alpha:1]
#define kPDGlobalGreenColor					[UIColor colorWithRed:0 green:0.7 blue:0 alpha:1]
#define kPDGlobalGoldenrodColor             [UIColor colorWithRed:255/255.0 green:166/255.0 blue:41/255.0 alpha:1]
#define kPDGlobalWhiteSmokeColor            [UIColor colorWithRed:236/255.0 green:242/255.0 blue:245/255.0 alpha:1]
#define kPDShowPlanDetail                   @"kPDShowPlanDetail"

// Notifications
#define kPDChangeDefaultViewModeNotification    @"kPDChangeDefaultViewModeNotification"
#define kPDNeedLoginNotification                @"kPDNeedLoginNotification"
#define kPDSuccessLoggedInNotification          @"kPDSuccessLoggedInNotification"
#define kPDResetCameraViewNotification          @"kPDResetCameraViewNotification"
#define kPDDismissImagePickerNotification       @"kPDDismissImagePickerNotification"
#define kPDItemWasChangedNotification           @"kPDItemWasChangedNotification"
#define kPDUserAvatarWasChangedNotification     @"kPDUserAvatarWasChangedNotification"
#define kPDPhotoStatusChangedNotification       @"kPDPhotoStatusChangedNotification"
#define kPDUnreadItemsCountChangedNotification	@"kPDUnreadItemsCountChangedNotification"
#define kPDDismissSingleErrorAlertView          @"kPDDismissSingleErrorAlertView"

// Map Tools Notifications
#define kPDUserTrackingModeChangedNotification      @"kPDUserTrackingModeChangedNotification"
#define kPDSunMoonOptionChangedNotification         @"kPDSunMoonOptionChangedNotification"
#define kPDSunMoonDateChangedNotification           @"kPDSunMoonDateChangedNotification"
#define kPDDidTapOnMapNotification                  @"kPDDidTapOnMapNotification"
#define kPDDidTouchesBeganOnMapNotification         @"kPDDidTouchesBeganOnMapNotification"

#define kPDPhotoSpotsFilterDidChangeNotification          @"kPDPhotoSpotsFilterDidChangeNotification"
#define kPDMapViewRegionDidChangeNotification             @"kPDMapViewRegionDidChangeNotification"
#define kPDDidUpdateHeading                               @"didUpdateHeading"
#define kPDPinAnnotationCenterDidChangeNotification       @"kPDPinAnnotationCenterDidChangeNotification"
#define kPDPinAnnotationCenterDidTochesBeganNotification  @"kPDPinAnnotationCenterDidTochesBeganNotification"
#define kPDPinAnnotationCenterDidTochesEndNotification    @"kPDPinAnnotationCenterDidTochesEndNotification"
#define kPDPinAnnotationCameraDidTochesBeganNotification  @"kPDPinAnnotationCameraDidTochesBeganNotification"
#define kPDSetUserTrackingModeNone                        @"kPDSetUserTrackingModeNone"
#define kPDPinAnnotationCameraDidTochesEndNotification    @"kPDPinAnnotationCameraDidTochesEndNotification"
#define kPDCameraAnnotationCenterDidChangeNotification    @"kPDCameraAnnotationCenterDidChangeNotification"

// Settings
#define kPDUserDefaults                 [NSUserDefaults standardUserDefaults]
#define kPDDefaultTableViewModeKey			@"kPDDefaultTableViewModeKey"
#define kPDAuthTokenKey                 @"kPDAuthTokenKey"
#define kPDDefaultUserSortKey           @"kPDDefaultUserSortKey"
#define kPDNearbyRangeKey               @"kPDNearbyRangeKey"
#define kPDSearchRangeKey               @"kPDSearchRangeKey"
#define kPDFacebookShareEnabledKey		@"kPDFacebookShareEnabledKey"
#define kPDTwitterShareEnabledKey       @"kPDTwitterShareEnabledKey"
#define kPDGoogleShareEnabledKey        @"kPDGoogleShareEnabledKey"
#define kPDNearbySpotNotificationEnabledKey	@"kPDNearbySpotNotificationEnabledKey"
#define kPDUpdateNotificationEnabledKey     @"kPDUpdateNotificationEnabledKey"
#define kPDUserIDKey                    @"kPDUserIDKey"
#define kPDDefaultNearbySortingKey			@"kPDDefaultNearbySortingKey"
#define kPDFacebookAccessTokenKey       @"kPDFacebookAccessTokenKey"
#define kPDFacebookExpirationDateKey		@"kPDFacebookExpirationDateKey"
#define kPDFacebookUserNameKey          @"kPDFacebookUserNameKey"
#define kPDFacebookEmailKey             @"kPDFacebookEmailKey"
#define kPDNearbySeasonKey              @"kPDNearbySeasonKey"
#define kPDNearbyDaytimeKey             @"kPDNearbyDaytimeKey"
#define kPDNearbySeasonsEnabledKey			@"kPDNearbySeasonsEnabledKey"
#define kPDSearchSeasonKey              @"kPDSearchSeasonKey"
#define kPDSearchDaytimeKey             @"kPDSearchDaytimeKey"
#define kPDSearchSeasonsEnabledKey			@"kPDSearchSeasonsEnabledKey"
#define kPDDeviceTokenKey               @"kPDDeviceTokenKey"
#define kPDIsHelpShownKey               @"kPDIsHelpShownKey"
#define kPDAppVersionKey                @"kPDAppVersionKey"
#define kPDIOSVersionKey                @"kPDIOSVersionKey"
#define kPDUserLocationLongitudeKey     @"kPDUserLocationLongitudeKey"
#define kPDUserLocationLatitudeKey      @"kPDUserLocationLatitudeKey"
#define kPDShowNearbyPinDistanceKey			@"kPDShowNearbyPinDistanceKey"
#define kPDShowNearbyPinEnabledKey			@"kPDShowNearbyPinEnabledKey"
#define kPDLastAppLaunchDateKey         @"kPDLastAppLaunchDateKey"

// Map Tools Key
#define kPDPhotoToolsNearbyRangeKey         @"kPDPhotoToolsNearbyRangeKey"
#define kPDPhotoToolsNearbySortKey          @"kPDPhotoToolsNearbySortKey"
#define kPDPhotoToolsNearbyDateFromKey      @"kPDPhotoToolsNearbyDateFromKey"
#define kPDPhotoToolsNearbyDateToKey        @"kPDPhotoToolsNearbyDateToKey"
#define kPDPhotoToolsNearbyTimeFromKey      @"kPDPhotoToolsNearbyTimeFromKey"
#define kPDPhotoToolsNearbyTimeToKey        @"kPDPhotoToolsNearbyTimeToKey"
#define kPDSunRiseHiddenKey                 @"kPDSunRiseHiddenKey"
#define kPDSunSetHiddenKey                  @"kPDSunSetHiddenKey"
#define kPDMoonRiseHiddenKey                @"kPDMoonRiseHiddenKey"
#define kPDMoonSetHiddenKey                 @"kPDMoonSetHiddenKey"

// Photo Upload Key
#define kPDPhotoUploadedIdKey               @"kPDPhotoUploadedIdKey"

// Explore Key
#define kPDFilterNearbySortTypeKey          @"kPDFilterNearbySortTypeKey"
#define kPDFilterNearbyDateFromKey          @"kPDFilterNearbyDateFromKey"
#define kPDFilterNearbyDateToKey            @"kPDFilterNearbyDateToKey"
#define kPDFilterNearbyTimeFromKey          @"kPDFilterNearbyTimeFromKey"
#define kPDFilterNearbyTimeToKey            @"kPDFilterNearbyTimeToKey"
#define kPDFilterNearbyRangeKey             @"kPDFilterNearbyRangeKey"

// Location Services Key
#define kPDUserLocationKey                  @"kPDUserLocationKey"

#define kPDTodayPhotoURLKey                 @"kPDTodayPhotoURLKey"

#define kPDDefaultTableViewMode				[kPDUserDefaults integerForKey:kPDDefaultTableViewModeKey]
#define kPDDefaultSort                [kPDUserDefaults integerForKey:kPDDefaultUserSortKey]
#define kPDAuthToken                  [kPDUserDefaults objectForKey:kPDAuthTokenKey]
#define kPDNearbyRange                [kPDUserDefaults doubleForKey:kPDNearbyRangeKey]
#define kPDSearchRange                [kPDUserDefaults doubleForKey:kPDSearchRangeKey]
#define kPDFacebookShareEnabled				[kPDUserDefaults boolForKey:kPDFacebookShareEnabledKey]
#define kPDTwitterShareEnabled				[kPDUserDefaults boolForKey:kPDTwitterShareEnabledKey]
#define kPDGoogleShareEnabled         [kPDUserDefaults boolForKey:kPDGoogleShareEnabledKey]
#define kPDNearbySpotNotificaitonEnabled	[kPDUserDefaults boolForKey:kPDNearbySpotNotificationEnabledKey]
#define kPDUpdateNotificationEnabled      [kPDUserDefaults boolForKey:kPDUpdateNotificationEnabledKey]
#define kPDUserID                     [kPDUserDefaults integerForKey:kPDUserIDKey]
#define kPDDefaultNearbySorting				[kPDUserDefaults integerForKey:kPDDefaultNearbySortingKey]
#define kPDDefaultUserSort            [kPDUserDefaults integerForKey:kPDDefaultUserSortKey]
#define kPDNearbyDaytime              [kPDUserDefaults integerForKey:kPDNearbyDaytimeKey]
#define kPDNearbySeason               [kPDUserDefaults integerForKey:kPDNearbySeasonKey]
#define kPDNearbySeasonsEnabled				[kPDUserDefaults boolForKey:kPDNearbySeasonsEnabledKey]
#define kPDSearchDaytime              [kPDUserDefaults integerForKey:kPDSearchDaytimeKey]
#define kPDSearchSeason               [kPDUserDefaults integerForKey:kPDSearchSeasonKey]
#define kPDSearchSeasonsEnabled				[kPDUserDefaults boolForKey:kPDSearchSeasonsEnabledKey]
#define kPDFacebookAccessToken				[kPDUserDefaults objectForKey:kPDFacebookAccessTokenKey]
#define kPDFacebookExpirationDate			[kPDUserDefaults objectForKey:kPDFacebookExpirationDateKey]
#define kPDDeviceToken                [kPDUserDefaults objectForKey:kPDDeviceTokenKey]
#define kPDFacebookUserName           [kPDUserDefaults objectForKey:kPDFacebookUserNameKey]
#define kPDFacebookEmail              [kPDUserDefaults objectForKey:kPDFacebookEmailKey]
#define kPDIsHelpShown                [kPDUserDefaults boolForKey:kPDIsHelpShownKey]
#define kPDAppVersion                 [kPDUserDefaults objectForKey:kPDAppVersionKey]
#define kPDIOSVersion                 [kPDUserDefaults objectForKey:kPDIOSVersionKey]
#define kPDUserLocationLongitude      [kPDUserDefaults objectForKey:kPDUserLocationLongitudeKey]
#define kPDUserLocationLatitude       [kPDUserDefaults objectForKey:kPDUserLocationLatitudeKey]
#define kPDShowNearbyPinDistance			[kPDUserDefaults floatForKey:kPDShowNearbyPinDistanceKey]
#define kPDShowNearbyPinEnabled				[kPDUserDefaults boolForKey:kPDShowNearbyPinEnabledKey]
#define kPDLastAppLaunchDate          [kPDUserDefaults objectForKey:kPDLastAppLaunchDateKey]


// Map Tools
#define kPDPhotoToolsNearbySort             [kPDUserDefaults integerForKey:kPDPhotoToolsNearbySortKey]
#define kPDPhotoToolsNearbyRange            [kPDUserDefaults doubleForKey:kPDPhotoToolsNearbyRangeKey]
#define kPDPhotoToolsNearbyDateFrom         [kPDUserDefaults integerForKey:kPDPhotoToolsNearbyDateFromKey]
#define kPDPhotoToolsNearbyDateTo           [kPDUserDefaults integerForKey:kPDPhotoToolsNearbyDateToKey]
#define kPDPhotoToolsNearbyTimeFrom         [kPDUserDefaults integerForKey:kPDPhotoToolsNearbyTimeFromKey]
#define kPDPhotoToolsNearbyTimeTo           [kPDUserDefaults integerForKey:kPDPhotoToolsNearbyTimeToKey]
#define kPDSunRiseHidden                    [kPDUserDefaults boolForKey:kPDSunRiseHiddenKey]
#define kPDSunSetHidden                     [kPDUserDefaults boolForKey:kPDSunSetHiddenKey]
#define kPDMoonRiseHidden                   [kPDUserDefaults boolForKey:kPDMoonRiseHiddenKey]
#define kPDMoonSetHidden                    [kPDUserDefaults boolForKey:kPDMoonSetHiddenKey]

// Photo Upload
#define kPDPhotoUploadedId                  [kPDUserDefaults integerForKey:kPDPhotoUploadedIdKey]

#define kPDTwitterToken						@"611337383-uQLNi49IjXXkeeNMGKtEvaC12k9sOq74ssL75uZa"
#define kPDTwitterSecret					@"y205xzQ6xWGLuR72o00MLPjnYxw2ZfpmauElSGL2dBA"

// Explore
#define kPDFilterNearbySortType             [kPDUserDefaults integerForKey:kPDFilterNearbySortTypeKey]
#define kPDFilterNearbyDateFrom             [kPDUserDefaults integerForKey:kPDFilterNearbyDateFromKey]
#define kPDFilterNearbyDateTo               [kPDUserDefaults integerForKey:kPDFilterNearbyDateToKey]
#define kPDFilterNearbyTimeFrom             [kPDUserDefaults integerForKey:kPDFilterNearbyTimeFromKey]
#define kPDFilterNearbyTimeTo               [kPDUserDefaults integerForKey:kPDFilterNearbyTimeToKey]
#define kPDFilterNearbyRange                [kPDUserDefaults doubleForKey:kPDFilterNearbyRangeKey]

// Location Services
#define kPDUserLocation                     [kPDUserDefaults objectForKey:kPDUserLocationKey]

#define kPDTodayPhotoURL                    [kPDUserDefaults URLForKey:kPDTodayPhotoURLKey]
// current production key, not used for test
//#define kPDWeatherUndergroundAPIKey         @"907e28a6333d1c2b"
// new develop key, used for test

#define kPDSharePhotoURL                    @"http://www.pashadelic.com/photos/"
//#define kPDSharePlanURL                     @"http://www.pashadelic.com/plans/"
#define kPDSharePlanURL                     @"192.168.1.13/plans/"

#define kPDPashadelicFacebookPageId         @"384780531569184"
#define kPDFacebookPageURL                  @"http://www.facebook.com/pashadelic"
#define kPDFacebookPageNativeURL            @"fb://profile/384780531569184"
#define kPDTwitterPageURL                   @"https://www.twitter.com/pashadelic"
#define kPDTwitterPageNativeURL             @"twitter:///user?screen_name=pashadelic"

enum PDUserViewSource {
	PDUserViewSourcePhotos = 0,
	PDUserViewSourceCollections,
	PDUserViewSourceFollowers,
    PDUserViewSourceAbout
};

enum PDNearbySortType {
	PDNearbySortTypeByDate = 0,
	PDNearbySortTypeByPopularity = 1,
    PDNearbySortTypeByDistance = 2
};

enum PDUserPhotosSortType {
	PDUserPhotosSortTypeByDate = 0,
	PDUserPhotosSortTypeByDistance = 1,
};

enum PDDaytime {
	PDDaytimeAllDay = 0,
	PDDaytimeDay,
	PDDaytimeNight
};

enum PDSeason {
	PDSeasonWinter = 1,
	PDSeasonSpring,
	PDSeasonSummer,
	PDSeasonAutumn
};

enum {
  PDImageFilterModeFinger = 0,
  PDImageFilterModeTiltShiftSquare,
  PDImageFilterModeTiltShiftCircle
};
typedef NSInteger PDImageFilterMode;

enum PDPhotoSpotType {
  PDPhotoSpotLike = 0,
  PDPhotoSpotComment,
  PDPhotoSpotWannaShoot
};

enum PDLocationType {
    PDLocationTypeCountry = 0,
    PDLocationTypeState,
    PDLocationTypeCity,
    PDLocationTypeLandmark,
};

#endif
