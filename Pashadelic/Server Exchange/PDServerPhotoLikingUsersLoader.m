//
//  PDServerPhotoLikingUsersLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPhotoLikingUsersLoader.h"

@implementation PDServerPhotoLikingUsersLoader

- (void)loadLikingUsersForPhoto:(PDPhoto *)photo page:(NSInteger)page
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/liking_users.json", (long)photo.identifier];
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%ld", (long)page]];
}

@end
