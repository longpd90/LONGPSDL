//
//  PDServerUserFollowersLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerUserFollowersLoader : PDServerExchange

- (void)loadUserFollowers:(PDUser *)user page:(NSInteger)page;

@end
