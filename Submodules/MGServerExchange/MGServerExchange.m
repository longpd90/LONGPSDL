//
//  MGServerExchange.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MGServerExchange.h"
#import "Reachability.h"
#import "MGAppDelegate.h"
#import "AdditionalFunctions.h"

@interface MGServerExchange ()
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) MGServerExchangeDidFail errorHandler;
@property (strong, nonatomic) MGServerExchangeDidLoadData successHandler;
@end


@implementation MGServerExchange
@synthesize result, delegate, errorDescription, functionPath;

- (id)initWithDelegate:(id<MGServerExchangeDelegate>)initDelegate
{
	self = [super init];
	
	if (self) {
		delegate = initDelegate;
	}
	return self;
}

- (void)dealloc
{
	if (self.isLoading) {
		[self decrementInternetActivitiesCount];
	}
}

- (void)cancel
{
	if (self.isLoading) {
		[self decrementInternetActivitiesCount];
	}
	[self.connection cancel];
	responseData = [NSMutableData data];
}

- (BOOL)parseResponseData
{
	if (responseData.length == 0) {
		if (self.HTTPStatusCode < 300 || self.HTTPStatusCode >= 200) {
			return YES;
		}
		self.errorDescription = NSLocalizedString(@"Server return nil", nil);
		return NO;
	}
	self.result = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
	
	if (self.debugMode) {
		NSLog(@"%@\n%@", self.URLString, self.result);
	}
	
	if (!self.result) {
		self.result = [[NSString alloc] initWithData:responseData encoding:self.dataEncoding];
	}
	
	if (!self.result && (self.HTTPStatusCode >= 300 || self.HTTPStatusCode < 200)) {
		NSLog(@"%@\n%@", self.URLString, self.result);
		if (self.HTTPStatusCode != 0) {
			errorDescription = [NSString stringWithFormat:NSLocalizedString(@"Server error %d", nil), self.HTTPStatusCode];
		} else {
			errorDescription = NSLocalizedString(@"Error while parsing server response", nil);
		}
		return NO;
	}
	
	return YES;
}

- (NSString *)serverAddress
{
	return @"";
}

- (NSString *)login
{
	return @"";
}

- (NSString *)password
{
	return @"";
}

- (BOOL)debugMode
{
	return NO;
}

- (BOOL)parseResult
{
	return YES;
}

- (NSURL *)URL
{
	return [NSURL URLWithString:self.URLString];
}

- (NSString *)URLString
{
	return [self encodeURLString:[NSString stringWithFormat:@"%@%@", self.serverAddress, self.functionPath]];
}

- (NSStringEncoding)dataEncoding
{
	return NSUTF8StringEncoding;
}

- (NSString *)encodeURLString:(NSString *)string
{
	return [string stringByAddingPercentEscapesUsingEncoding:self.dataEncoding];
}

- (void)requestToPostFunctionWithString:(NSString *)post successHandler:(MGServerExchangeDidLoadData)successHandler errorHandler:(MGServerExchangeDidFail)errorHandler
{
	self.errorHandler = errorHandler;
	self.successHandler = successHandler;
	[self requestToPostFunctionWithString:post];
}

- (void)requestToPutFunctionWithString:(NSString *)put successHandler:(MGServerExchangeDidLoadData)successHandler errorHandler:(MGServerExchangeDidFail)errorHandler
{
	self.errorHandler = errorHandler;
	self.successHandler = successHandler;
	[self requestToPutFunctionWithString:put];
}

- (void)requestToGetFunctionWithString:(NSString *)get successHandler:(MGServerExchangeDidLoadData)successHandler errorHandler:(MGServerExchangeDidFail)errorHandler
{
	self.errorHandler = errorHandler;
	self.successHandler = successHandler;
	[self requestToGetFunctionWithString:get];
}

- (void)requestToDeleteFunctionWithSuccessHandler:(MGServerExchangeDidLoadData)successHandler errorHandler:(MGServerExchangeDidFail)errorHandler
{
	self.errorHandler = errorHandler;
	self.successHandler = successHandler;
	[self requestToDeleteFunction];
}

- (void)requestToPostFunctionWithString:(NSString *)post timeoutInterval:(NSTimeInterval)interval
{
	[self requestToPostFunctionWithData:[post dataUsingEncoding:self.dataEncoding allowLossyConversion:YES]];
}

- (void)requestToPostFunctionWithData:(NSData *)data
{
	self.HTTPStatusCode = 0;
	if (![self checkInternetConnection]) return;
	[self cancel];
	[self incrementInternetActivitiesCount];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:self.URL];
	[request setHTTPMethod:@"POST"];
	[self setHeadersForHTTPRequest:request];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) data.length] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:data];
	request.timeoutInterval = 120;
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)requestToPostFunctionWithString:(NSString *)post
{
	[self requestToPostFunctionWithString:post timeoutInterval:120];
}

- (void)requestToPutFunctionWithString:(NSString *)put
{
	[self requestToPutFunctionWithData:[put dataUsingEncoding:self.dataEncoding allowLossyConversion:YES]];
}

- (void)requestToPutFunctionWithData:(NSData *)data
{
	self.HTTPStatusCode = 0;
	if (![self checkInternetConnection]) return;
	[self cancel];
	[self incrementInternetActivitiesCount];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:self.URL];
	[request setHTTPMethod:@"PUT"];
	[self setHeadersForHTTPRequest:request];
	[request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) data.length] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:data];
	request.timeoutInterval = 120;
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)requestToGetFunctionWithString:(NSString *)get
{
	self.HTTPStatusCode = 0;
	if (![self checkInternetConnection]) return;
	[self cancel];
	[self incrementInternetActivitiesCount];
	NSString *fullURL = self.URLString;
	if (get) {
		get = [self encodeURLString:get];
		fullURL = [fullURL stringByAppendingString:get];
	}

	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:fullURL]];
	[request setHTTPMethod:@"GET"];
	[self setHeadersForHTTPRequest:request];
	request.timeoutInterval = 120;
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)requestToDeleteFunction
{
	self.HTTPStatusCode = 0;
	if (![self checkInternetConnection]) return;
	[self cancel];
	[self incrementInternetActivitiesCount];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:self.URL];
	[request setHTTPMethod:@"DELETE"];
	[self setHeadersForHTTPRequest:request];
	request.timeoutInterval = 120;
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

+ (BOOL)isInternetReachable
{
	ATReachability *reachability = [ATReachability reachabilityForInternetConnection];
	if (reachability.currentReachabilityStatus == NotReachable) {
		return NO;
	} else {
		return YES;
	}
}

- (void)setHeadersForHTTPRequest:(NSMutableURLRequest *)request
{
	request.cachePolicy = NSURLCredentialPersistenceNone;
}

- (BOOL)checkInternetConnection
{
	if (![MGServerExchange isInternetReachable]) {
		self.HTTPStatusCode = kMGNoInternetStatusCode;
		[self finishLoadingWithError:kMGNoInternetMessage];
		return NO;
	} else {
		return YES;
	}
}

- (void)incrementInternetActivitiesCount
{
	self.loading = YES;
	if ([[UIApplication sharedApplication].delegate isKindOfClass:[MGAppDelegate class]]) {
		MGAppDelegate *appDelegate = (MGAppDelegate *) [UIApplication sharedApplication].delegate;
		appDelegate.internetActivitiesCount++;
	}
}

- (void)decrementInternetActivitiesCount
{
	if ([[UIApplication sharedApplication].delegate isKindOfClass:[MGAppDelegate class]]) {
		MGAppDelegate *appDelegate = (MGAppDelegate *) [UIApplication sharedApplication].delegate;
		appDelegate.internetActivitiesCount--;
	}
}

- (void)finishLoadingWithError:(NSString *)error
{
	if ([delegate respondsToSelector:@selector(serverExchange:didFailWithError:)]) {
		[delegate serverExchange:self didFailWithError:error];
	}
	
	if (self.errorHandler) {
		self.errorHandler(error);
		self.errorHandler = nil;
	}
}

- (void)finishLoadingWithSuccess
{
	if ([delegate respondsToSelector:@selector(serverExchange:didParseResult:)]) {
		[delegate serverExchange:self didParseResult:result];
	}
	
	if (self.successHandler) {
		self.successHandler(result);
		self.successHandler = nil;
	}
}

- (NSString *)wrongCredentialsMessageText
{
	return NSLocalizedString(@"Incorrect login and password", nil);
}

#pragma mark - Connection delegate

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
			[[challenge sender] cancelAuthenticationChallenge:challenge];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	self.loading = NO;
	[self decrementInternetActivitiesCount];
	if (error.code == kCFURLErrorUserCancelledAuthentication) {
		[self finishLoadingWithError:self.wrongCredentialsMessageText];
	} else {
		[self finishLoadingWithError:error.localizedDescription];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[self decrementInternetActivitiesCount];
	self.loading = NO;
	if (![self parseResponseData]) {
		responseData = [NSMutableData data];
		[self finishLoadingWithError:self.errorDescription];
		return;
	}
	
	if (![self parseResult]) {
		[self finishLoadingWithError:self.errorDescription];
	} else {
		[self finishLoadingWithSuccess];
	}
	responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (!responseData) {
		responseData = [NSMutableData data];
	}
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
}

@end
