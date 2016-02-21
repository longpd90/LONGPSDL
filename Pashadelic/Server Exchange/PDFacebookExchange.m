//
//  PDServerFacebook.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDFacebookExchange.h"
#import "PDGoogleAnalytics.h"
#import <Crashlytics/Crashlytics.h>

@interface PDFacebookExchange ()

@end


@implementation PDFacebookExchange

- (id)initWithDelegate:(id<PDFacebookExchangeDelegate>)delegate
{
	self  = [super init];
	if (self) {
		self.delegate = delegate;
	}
	
	return self;
}

+ (void)logout
{
	[[FBSession activeSession] closeAndClearTokenInformation];
	[[FBSession activeSession] close];
	[FBSession setActiveSession:nil];
	[kPDUserDefaults setValue:@"" forKey:kPDFacebookAccessTokenKey];
	[kPDUserDefaults setValue:@"" forKey:kPDFacebookExpirationDateKey];
}

- (void)action
{
	[self.delegate facebookDidFinish:self withResult:nil];
}

- (BOOL)parseResult:(id)result
{
	return YES;
}

- (void)failWithError:(NSString *)error
{
	NSLog(@"Facebook error:%@", error);
	[self.delegate facebookDidFail:self withError:error];
}

- (void)handleFacebookAuthentification:(FBSession *)session error:(NSError *)error
{
	if (error) {
		if ([FBErrorUtility shouldNotifyUserForError:error]) {
			[self failWithError:[FBErrorUtility userMessageForError:error]];
			CLSLog(@"Facebook authentification error: %@", [FBErrorUtility userMessageForError:error]);
			
		} else {
			[self failWithError:error.localizedDescription];
			CLSLog(@"Facebook authentification error: %@", error.localizedDescription);
		}
	} else {
		[kPDUserDefaults setValue:session.accessTokenData.accessToken forKey:kPDFacebookAccessTokenKey];
		[self action];
	}
}

- (void)handleFacebookResponce:(id)result error:(NSError *)error
{
	if (error) {
		if ([FBErrorUtility shouldNotifyUserForError:error]) {
			[self failWithError:[FBErrorUtility userMessageForError:error]];
			CLSLog(@"Facebook %@ error: %@", self, [FBErrorUtility userMessageForError:error]);
			
		} else {
			[self failWithError:error.localizedDescription];
			CLSLog(@"Facebook %@ error: %@", self, error.localizedDescription);
		}
	} else {
		if (![self parseResult:result]) {
			[self failWithError:_errorDescription];
			
		} else {
			[self.delegate facebookDidFinish:self withResult:result];
		}
	}
}

- (BOOL)checkForPermissions:(NSArray *)permissions
{
	for (NSString *permission in permissions) {
		if ([[[FBSession activeSession] permissions] indexOfObject:permission] == NSNotFound) return NO;
	}
	
	return YES;
}

- (void)loginForPublish
{
	if (![[FBSession activeSession] isOpen]) {
		[FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"]
										   defaultAudience:FBSessionDefaultAudienceEveryone
											  allowLoginUI:YES
										 completionHandler:
		 ^(FBSession *session, FBSessionState status, NSError *error) {
			 [self handleFacebookAuthentification:session error:error];
		 }];
		
	} else  {
		
		if ([self checkForPermissions:@[@"publish_stream"]]) {
			[self action];
			
		} else {
			[[FBSession activeSession] requestNewPublishPermissions:@[@"publish_stream"]
																							defaultAudience:FBSessionDefaultAudienceEveryone
																						completionHandler:^(FBSession *session, NSError *error) {
																							[self handleFacebookAuthentification:session error:error];
																						}];
		}
	}
}

- (void)loginForReadInfo
{
	NSArray *permissions = @[@"user_about_me", @"email"];
	if (![[FBSession activeSession] isOpen]) {
		[FBSession openActiveSessionWithReadPermissions:permissions
											  allowLoginUI:YES
										 completionHandler:
		 ^(FBSession *session, FBSessionState status, NSError *error) {
			 [self handleFacebookAuthentification:session error:error];
		 }];
		
	} else  {
		
		if ([self checkForPermissions:permissions]) {
			[self action];
			
		} else {
			[[FBSession activeSession] requestNewReadPermissions:permissions completionHandler:^(FBSession *session, NSError *error) {
				[self handleFacebookAuthentification:session error:error];
			}];
		}
	}
}

- (void)loginForReadFriendsList
{
	NSArray *permissions = @[@"read_friendlists"];
	if (![[FBSession activeSession] isOpen]) {
		[FBSession openActiveSessionWithReadPermissions:permissions
										   allowLoginUI:YES
									  completionHandler:
		 ^(FBSession *session, FBSessionState status, NSError *error) {
			 [self handleFacebookAuthentification:session error:error];
		 }];
		
	} else  {
		
		if ([self checkForPermissions:permissions]) {
			[self action];
			
		} else {
			[[FBSession activeSession] requestNewReadPermissions:permissions completionHandler:^(FBSession *session, NSError *error) {
				[self handleFacebookAuthentification:session error:error];
			}];
		}
	}
}

@end
