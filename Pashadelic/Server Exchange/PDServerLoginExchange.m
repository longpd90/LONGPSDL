//
//  PDServerLoginExchange.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerLoginExchange.h"
#import "PDUserProfile.h"

@implementation PDServerLoginExchange

- (BOOL)parseResult
{
	NSString *token = [self.result objectForKey:@"auth_token"];
	if (token) {
		[kPDUserDefaults setValue:token forKey:kPDAuthTokenKey];
		[kPDUserDefaults synchronize];
		NSInteger userID = [self.result intForKey:@"id"];
		if (userID > 0) {
			[kPDUserDefaults setInteger:userID forKey:kPDUserIDKey];
			[kPDUserDefaults synchronize];
			kPDAppDelegate.userProfile = [[PDUserProfile alloc] init];
			kPDAppDelegate.userProfile.identifier = kPDUserID;
            kPDAppDelegate.userProfile.unreadItemsCount = [self.result intForKey:@"count"];
            [[Mixpanel sharedInstance] identify:[NSString stringWithFormat:@"%ld", (long)userID]];
			return YES;
		}
		self.errorDescription = NSLocalizedString(@"Can't get user ID from server", nil);
		return NO;
	}
	self.errorDescription = NSLocalizedString(@"Can't get auth token key", nil);
	return NO;
}

@end
