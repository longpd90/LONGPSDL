//
//  PDWeatherLoader.m
//  Pashadelic
//
//  Created by LongPD on 9/3/13.
//
//

#import "PDWeatherLoader.h"

@implementation PDWeatherLoader

- (void)loadCurrentWeatherWithLatitude:(float)latitude longitude:(float)longitude {
    self.functionPath = @"";
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"%@/conditions/q/%f,%f.json",
                                          kPDWeatherUndergroundAPIKey,
                                          latitude,
                                          longitude]];
}

- (void)loadForecastWeatherWithLatitude:(float)latitude longitude:(float)longitude {
    self.functionPath = @"";
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"%@/forecast10day/q/%f,%f.json",
                                          kPDWeatherUndergroundAPIKey,
                                          latitude,
                                          longitude]];
}

@end
