//
//  PDServerRatePOIItem.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDServerRatePOIItem.h"

@implementation PDServerRatePOIItem

- (void)rateItem:(PDPOIItem *)item withRating:(NSUInteger)rating
{
	self.functionPath = [NSString stringWithFormat:@"gtags/%zd/vote.json?[pois]stars=%zd", item.identifier, rating];
	[self requestToPostFunctionWithString:nil];
}

@end
