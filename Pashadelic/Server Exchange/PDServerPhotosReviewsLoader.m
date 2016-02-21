//
//  PDServerSpotReviewsLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPhotosReviewsLoader.h"

@implementation PDServerPhotosReviewsLoader

- (void)loadReviewsForPhoto:(PDPhoto *)photo
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/reviews.json", (long)photo.identifier];
	[self requestToGetFunctionWithString:@""];
}

@end
