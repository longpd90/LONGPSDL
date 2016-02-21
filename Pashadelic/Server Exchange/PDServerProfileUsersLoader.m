//
//  PDServerProfileUsersLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerProfileUsersLoader.h"

@implementation PDServerProfileUsersLoader

- (void)loadUsersForProfile:(PDUserProfile *)profile page:(NSInteger)page usersType:(NSString *)usersType
{
	self.functionPath = [NSString stringWithFormat:@"profiles/%@.json", usersType]; 
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];	
}

@end
