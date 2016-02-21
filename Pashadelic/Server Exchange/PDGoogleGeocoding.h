//
//  PDGoogleGeocoding.h
//  Pashadelic
//
//  Created by TungNT2 on 11/29/13.
//
//

#import "PDServerGoogleExchange.h"

@interface PDGoogleGeocoding : PDServerGoogleExchange
- (void)searchPlaceGeoCodeWithSearchText:(NSString *)searchText;
@end
