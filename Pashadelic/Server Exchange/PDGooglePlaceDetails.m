//
//  PDGooglePlaceDetails.m
//  Pashadelic
//
//  Created by TungNT2 on 11/29/13.
//
//

#import "PDGooglePlaceDetails.h"

@implementation PDGooglePlaceDetails

- (void)getPlaceDetailWithReference:(NSString *)reference
{
    self.functionPath = @"place/details/json";
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?reference=%@&sensor=true&key=%@", reference, kPDGoogleAPIKey]];
}

- (void)loadResultFromResponse:(NSDictionary *)response
{
    self.result = [response objectForKey:@"result"];
}

@end
