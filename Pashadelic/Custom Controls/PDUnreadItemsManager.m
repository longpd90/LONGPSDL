//
//  PDUnreadItemsManager.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 14.01.13.
//
//

#import "PDServerLoadNotReadFeedItems.h"
#import "PDUserProfile.h"

@interface PDUnreadItemsManager ()
<MGServerExchangeDelegate>
{
	PDServerExchange *serverExchange;
}

- (void)refreshUnreadItemsCount;
@end


@implementation PDUnreadItemsManager

static PDUnreadItemsManager *_instance;
+ (PDUnreadItemsManager *)instance
{
	@synchronized(self) {
		
        if (_instance == nil) {
            _instance = [[super alloc] init];
        }
    }
    return _instance;
}


#pragma mark - Private

- (void)refreshUnreadItemsCount
{
    kPDAppDelegate.userProfile.unreadItemsCount = _unreadItemsCount;
    kPDAppDelegate.userProfile.plansUpcomingCount = _upcomingPlanCount;
	[self refreshAppBadgeCount];
}


#pragma mark - Public

- (void)fetchData
{
	if ([kPDAuthToken length] == 0) return;
	
	serverExchange = [[PDServerLoadNotReadFeedItems alloc] initWithDelegate:self];
	[(PDServerLoadNotReadFeedItems *) serverExchange loadNotReadFeedItems];
}

- (void)initialize
{
}

- (void)refreshAppBadgeCount
{
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:_unreadItemsCount];
}

- (void)reset
{
    _unreadItemsCount = 0;
	[self refreshUnreadItemsCount];
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    _unreadItemsCount = [result intForKey:@"count"];
    _upcomingPlanCount = [result intForKey:@"upcoming_plan_count"];
	[self refreshUnreadItemsCount];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	NSLog(@"%@", error);
}


@end
