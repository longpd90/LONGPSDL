//
//  PDServerLike.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerLike.h"


@implementation PDServerLike

- (void)likePhoto:(PDPhoto *)photo
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/like_unlike.json", (long)photo.identifier];
	[self requestToPostFunctionWithString:@""];
}

- (void)unlikePhoto:(PDPhoto *)photo
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/like_unlike.json", (long)photo.identifier];
	[self requestToPostFunctionWithString:@""];
}

@end
