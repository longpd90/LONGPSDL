//
//  PDServerCommentsLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 30/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerCommentsLoader.h"

@implementation PDServerCommentsLoader

- (void)loadCommentsForPhoto:(PDPhoto *)photo page:(NSUInteger)page
{
	self.functionPath = [NSString stringWithFormat:@"photos/%zd/comments.json?page=%lu", photo.identifier, (unsigned long)page];
	[self requestToGetFunctionWithString:@""];
}

- (void)loadcommentsForPlan:(PDPlan *)plan page:(NSUInteger)page
{
    self.functionPath = [NSString stringWithFormat:@"plans/%zd/comments.json?page=%lu",plan.identifier, (unsigned long)page];
    [self requestToGetFunctionWithString:nil];
}

@end
