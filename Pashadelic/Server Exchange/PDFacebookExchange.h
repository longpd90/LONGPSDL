//
//  PDServerFacebook.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 3/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
#import <Facebook.h>

@class PDFacebookExchange;

@protocol PDFacebookExchangeDelegate <NSObject>
- (void)facebookDidFinish:(PDFacebookExchange *)facebookExchange withResult:(id)result;
- (void)facebookDidFail:(PDFacebookExchange *)facebookExchange withError:(NSString *)error;
@end

@interface PDFacebookExchange : NSObject

@property (strong, nonatomic) NSString *errorDescription;
@property (strong, nonatomic) NSDictionary *parameters;
@property (weak, nonatomic) id<PDFacebookExchangeDelegate> delegate;

- (id)initWithDelegate:(id<PDFacebookExchangeDelegate>) delegate;
- (void)handleFacebookResponce:(id)result error:(NSError *)error;
- (void)handleFacebookAuthentification:(FBSession *)session error:(NSError *)error;
- (BOOL)checkForPermissions:(NSArray *)permissions;
- (void)action;
- (void)loginForPublish;
- (void)loginForReadInfo;
- (void)loginForReadFriendsList;
- (BOOL)parseResult:(id)result;
- (void)failWithError:(NSString *)error;
+ (void)logout;

@end
