//
//  PDServerRatePOIItem.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDServerExchange.h"
#import "PDPOIItem.h"

@interface PDServerRatePOIItem : PDServerExchange

- (void)rateItem:(PDPOIItem *)item withRating:(NSUInteger) rating;

@end
