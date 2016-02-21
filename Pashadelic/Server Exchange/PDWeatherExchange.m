//
//  PDWeatherExchange.m
//  Pashadelic
//
//  Created by TungNT2 on 11/15/13.
//
//

#import "PDWeatherExchange.h"

@implementation PDWeatherExchange

- (BOOL)parseResponseData {
	if (responseData.length == 0) {
		if (self.HTTPStatusCode < 300 && self.HTTPStatusCode >= 200) {
			return YES;
		}
		self.errorDescription = NSLocalizedString(@"Server return nil", nil);
		return NO;
	}
	self.result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
	NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	if (self.debugMode) {
		NSLog(@"%@\n%@", self.URLString, response);
	}
    
    if (!response) {
		NSLog(@"%@\n%@", self.URLString, response);
		if (self.HTTPStatusCode != 0) {
			self.errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Server error %zd", nil), self.HTTPStatusCode];
		} else {
			self.errorDescription = NSLocalizedString(@"Error while parsing server response", nil);
		}
		return NO;
	}
    else {
        self.result = response;
        return  YES;
    }
    return NO;
}

- (NSString *)serverAddress
{
    return kPDWeatherUndergroundAddress;
}

- (PDWeather *)loadCurrentWeatherFromResult {
    NSDictionary *current_observationDictionary = [self.result objectForKey:@"current_observation"];
    PDWeather *currentWeather = [[PDWeather alloc] initWithDictionary:current_observationDictionary];
    return currentWeather;
}

- (NSArray *)loadForecastWeatherFromResult {
    NSDictionary *dictionaryResults = [self.result objectForKey:@"forecast"];
    NSDictionary *simpleforecastDictionary = [dictionaryResults objectForKey:@"txt_forecast"];
    
    if (![simpleforecastDictionary objectForKey:@"forecastday"]) return nil;
    
    NSArray *arrayWeather = [simpleforecastDictionary objectForKey:@"forecastday"];
    
    NSMutableArray *arrayResults = [[NSMutableArray alloc] init];
    int numberLoop = MIN(20, arrayWeather.count);
    for (int i = 0; i < numberLoop; i +=2) {
        PDWeather *weatherEntity = [[PDWeather alloc] initWithDictionary:[arrayWeather objectAtIndex:i]];
        [arrayResults addObject:weatherEntity];
    }
    return arrayResults;
}

@end
