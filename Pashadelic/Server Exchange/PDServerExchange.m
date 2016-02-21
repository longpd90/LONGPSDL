//
//  PDServerExchange.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
#import "PDComment.h"
#import "PDActivityItem.h"
#import "PDNotificationItem.h"
#import "PDPlan.h"
#import "PDPOIItem.h"
#import "PDPhotoLandMarkItem.h"

@interface PDServerExchange (Private)
@end

@implementation PDServerExchange

- (BOOL)parseResponseData
{
	NSError *error;
    if ([responseData isKindOfClass:[NSData class]] && responseData.length == 0) {
		if (self.HTTPStatusCode >= 200 && self.HTTPStatusCode < 300) return YES;
		
		if (self.HTTPStatusCode != 0) {
			self.errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Server error %zd", nil), self.HTTPStatusCode];
		} else {
			self.errorDescription = NSLocalizedString(@"Response from server is null", nil);
		}
		return NO;
	}

	id response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];

	if (error) {
		self.errorDescription = error.localizedDescription;
        NSLog(@"Error parse response: %@", self.errorDescription);
		NSLog(@"%@\n%@", self.URLString, [[NSString alloc] initWithData:responseData encoding:self.dataEncoding]);
	}

	
	if (self.debugMode) {
		NSLog(@"%@\n%@", self.URLString, response);
	}
	

	if (!response) {
		NSLog(@"%@\n%@", self.URLString, response);
		if (self.HTTPStatusCode != 0) {
			self.errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Server error %zd", nil), self.HTTPStatusCode];
		} else {
			self.errorDescription = NSLocalizedString(@"Error while parsing server response", nil);
		}
		return NO;
	}
	
	if ([response isKindOfClass:[NSArray class]]) {
		self.result = @{@"data": response};
		return YES;
	}
	
	NSInteger statusCode = [response intForKey:@"status_code"];
	
	if (statusCode == 401) {
		[kPDAppDelegate login];
		self.result = nil;
		return YES;
	}
	
	if (statusCode == 200 || statusCode == 201) {
		self.result = [response objectForKey:@"data"];
		return YES;
		
	} else {
		NSLog(@"%@\n%@", self.URLString, response);
		self.errorDescription = [response objectForKey:@"message"];
		if (![self.errorDescription isKindOfClass:NSString.class]) {
			self.errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Unknown error:\n%@", nil), response];
		}
		return NO;
	}
}

- (BOOL)debugMode
{
	return NO;
}

- (BOOL)parseResult
{	
	return YES;
}

- (NSString *)serverAddress
{
	return kPDServerAddress;
}

- (NSArray *)loadPhotosFromArray:(NSArray *)sourceArray
{
	if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
	NSMutableArray *array = [NSMutableArray array];
	
	for (NSDictionary *item in sourceArray) {
		PDPhoto *photo = [[PDPhoto alloc] init];
		[photo loadShortDataFromDictionary:item];
		[array addObject:photo];
	}
	return array;
}

- (NSArray *)loadUsersFromArray:(NSArray *)sourceArray
{
	if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (NSDictionary *item in sourceArray) {
		PDUser *user = [[PDUser alloc] init];
		[user loadShortDataFromDictionary:item];
		[array addObject:user];
	}
	return array;
}

- (NSArray *)loadUsersFromResult:(NSDictionary *)result
{
	NSMutableArray *array = [NSMutableArray array];
	NSArray *resultItems = [result valueForKey:@"users"];
	
	for (NSDictionary *item in resultItems) {
		PDUser *user = [[PDUser alloc] init];
		[user loadShortDataFromDictionary:item];
        if (user.identifier == kPDUserID)
            continue;
		[array addObject:user];
	}
	return array;
}


- (NSArray *)loadNotificationItemsFromArray:(NSArray *)sourceArray
{
	if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (NSDictionary *item in sourceArray) {
		PDNotificationItem *notificationItem = [[PDNotificationItem alloc] init];
		[notificationItem loadShortDataFromDictionary:item];
		[array addObject:notificationItem];
	}
	return array;
}

- (NSArray *)loadPlansItemsFromArray:(NSArray *)sourceArray
{
	if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (NSDictionary *item in sourceArray) {
		PDPlan *planItem = [[PDPlan alloc] init];
		[planItem loadDataFromDictionary:item];
		[array addObject:planItem];
	}
	return array;
}

- (NSArray *)loadLandmarkItemsFromArray:(NSArray *)sourceArray
{
	if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (NSDictionary *item in sourceArray) {
		PDPhotoLandMarkItem *landmarkItem = [[PDPhotoLandMarkItem alloc] init];
		[landmarkItem loadDataFromDictionary:item];
		[array addObject:landmarkItem];
	}
	return array;
}

- (NSArray *)loadActivityItemsFromArray:(NSArray *)sourceArray
{
	if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
	
	NSMutableArray *array = [NSMutableArray array];
	
	for (NSDictionary *item in sourceArray) {
		PDActivityItem *feedItem = [[PDActivityItem alloc] init];
		[feedItem loadShortDataFromDictionary:item];
		[array addObject:feedItem];
	}
	return array;
}

- (NSArray *)loadCommentsFromArray:(NSArray *)sourceArray
{
	if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
	NSMutableArray *array = [NSMutableArray array];
	for (NSDictionary *item in sourceArray) {
		PDComment *comment = [[PDComment alloc] init];
		[comment loadFullDataFromDictionary:item];
        if (!comment.identifier)
            continue;
		[array addObject:comment];
	}
	return array;
}

- (NSArray *)loadLandmarkFromArray:(NSArray *)sourceArray
{
	if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *array = [NSMutableArray array];
	for (NSDictionary *item in sourceArray) {
		PDPOIItem *poiItem = [[PDPOIItem alloc] init];
		[poiItem loadFullDataFromDictionary:item];
		[array addObject:poiItem];
	}
	return array;
}

- (BOOL)trackUploadDataProgress
{
	return NO;
}

- (void)setHeadersForHTTPRequest:(NSMutableURLRequest *)request
{
	[super setHeadersForHTTPRequest:request];
    [request setValue:kPDAuthToken forHTTPHeaderField:@"X-AUTH-TOKEN"];
	[request setValue:kPDDeviceToken forHTTPHeaderField:@"X-DEVICE-TOKEN"];
	[request setValue:kPDFacebookAccessToken forHTTPHeaderField:@"X-FB-AUTH-TOKEN"];
	[request setValue:[[NSLocale preferredLanguages] objectAtIndex:0] forHTTPHeaderField:@"HTTP_ACCEPT_LANGUAGE"];
	[request setValue:kPDAppVersion forHTTPHeaderField:@"X-APP-VERSION"];
	[request setValue:kPDIOSVersion forHTTPHeaderField:@"X-OS-VERSION"];
	[request setValue:kPDUserLocationLatitude forHTTPHeaderField:@"X-USER-LAT"];
	[request setValue:kPDUserLocationLongitude forHTTPHeaderField:@"X-USER-LON"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
}

#pragma mark - Connection delegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	if ([self trackUploadDataProgress]) {
		double value = (float) totalBytesWritten / totalBytesExpectedToWrite;
		kPDAppDelegate.uploadPhotoView.progress = value;
	}
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] &&
        [challenge.protectionSpace.host hasSuffix:@"pashadelic.com"]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    } else
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
        
    } else {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic] && challenge.previousFailureCount < 1) {
            NSURLCredential *credentials = [[NSURLCredential alloc] initWithUser:self.login password:self.password persistence:NSURLCredentialPersistenceNone];
            [[challenge sender] useCredential:credentials forAuthenticationChallenge:challenge];
            
        } else {
            [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];

        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.loading = NO;
    [self decrementInternetActivitiesCount];
    if (error.code != kCFURLErrorUserCancelledAuthentication) {
        [self finishLoadingWithError:error.localizedDescription];
    }
}

@end
