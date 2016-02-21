//
//  PDServerForgotPassword.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.12.12.
//
//

#import "PDServerForgotPassword.h"

@implementation PDServerForgotPassword

- (void)forgotPassword
{
	self.functionPath = @"users/password.json?[user]email";
	[self requestToPostFunctionWithString:@""];
}

@end
