//
//  PDServerSignupWithFacebook.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerSignupWithFacebook.h"

@implementation PDServerSignupWithFacebook

- (void)signupWithFacebook
{
	self.functionPath = @"facebook_auth_token.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?fb_access_token=%@", kPDFacebookAccessToken]];
}

@end
