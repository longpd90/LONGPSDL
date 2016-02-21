//
//  PDServerPin.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPin.h"

@implementation PDServerPin

- (void)pinPhoto:(PDPhoto *)photo
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/pin_unpin.json", (long)photo.identifier];
	[self requestToPostFunctionWithString:@""];
}

- (void)unpinPhoto:(PDPhoto *)photo
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/pin_unpin.json", (long)photo.identifier];
	[self requestToPostFunctionWithString:@""];
}

@end
