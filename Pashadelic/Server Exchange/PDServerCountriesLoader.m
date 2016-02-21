//
//  PDServerCountriesLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.12.12.
//
//

#import "PDServerCountriesLoader.h"

@implementation PDServerCountriesLoader

- (void)loadCountries
{
	self.functionPath = @"/profiles/get_countries.json";
	[self requestToGetFunctionWithString:nil];
}

@end
