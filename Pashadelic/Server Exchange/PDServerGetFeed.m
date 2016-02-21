//
//  PDServerFollowingsLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 28/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerGetFeed.h"

@implementation PDServerGetFeed

- (void)getFeedPage:(NSInteger)page
{
	self.functionPath = @"followings.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

@end
