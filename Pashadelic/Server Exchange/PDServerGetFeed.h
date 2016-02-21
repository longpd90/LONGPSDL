//
//  PDServerFollowingsLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 28/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"

@interface PDServerGetFeed : PDServerExchange

- (void)getFeedPage:(NSInteger)page;

@end
