//
//  NSString+Date.m
//  Pashadelic
//
//  Created by LTT on 6/24/14.
//
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSString *)stringDate:(NSDate *)date dateFormatter:(NSString *)dateFormatter
{
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateFormat:dateFormatter];
    return  [dFormatter stringFromDate:date];
}

+ (NSString *)stringSuffixDateWithDate:(NSDate *)date dateFormatter:(NSString *)dateFormatter
{
    NSDateFormatter *suffixDateFormatter = [[NSDateFormatter alloc] init];
    
    [suffixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    [suffixDateFormatter setDateFormat:dateFormatter];
    
    NSString * suffixDateString = [suffixDateFormatter stringFromDate:date];
    
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    
    [monthDayFormatter setDateFormat:@"d"];
    
    int dateDay = [[monthDayFormatter stringFromDate:date] intValue];
    
    NSString *suffixString = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    
    NSArray *suffixes = [suffixString componentsSeparatedByString: @"|"];
    
    NSString *suffix = [suffixes objectAtIndex:dateDay];

    suffixDateString = [suffixDateString stringByReplacingOccurrencesOfString:@"." withString:suffix];
    
    NSString *dateString =suffixDateString;
    
    return dateString;
}

+ (NSString *)stringSuffixDateWithUTCDateString:(NSString *)UTCDate
{
    
    NSDate *localDate = [self localTimeFromUTC: UTCDate];
    
    return [self stringSuffixDateWithDate:localDate dateFormatter:@"MMM d. HH:mm"];
}

+ (NSString *)stringSuffixDateWithUTCDateString:(NSString *)UTCDate dateFormatter: (NSString *)dateFormatter
{
    
    NSDate *localDate = [self localTimeFromUTC: UTCDate];
    
    return [self stringSuffixDateWithDate:localDate dateFormatter:dateFormatter];
}

+ (NSDate *)localTimeFromUTC:(NSString *)utcTimeString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    return [dateFormatter dateFromString:utcTimeString];
    
}
@end
