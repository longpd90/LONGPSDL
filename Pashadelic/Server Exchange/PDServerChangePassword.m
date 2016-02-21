//
//  PDServerChangePassword.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 10.12.12.
//
//

#import "PDServerChangePassword.h"

@implementation PDServerChangePassword

- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
	self.functionPath = @"users/password.json";
	
	NSString *parameters = [NSString stringWithFormat:@"[user]current_password=%@&[user]password=%@&[user]password_confirmation=%@", oldPassword, newPassword, newPassword];
	[self requestToPutFunctionWithString:parameters];
}

@end
