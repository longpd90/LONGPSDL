//
//  PDServerFeaturedLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDServerExchange.h"

@interface PDServerFeaturedLoader : PDServerExchange

- (void)loadFeaturedPage:(NSUInteger)page;

@end
