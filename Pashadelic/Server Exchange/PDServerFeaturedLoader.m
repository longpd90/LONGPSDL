//
//  PDServerFeaturedLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDServerFeaturedLoader.h"

@implementation PDServerFeaturedLoader

- (void)loadFeaturedPage:(NSUInteger)page
{
	self.functionPath = @"trendings/featured.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];

}

@end
