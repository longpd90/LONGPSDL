//
//  PDServerGoogleExchange.h
//  Pashadelic
//
//  Created by TungNT2 on 11/15/13.
//
//

#import "MGServerExchange.h"

@interface PDServerGoogleExchange : MGServerExchange
- (void)loadResultFromResponse:(NSDictionary *)response;
- (NSArray *)loadPlacesAddressFromResult;
- (NSArray *)loadPlacesFromResult;
- (NSArray *)loadGeoDataFromResult;
@end
