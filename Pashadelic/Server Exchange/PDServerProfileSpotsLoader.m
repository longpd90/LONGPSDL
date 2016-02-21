//
//  PDServerProfileSpotsLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerProfileSpotsLoader.h"

@implementation PDServerProfileSpotsLoader

- (void)loadSpotsForProfile:(PDUserProfile *)profile page:(NSInteger)page
{
	self.functionPath = @"profiles/followed_spots.json"; 
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];	
}

@end
