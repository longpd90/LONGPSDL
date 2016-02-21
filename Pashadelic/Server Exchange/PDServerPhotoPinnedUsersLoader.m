//
//  PDServerPhotoPinnedUsersLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPhotoPinnedUsersLoader.h"

@implementation PDServerPhotoPinnedUsersLoader

- (void)loadPinnedUsersForPhoto:(PDPhoto *)photo page:(NSInteger)page
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/pinned_users.json", (long)photo.identifier];
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}


@end
