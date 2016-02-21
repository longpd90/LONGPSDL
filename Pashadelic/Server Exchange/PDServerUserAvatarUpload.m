//
//  PDServerUserAvatarUpload.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerUserAvatarUpload.h"
#import "NSData+YBase64String.h"

@implementation PDServerUserAvatarUpload

- (void)uploadAvatar:(UIImage *)image
{
	self.functionPath = [NSString stringWithFormat:@"users/%ld/upload_avatar.json", (long)kPDUserID];
	NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
	NSString *request = [NSString stringWithFormat:@"file=%@", [imageData base64String]];
	[self requestToPostFunctionWithString:request];	
}

@end
