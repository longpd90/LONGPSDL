//
//  PDServerFacebookShareState.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17/10/12.
//
//

#import "PDServerFacebookShareState.h"

@implementation PDServerFacebookShareState

- (void)updateFacebookShareState
{
	self.functionPath = @"facebook/enable_share.json";
	[self requestToPostFunctionWithString:[NSString stringWithFormat:@"fb_access_token=%@", kPDFacebookAccessToken]];

	
}

@end
