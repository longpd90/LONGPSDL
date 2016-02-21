//
//  NSString+Date.h
//  Pashadelic
//
//  Created by LTT on 6/24/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

+ (NSString *)stringDate:(NSDate *)date dateFormatter:(NSString *)dateFormatter;
+ (NSString *)stringSuffixDateWithDate:(NSDate *)date dateFormatter:(NSString *)dateFormatter;
+ (NSString *)stringSuffixDateWithUTCDateString:(NSString *)UTCDate;
+ (NSString *)stringSuffixDateWithUTCDateString:(NSString *)UTCDate dateFormatter: (NSString *)dateFormatter;
@end
