//
//  PDServerLogin.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerLogin.h"

@implementation PDServerLogin

- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
	self.functionPath = [NSString stringWithFormat:@"sessions.json?username=%@&password=%@", username, password];
	[self requestToPostFunctionWithString:nil];
}

@end
