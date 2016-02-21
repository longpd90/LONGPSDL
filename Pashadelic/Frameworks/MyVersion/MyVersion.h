//
//  MyVersion.h
//  Created by TungNT2 on 3/21/13.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kMVAppLookupURLFormat                    @"http://itunes.apple.com/%@/lookup"
#define kMViOSAppStoreURLFormat                  @"itms-apps://itunes.apple.com/app/id%u"
#define kMVUpdateAvailableTitleKey               @"kMVUpdateAvailableTitleKey"
#define kMVUpdateAvailableDescriptionKey         @"kMVUpdateAvailableDescriptionKey"
#define kMVDownloadButtonTitleKey                @"kMVDownloadButtonTitleKey"
#define kMVRemindButtonTitleKey                  @"kMVRemindButtonTitleKey"
#define iVersionIgnoreVersionKey                 @"iVersionIgnoreVersion"

@interface NSString (MyVersion)
- (NSComparisonResult)compareVersion:(NSString *)version;
- (NSComparisonResult)compareVersionDescending:(NSString *)version;
@end


@interface MyVersion : NSObject
//app store ID - this is only needed if your
//bundle ID is not unique between iOS and Mac app stores
@property (nonatomic, assign) int appStoreID;

//usage settings - these have sensible defaults
@property (nonatomic, assign) float remindPeriod;


//application details - these are set automatically
@property(nonatomic, strong) NSString *appStoreCountry;
@property (nonatomic, copy) NSString *applicationBundleID;
@property (nonatomic , strong) NSString *updateTitle;
@property (nonatomic, strong) NSString *latestVersion;
@property (nonatomic, strong) NSString *updateDescription;

// property detail you can config
@property (nonatomic, assign) BOOL useAllAvailableLanguages;


// init method
+ (MyVersion *)shareMyInstance;
+ (id)alloc;
- (void)checkNewVersionInBackground;
@end
