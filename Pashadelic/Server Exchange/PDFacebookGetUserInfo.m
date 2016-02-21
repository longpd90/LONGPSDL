//
//  PDFacebookGetUserInfo.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 5/11/12.
//
//

#import "PDFacebookGetUserInfo.h"

@implementation PDFacebookGetUserInfo

- (void)getUserInfo
{
	[self loginForReadInfo];
}

- (void)action
{
	[FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
		[self handleFacebookResponce:result error:error];
	}];
}

@end
