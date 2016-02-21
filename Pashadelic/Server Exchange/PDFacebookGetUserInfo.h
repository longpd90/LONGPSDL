//
//  PDFacebookGetUserInfo.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 5/11/12.
//
//

#import "PDFacebookExchange.h"

#define kPDFacebookGetInfoErrorNoInfo		@"Not enought info in Facebook response"

@interface PDFacebookGetUserInfo : PDFacebookExchange

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *username;

- (void)getUserInfo;

@end
