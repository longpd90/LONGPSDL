//
//  PDServerUsersSearch.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 17/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerUsersSearch.h"

@implementation PDServerUsersSearch

- (void)searchUsers:(NSString *)text page:(NSInteger)page
{
	self.functionPath = @"search/users.json";
    text = [text urlEncodeUsingEncoding:self.dataEncoding];
	NSString *request = [NSString stringWithFormat:@"?term=%@&page=%ld", text, (long)page];
	[self requestToGetFunctionWithString:request];
}

@end
