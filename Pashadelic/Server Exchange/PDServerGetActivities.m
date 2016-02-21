//
//  PDServerGetFeedAndActivities.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.09.13.
//
//

#import "PDServerGetActivities.h"

@implementation PDServerGetActivities

- (void)getFeedAndActivitiesPage:(NSUInteger)page
{
    self.functionPath = @"activities/index_v2.json";
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

- (void)getFeedAndActivitiesPage:(NSUInteger)page firstLoadedTime:(NSDate *)firstLoadedTime
{
    self.functionPath = @"activities/index_v2.json";
    NSString *firstLoadedTimeString = [self UTCTimeStringFromDate:firstLoadedTime];
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd&check=%@", page, firstLoadedTimeString]];
}

- (NSString *)UTCTimeStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter stringFromDate:date];
}

@end
