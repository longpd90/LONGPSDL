//
//  PDGoogleGeocoding.m
//  Pashadelic
//
//  Created by TungNT2 on 11/29/13.
//
//

#import "PDGoogleGeocoding.h"

@implementation PDGoogleGeocoding

- (void)searchPlaceGeoCodeWithSearchText:(NSString *)searchText
{
    self.functionPath = @"geocode/json";
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?address=%@&sensor=true", searchText]];
}

- (void)loadResultFromResponse:(NSDictionary *)response
{
    self.result = [response objectForKey:@"results"];
}

@end
