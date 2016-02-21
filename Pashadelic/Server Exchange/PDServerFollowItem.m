//
//  PDServerFollow.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerFollowItem.h"

@implementation PDServerFollowItem

- (void)followItem:(PDItem *)item
{
	self.functionPath = item.followItemName;
	[self requestToPostFunctionWithString:@""];
}

- (void)unfollowItem:(PDItem *)item
{
	self.functionPath = item.followItemName;
	[self requestToPostFunctionWithString:@""];
}

@end
