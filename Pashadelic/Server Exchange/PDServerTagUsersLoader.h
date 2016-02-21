//
//  PDServerTagUsersLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.04.13.
//
//

#import "PDServerExchange.h"
#import "PDTag.h"

@interface PDServerTagUsersLoader : PDServerExchange

- (void)loadTagUsers:(PDTag *)tag page:(NSUInteger)page;

@end
