//
//  PDProfilePhotosLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerProfilePhotosLoader.h"

@implementation PDServerProfilePhotosLoader

- (void)loadPhotosForProfile:(PDUserProfile *)profile page:(NSInteger)page
{
	self.functionPath = @"profiles/photos.json"; 
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

@end
