//
//  PDGooglePlaceAutocomplete.m
//  Pashadelic
//
//  Created by TungNT2 on 11/29/13.
//
//

#import "PDGooglePlaceAutocomplete.h"

@implementation PDGooglePlaceAutocomplete

- (void)searchPlaceAutocompleteWithSearchText:(NSString *)searchText
{
    self.functionPath = @"place/autocomplete/json";
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?input=%@&sensor=true&key=%@", searchText, kPDGoogleAPIKey]];
}

- (void)loadResultFromResponse:(NSDictionary *)response
{
    self.result = [response objectForKey:@"predictions"];
}

@end
