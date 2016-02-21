//
//  PDWeatherEntity.m
//  Pashadelic
//
//  Created by LongPD on 9/4/13.
//
//

#import "PDWeather.h"

@implementation PDWeather

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
		self.iconID = [dictionary objectForKey:@"icon"];
        self.iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.iconID]];
        NSDictionary *displayLocations = [dictionary objectForKey:@"display_location"];
		self.name = [displayLocations objectForKey:@"city"];
        if ([self.name rangeOfString:@"null"].location != NSNotFound) {
            self.name = @"";
        }
		self.country = [displayLocations objectForKey:@"country_iso3166"];
        if ([self.country rangeOfString:@"null"].location != NSNotFound) {
            self.country = @"";
        }
    }
    return self;
}

@end
