//
//  PDServerProfileLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerProfileLoader.h"

@implementation PDServerProfileLoader

- (void)loadUserProfile:(PDUserProfile *)profile
{
	self.functionPath = @"profiles.json";
	[self requestToGetFunctionWithString:nil];
}

- (BOOL)parseResult
{
	NSDictionary *userData = [self.result valueForKey:@"user"];
	[kPDAppDelegate.userProfile loadFullDataFromDictionary:userData];
	return YES;
}


@end
