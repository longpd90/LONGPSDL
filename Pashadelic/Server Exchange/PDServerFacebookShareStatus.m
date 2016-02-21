//
//  PDServerFacebookShareStatus.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17/10/12.
//
//

#import "PDServerFacebookShareStatus.h"

@implementation PDServerFacebookShareStatus

- (void)getFacebookShareStatus
{
	self.functionPath = @"facebook/share_status.json";
	[self requestToGetFunctionWithString:@""];
}

@end
