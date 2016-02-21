//
//  PDWeatherExchange.h
//  Pashadelic
//
//  Created by TungNT2 on 11/15/13.
//
//

#import "MGServerExchange.h"
#import "PDWeather.h"

@interface PDWeatherExchange : MGServerExchange
- (PDWeather *)loadCurrentWeatherFromResult;
- (NSArray *)loadForecastWeatherFromResult;
@end
