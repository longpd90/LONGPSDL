//
//  PDServerEnableShare.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 24.11.12.
//
//

#import "PDServerEnableShare.h"

@implementation PDServerEnableShare

- (void)enableFacebookShare
{
	self.functionPath = @"/facebook/enable_share.json";
	[self requestToPostFunctionWithString:[NSString stringWithFormat:@"fb_access_token=%@", kPDFacebookAccessToken]];
}

@end
