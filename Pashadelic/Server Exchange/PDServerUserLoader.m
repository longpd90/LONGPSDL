//
//  PDServerUserLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerUserLoader.h"

@implementation PDServerUserLoader
@synthesize userItem;

- (void)loadUser:(PDUser *)user page:(NSInteger)page sorting:(NSInteger)sorting
{
	userItem = user;
	self.functionPath = @"users";
	NSMutableString *request = [NSMutableString stringWithFormat:@"/%ld.json?page=%ld", (long)user.identifier, (long)page];
	if (sorting == PDUserPhotosSortTypeByDistance) {
		[request appendFormat:@"&sort=popular"];
	}

	[self requestToGetFunctionWithString:request];
}

- (BOOL)parseResult
{
	NSDictionary *userData = [self.result valueForKey:@"user"];
	[userItem loadFullDataFromDictionary:userData];
	return YES;
}

@end
