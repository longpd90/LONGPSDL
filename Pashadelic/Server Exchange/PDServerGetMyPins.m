//
//  PDServerProfilePinnedPhotosLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerGetMyPins.h"

@implementation PDServerGetMyPins

- (void)loadPinnedPhotosForProfile:(PDUserProfile *)profile page:(NSInteger)page
{
	self.functionPath = @"profiles/pins.json"; 
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

@end
