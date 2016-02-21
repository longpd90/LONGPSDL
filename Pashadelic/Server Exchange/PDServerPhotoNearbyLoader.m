//
//  PDServerSpotNearbyLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPhotoNearbyLoader.h"

@implementation PDServerPhotoNearbyLoader

- (void)loadNearbyForPhoto:(PDPhoto *)photo page:(NSInteger)page sorting:(NSInteger)sorting range:(double)range
{
	self.functionPath = @"nearby.json";
	NSMutableString *request = [NSMutableString stringWithFormat:@"?lon=%f&lat=%f&range=%f&page=%ld",
								photo.longitude,
								photo.latitude,
								range,
								(long)page];
	
//	if (sorting == PDNearbySortTypeByPopularity) {
//		[request appendFormat:@"&sort=popular"];
//	} else {
    [request appendFormat:@"&sort=date"];
//	}
	
	[self requestToGetFunctionWithString:request];
}

@end
