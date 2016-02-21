//
//  PDServerGetTodaysPhoto.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 06.09.13.
//
//

#import "PDServerGetTodaysPhoto.h"

@implementation PDServerGetTodaysPhoto

- (void)getTodaysPhoto
{
	self.functionPath = @"photos/photo_of_day.json";
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
	dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?date=%@", string]];
}

@end
