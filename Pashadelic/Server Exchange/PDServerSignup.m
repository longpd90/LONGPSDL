//
//  PDServerSignup.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 17/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerSignup.h"

@implementation PDServerSignup

- (void)signupWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email
{
	self.functionPath = @"users.json";
    // only accept japanese or english language. Default language is english
    NSString *preferredLanguages = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (![preferredLanguages isEqualToString:@"ja"] || ![preferredLanguages isEqualToString:@"en"] || !([preferredLanguages rangeOfString:@"zh"].location != NSNotFound))
        preferredLanguages = @"en";
	NSString *post = [NSString stringWithFormat:@"user[username]=%@&user[password]=%@&user[email]=%@&user[locale]=%@", username, [password urlEncodeUsingEncoding:self.dataEncoding], email, preferredLanguages];
	[self requestToPostFunctionWithString:post];
}

@end
