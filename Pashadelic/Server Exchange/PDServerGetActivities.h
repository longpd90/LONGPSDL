//
//  PDServerGetFeedAndActivities.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.09.13.
//
//

#import "PDServerExchange.h"

@interface PDServerGetActivities : PDServerExchange

- (void)getFeedAndActivitiesPage:(NSUInteger)page;
- (void)getFeedAndActivitiesPage:(NSUInteger)page firstLoadedTime:(NSDate *)firstLoadedTime;

@end
