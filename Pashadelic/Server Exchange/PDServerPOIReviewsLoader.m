//
//  PDServerPOIReviewsLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDServerPOIReviewsLoader.h"

@implementation PDServerPOIReviewsLoader

- (void)loadReviewsForItem:(PDPOIItem *)item
{
	self.functionPath = [NSString stringWithFormat:@"gtags/%zd/reviews.json", item.identifier];
	[self requestToGetFunctionWithString:nil];
}

@end
