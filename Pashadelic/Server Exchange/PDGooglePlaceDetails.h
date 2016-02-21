//
//  PDGooglePlaceDetails.h
//  Pashadelic
//
//  Created by TungNT2 on 11/29/13.
//
//

#import "PDServerGoogleExchange.h"

@interface PDGooglePlaceDetails : PDServerGoogleExchange
- (void)getPlaceDetailWithReference:(NSString *)reference;
@end
