//
//  PDServerCollectionsLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.07.13.
//
//

#import "PDServerExchange.h"

@interface PDServerCollectionsLoader : PDServerExchange

- (void)loadCollectionsPage:(NSInteger)page;

@end
