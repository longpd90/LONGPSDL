//
//  MGServerExchange.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGServerExchangeProtocol.h"

typedef void (^MGServerExchangeDidLoadData)(id result);
typedef void (^MGServerExchangeDidFail)(NSString *error);


#define kMGNoInternetMessage		NSLocalizedString(@"Please check internet connection.", nil)
#define kMGNoInternetStatusCode		-1

@interface MGServerExchange : NSObject
<NSURLConnectionDataDelegate>
{
	NSMutableData *responseData;
}

@property (assign, nonatomic) NSInteger HTTPStatusCode;
@property (assign, nonatomic, getter = isLoading) BOOL loading;
@property (strong, nonatomic) id result;
@property (strong, nonatomic) NSString *errorDescription;
@property (strong, nonatomic) NSString *functionPath;
@property (weak, nonatomic) NSObject <MGServerExchangeDelegate> *delegate;


- (id)initWithDelegate:(id <MGServerExchangeDelegate>)initDelegate;
- (void)finishLoadingWithSuccess;
- (void)finishLoadingWithError:(NSString *)error;

- (BOOL)parseResponseData;
- (BOOL)parseResult;

- (void)incrementInternetActivitiesCount;
- (void)decrementInternetActivitiesCount;

- (void)requestToPostFunctionWithString:(NSString *)post timeoutInterval:(NSTimeInterval)interval;
- (void)requestToPostFunctionWithString:(NSString *)post;
- (void)requestToPostFunctionWithData:(NSData *)data;
- (void)requestToPutFunctionWithString:(NSString *)put;
- (void)requestToPutFunctionWithData:(NSData *)data;
- (void)requestToGetFunctionWithString:(NSString *)get;

- (void)requestToPostFunctionWithString:(NSString *)post successHandler:(MGServerExchangeDidLoadData)successHandler errorHandler:(MGServerExchangeDidFail)errorHandler;
- (void)requestToPutFunctionWithString:(NSString *)put successHandler:(MGServerExchangeDidLoadData)successHandler errorHandler:(MGServerExchangeDidFail)errorHandler;
- (void)requestToGetFunctionWithString:(NSString *)get successHandler:(MGServerExchangeDidLoadData)successHandler errorHandler:(MGServerExchangeDidFail)errorHandler;
- (void)requestToDeleteFunctionWithSuccessHandler:(MGServerExchangeDidLoadData)successHandler errorHandler:(MGServerExchangeDidFail)errorHandler;
- (NSString *)encodeURLString:(NSString *)string;
- (void)setHeadersForHTTPRequest:(NSMutableURLRequest *)request;
- (void)requestToDeleteFunction;
- (void)cancel;

- (NSURL *)URL;
- (NSString *)URLString;
+ (BOOL)isInternetReachable;

- (BOOL)debugMode;
- (NSStringEncoding)dataEncoding;
- (NSString *)login;
- (NSString *)password;
- (NSString *)serverAddress;
- (NSString *)wrongCredentialsMessageText;
- (BOOL)checkInternetConnection;

@end
