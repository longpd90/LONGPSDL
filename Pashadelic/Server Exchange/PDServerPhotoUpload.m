//
//  PDServerPhotoUpload.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPhotoUpload.h"

@implementation PDServerPhotoUpload

- (void)uploadPhotoWithData:(NSString *)data
{
	self.functionPath = @"photos.json";
	[self requestToPostFunctionWithString:data timeoutInterval:360];
}

- (BOOL)trackUploadDataProgress
{
	return YES;
}

@end
