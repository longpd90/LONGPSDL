//
//  PDServerUserPinnedPhotosLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerGetUserPins.h"

@implementation PDServerGetUserPins

- (void)loadPinnedPhotosForUser:(PDUser *)user page:(NSInteger)page sorting:(NSInteger)sorting
{
	self.functionPath = [NSString stringWithFormat:@"users/%ld/pinned_photos.json", (long)user.identifier];
	NSMutableString *request = [NSMutableString stringWithFormat:@"?page=%ld", (long)page];
	
	if (sorting == PDUserPhotosSortTypeByDistance) {
		[request appendFormat:@"&sort=popular"];
	}
	[self requestToGetFunctionWithString:request];
}

@end
