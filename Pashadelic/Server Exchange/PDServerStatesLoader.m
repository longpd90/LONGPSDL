//
//  PDServerStatesLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.12.12.
//
//

#import "PDServerStatesLoader.h"

@implementation PDServerStatesLoader

- (void)loadStatesForCountryWithID:(NSInteger)identifier
{
	self.functionPath =  @"/profiles/get_states.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?country_id=%zd", identifier]];
}

@end
