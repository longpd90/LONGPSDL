//
//  PDServerCheckUsername.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerCheckUsername.h"

@implementation PDServerCheckUsername

- (void)checkUsername:(NSString *)username
{
	self.functionPath = @"users/check_username.json";
	NSString *request = [NSString stringWithFormat:@"?username=%@", username];
	[self requestToGetFunctionWithString:request];
}

- (BOOL)parseResponseData
{
	if (!responseData) return NO;
	
	NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];

	if (self.debugMode) {
		NSLog(@"%@", response);
	}

	if (!response) {
		NSLog(@"%@", response);
		self.errorDescription = NSLocalizedString(@"Error while parsing server response", nil);
		return NO;
	}	
	
	NSInteger statusCode = [response intForKey:@"status_code"];
	
	if (statusCode == 200 || statusCode == 402) {
		self.result = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:statusCode] forKey:@"status_code"];
		return YES;
		
	} else {
		self.errorDescription = [response objectForKey:@"message"];
		if (![self.errorDescription isKindOfClass:NSString.class]) {
			self.errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Unknown error:\n%@", nil), response];
		}
		return NO;
	}	
}

@end
