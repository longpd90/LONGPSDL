//
//  PDGooglePlaceAutocomplete.h
//  Pashadelic
//
//  Created by TungNT2 on 11/29/13.
//
//

#import "PDServerGoogleExchange.h"

@interface PDGooglePlaceAutocomplete : PDServerGoogleExchange
- (void)searchPlaceAutocompleteWithSearchText:(NSString *)searchText;
@end
