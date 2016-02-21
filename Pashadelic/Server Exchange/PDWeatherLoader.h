//
//  PDWeatherLoader.h
//  Pashadelic
//
//  Created by LongPD on 9/3/13.
//
//
#import "PDWeatherExchange.h"

@interface PDWeatherLoader : PDWeatherExchange
- (void)loadCurrentWeatherWithLatitude:(float)latitude longitude:(float)longitude;
- (void)loadForecastWeatherWithLatitude:(float)latitude longitude:(float)longitude;
@end
