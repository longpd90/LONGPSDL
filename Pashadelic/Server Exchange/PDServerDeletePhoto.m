//
//  PDServerDeletePhoto.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerDeletePhoto.h"

@implementation PDServerDeletePhoto

- (void)deletePhoto:(PDPhoto *)photo
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld.json", (long)photo.identifier];
	[self requestToDeleteFunction];
}

@end
