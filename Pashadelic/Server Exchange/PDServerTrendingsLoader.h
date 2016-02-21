//
//  PDServerTrendingsLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDServerExchange.h"

@interface PDServerTrendingsLoader : PDServerExchange

- (void)loadTrendingsPage:(NSUInteger)page;

@end
