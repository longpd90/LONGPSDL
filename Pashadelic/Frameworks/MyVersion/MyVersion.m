//
//  MyVersion.m
//
//  Created by TungNT2 on 3/21/13.
//

#import "MyVersion.h"

#define REQUEST_TIMEOUT 60.0

@class MyVersion;


@implementation NSString(MyVersion)

- (NSComparisonResult)compareVersion:(NSString *)version
{
    return [self compare:version options:NSNumericSearch];
}

- (NSComparisonResult)compareVersionDescending:(NSString *)version
{
    switch ([self compareVersion:version])
    {
        case NSOrderedAscending:
        {
            return NSOrderedDescending;
        }
        case NSOrderedDescending:
        {
            return NSOrderedAscending;
        }
        default:
        {
            return NSOrderedSame;
        }
    }
}

@end

@interface MyVersion ()
@property (nonatomic, retain)NSString *versionIgnore;
@property (nonatomic, copy) NSString *downloadButtonTitle;
@property (nonatomic, copy) NSString *remindButtonTitle;
@property (nonatomic, strong) NSURL *updateURL;
@property (nonatomic, assign) BOOL _useAppStoreDetailsIfNoPlistEntryFound;
@property (nonatomic, copy) NSString *applicationVersion;
@property (nonatomic, strong) NSString *ignoredVersion;
// Check new version for download
- (NSString *)localizedStringForKey:(NSString *)key withDefault:(NSString *)defaultString;
- (void)openAppPageAppDownload;
@end


// Check Version Class
@implementation MyVersion

@synthesize appStoreID;

//application details - these are set automatically

@synthesize appStoreCountry;
@synthesize applicationBundleID;

@synthesize updateURL;

@synthesize updateTitle;
@synthesize updateDescription;
@synthesize downloadButtonTitle;
@synthesize remindButtonTitle;
@synthesize latestVersion;

static MyVersion *shareInstance;

#pragma mark - iLifecycle methods

+ (MyVersion *)shareMyInstance;
{
	@synchronized([MyVersion class])
	{
		if (!shareInstance)
            shareInstance = [[self alloc] init] ;
        
		return shareInstance;
	}
    
	return nil;
}

+ (id)alloc
{
	@synchronized([MyVersion class])
	{
		NSAssert(shareInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		shareInstance = [super alloc];
		return shareInstance;
	}
    
	return nil;
}

- (id)init {
	self = [super init];
	if (self) {
        self.appStoreCountry = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        self.applicationBundleID = [[NSBundle mainBundle] bundleIdentifier];
        self.applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        if ([self.applicationVersion length] == 0)
        {
            self.applicationVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        }
        self.useAllAvailableLanguages = YES;
	}
	return self;
}

- (void)setAppStoreID:(int)newAppStoreID
{
    appStoreID = newAppStoreID;
    self.updateURL = [NSURL URLWithString:[NSString stringWithFormat:kMViOSAppStoreURLFormat, (unsigned int)self.appStoreID]];
}

- (NSString *)downloadButtonTitle
{
    return downloadButtonTitle ?: [self localizedStringForKey:kMVDownloadButtonTitleKey
                                                  withDefault:kMVDownloadButtonTitleKey];
}

- (NSString *)remindButtonTitle
{
    return remindButtonTitle ?: [self localizedStringForKey:kMVRemindButtonTitleKey
                                                withDefault:kMVRemindButtonTitleKey];
}

- (NSString *)ignoredVersion
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:iVersionIgnoreVersionKey];
}

- (void)setIgnoredVersion:(NSString *)version
{
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:iVersionIgnoreVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)localizedStringForKey:(NSString *)key withDefault:(NSString *)defaultString
{
    static NSBundle *bundle = nil;
    if (bundle == nil)
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"MyVersion" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath] ?: [NSBundle mainBundle];
        if (self.useAllAvailableLanguages)
        {
            //manually select the desired lproj folder
            for (NSString *language in [NSLocale preferredLanguages])
            {
                if ([[bundle localizations] containsObject:language])
                {
                    bundlePath = [bundle pathForResource:language ofType:@"lproj"];
                    bundle = [NSBundle bundleWithPath:bundlePath];
                    break;
                }
            }
        }
    }
    defaultString = [bundle localizedStringForKey:key value:defaultString table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:defaultString table:nil];
}


# pragma mark - Check New Version

- (void)checkNewVersionInBackground
{
	if (self.applicationBundleID.length == 0) return;
	
	__block NSString *newVersion = nil;

	NSString *iTunesServiceURL = [NSString stringWithFormat:kMVAppLookupURLFormat, self.appStoreCountry];
	iTunesServiceURL = [iTunesServiceURL stringByAppendingFormat:@"?id=%u", (unsigned int)self.appStoreID];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:iTunesServiceURL]
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval:REQUEST_TIMEOUT];
	[NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
		if (data && statusCode==200)
		{
			NSString *json = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
			NSString *bundleID = [self valueForKey:@"bundleId" inJSON:json];
			if (bundleID) {
				if ([bundleID isEqualToString:self.applicationBundleID]) {
					newVersion = [self valueForKey:@"version" inJSON:json];
					if (newVersion.floatValue > self.applicationVersion.floatValue) {
						self.latestVersion = newVersion;
						if (![self.ignoredVersion isEqualToString:self.latestVersion]) {
                            [self performSelectorOnMainThread:@selector(showInfoUpdate) withObject:nil waitUntilDone:NO];
                        }
					}
				}
			}
			
		}
		
	}];
}



# pragma mark - Alert View

- (void)showInfoUpdate
{
    self.updateTitle = [NSString stringWithFormat:[self localizedStringForKey:kMVUpdateAvailableTitleKey
                                                             withDefault:kMVUpdateAvailableTitleKey],
                   [MyVersion shareMyInstance].latestVersion];
    
    self.updateDescription = [self localizedStringForKey:kMVUpdateAvailableDescriptionKey
                                   withDefault:kMVUpdateAvailableDescriptionKey];

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:updateTitle
                                                       message:updateDescription delegate:(id<UIAlertViewDelegate>)self
                                             cancelButtonTitle:self.downloadButtonTitle
                                             otherButtonTitles:self.remindButtonTitle, nil];
    [alertView show];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openAppPageAppDownload];
    } else {
        self.ignoredVersion = latestVersion;
    }
}

# pragma mark - open App in Page Appstore

- (NSString *)currentVersion
{
    NSString *version;
    float versionIphone = [[UIDevice currentDevice].systemVersion floatValue];
    version = [NSString stringWithFormat:@"%f",versionIphone];
    return version;
}


- (void)openAppPageAppDownload
{
    [[UIApplication sharedApplication] openURL:self.updateURL];
}


- (void)productViewControllerDidFinish:(SKStoreProductViewController *)controller
{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


# pragma mark - Parser file String

- (NSString *)valueForKey:(NSString *)key inJSON:(NSString *)json
{
    NSRange keyRange = [json rangeOfString:[NSString stringWithFormat:@"\"%@\"", key]];
    if (keyRange.location != NSNotFound)
    {
        NSInteger start = keyRange.location + keyRange.length;
        NSRange valueStart = [json rangeOfString:@":" options:0 range:NSMakeRange(start, [json length] - start)];
        if (valueStart.location != NSNotFound)
        {
            start = valueStart.location + 1;
            NSRange valueEnd = [json rangeOfString:@"," options:0 range:NSMakeRange(start, [json length] - start)];
            if (valueEnd.location != NSNotFound)
            {
                NSString *value = [json substringWithRange:NSMakeRange(start, valueEnd.location - start)];
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                while ([value hasPrefix:@"\""] && ![value hasSuffix:@"\""])
                {
                    if (valueEnd.location == NSNotFound)
                    {
                        break;
                    }
                    NSInteger newStart = valueEnd.location + 1;
                    valueEnd = [json rangeOfString:@"," options:0 range:NSMakeRange(newStart, [json length] - newStart)];
                    value = [json substringWithRange:NSMakeRange(start, valueEnd.location - start)];
                    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                }
                
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
                value = [value stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
                value = [value stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
                value = [value stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
                value = [value stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                value = [value stringByReplacingOccurrencesOfString:@"\\r" withString:@"\r"];
                value = [value stringByReplacingOccurrencesOfString:@"\\t" withString:@"\t"];
                value = [value stringByReplacingOccurrencesOfString:@"\\f" withString:@"\f"];
                value = [value stringByReplacingOccurrencesOfString:@"\\b" withString:@"\f"];
                
                while (YES)
                {
                    NSRange unicode = [value rangeOfString:@"\\u"];
                    if (unicode.location == NSNotFound)
                    {
                        break;
                    }
                    
                    uint32_t c = 0;
                    NSString *hex = [value substringWithRange:NSMakeRange(unicode.location + 2, 4)];
                    NSScanner *scanner = [NSScanner scannerWithString:hex];
                    [scanner scanHexInt:&c];
                    
                    if (c <= 0xffff)
                    {
                        value = [value stringByReplacingCharactersInRange:NSMakeRange(unicode.location, 6)
                                                               withString:[NSString stringWithFormat:@"%C", (unichar)c]];
                    }
                    else
                    {
                        //convert character to surrogate pair
                        uint16_t x = (uint16_t)c;
                        uint16_t u = (c >> 16) & ((1 << 5) - 1);
                        uint16_t w = (uint16_t)u - 1;
                        unichar high = 0xd800 | (w << 6) | x >> 10;
                        unichar low = (uint16_t)(0xdc00 | (x & ((1 << 10) - 1)));
                        
                        value = [value stringByReplacingCharactersInRange:NSMakeRange(unicode.location, 6)
                                                               withString:[NSString stringWithFormat:@"%C%C", high, low]];
                    }
                }
                return value;
            }
        }
    }
    return nil;
}

@end