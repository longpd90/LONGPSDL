//
//  PDServerFollow.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
#import "PDItem.h"

@interface PDServerFollowItem : PDServerExchange

- (void)followItem:(PDItem *)item;
- (void)unfollowItem:(PDItem *)item;

@end
