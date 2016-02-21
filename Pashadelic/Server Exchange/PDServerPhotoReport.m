//
//  PDServerPhotoReport.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPhotoReport.h"

@implementation PDServerPhotoReport

- (void)reportAboutPhoto:(PDPhoto *)photo reason:(NSInteger)reason
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/report.json?reason=%zd", (long)photo.identifier, reason];
	[self requestToPostFunctionWithString:@""];
}

@end
