//
//  PDServerPhotoLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPhotoLoader.h"

@implementation PDServerPhotoLoader
@synthesize photoItem;

- (void)loadPhotoItem:(PDPhoto *)photo
{
	photoItem = photo;
	self.functionPath = [NSString stringWithFormat:@"photos/%ld.json", (long)photo.identifier];
	[self requestToGetFunctionWithString:nil];
}

- (BOOL)parseResult
{
	NSDictionary *photoData = [self.result valueForKey:@"photo"];
	[photoItem loadFullDataFromDictionary:photoData];
	return YES;
}

@end
