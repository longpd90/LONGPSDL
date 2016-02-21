//
//  PDServerCheckEmail.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 05.02.13.
//
//

#import "PDServerCheckEmail.h"

@implementation PDServerCheckEmail

- (void)checkEmail:(NSString *)email
{
	self.functionPath = @"users/check_email.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?email=%@", email]];
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
		self.result = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:statusCode] forKey:@"status_code"];
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
