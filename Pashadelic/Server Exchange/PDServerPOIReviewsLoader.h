//
//  PDServerPOIReviewsLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDServerExchange.h"
#import "PDPOIItem.h"

@interface PDServerPOIReviewsLoader : PDServerExchange

- (void)loadReviewsForItem:(PDPOIItem *)item;

@end
