//
//  PDGoogleAnalytics.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 31/10/12.
//
//

#import "PDGoogleAnalytics.h"

@implementation PDGoogleAnalytics

static PDGoogleAnalytics *_analyticsInstance;
+ (PDGoogleAnalytics *)sharedInstance
{
	@synchronized(self) {
		
        if (_analyticsInstance == nil) {
            _analyticsInstance = [[self alloc] init];
			_analyticsInstance.tracker = [[GAI sharedInstance] trackerWithTrackingId:kPDGoogleAnalyticsKey];
        }
    }
    return _analyticsInstance;
}

- (void)trackPage:(NSString *)pageName
{
	[_tracker set:[NSString stringWithFormat:@"%ld", (long)kPDUserID] value:@"user_id"];
	[_tracker sendView:pageName];
}

- (void)trackAction:(NSString *)actionName atPage:(NSString *)pageName
{
	[_tracker set:[NSString stringWithFormat:@"%ld", (long)kPDUserID] value:@"user_id"];
	[_tracker sendEventWithCategory:pageName
						  withAction:actionName
						   withLabel:nil
						   withValue:nil];
}

@end
