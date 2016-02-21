//
//  PDServerUserInfoLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 03.02.13.
//
//

#import "PDServerUserInfoLoader.h"

@implementation PDServerUserInfoLoader

- (void)loadUserInfo:(PDUser *)user
{
	self.functionPath = [NSString stringWithFormat:@"users/%zd/show_page.json", user.identifier];
	[self requestToGetFunctionWithString:nil];
}

@end
