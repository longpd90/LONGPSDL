//
//  PDServerUserFollowersLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerUserFollowersLoader.h"

@implementation PDServerUserFollowersLoader

- (void)loadUserFollowers:(PDUser *)user page:(NSInteger)page
{
	self.functionPath = [NSString stringWithFormat:@"users/%ld/user_relations.json", (long)user.identifier];
	[self requestToGetFunctionWithString:@""];
}

@end
