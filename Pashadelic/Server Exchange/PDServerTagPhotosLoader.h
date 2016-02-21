//
//  PDServerTagPhotosLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.04.13.
//
//

#import "PDServerExchange.h"
#import "PDTag.h"

@interface PDServerTagPhotosLoader : PDServerExchange

- (void)loadTagPhotos:(PDTag *)tag page:(NSUInteger)page;

@end
