//
//  PDServerLogout.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerLogout.h"
#import "PDFacebookExchange.h"

@implementation PDServerLogout

- (void)logout
{
	[kPDUserDefaults setObject:@"" forKey:kPDAuthTokenKey];
	[kPDUserDefaults setInteger:0 forKey:kPDUserIDKey];
	kPDAppDelegate.userProfile = nil;
	[PDFacebookExchange logout];
	
	self.functionPath = [NSString stringWithFormat:@"sessions/%ld.json", (long)kPDUserID];
	[self requestToDeleteFunction];
}

@end
