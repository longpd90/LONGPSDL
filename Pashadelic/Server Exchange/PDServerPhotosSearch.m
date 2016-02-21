//
//  PDServerPhotosSearch.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 17/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerPhotosSearch.h"

@implementation PDServerPhotosSearch

- (void)searchPhotos:(NSString *)text page:(NSInteger)page
{
	self.functionPath = @"search.json";
	NSMutableString *request = [NSMutableString stringWithFormat:@"?query=%@&page=%zd", text, page];
	
	if (kPDSearchDaytime > 0) {
		[request appendFormat:@"&time=%ld", (long)kPDSearchDaytime];
	}
	if (kPDSearchSeasonsEnabled) {
		[request appendFormat:@"&season=%ld", (long)kPDSearchSeason];
	}
	
	[self requestToGetFunctionWithString:request];
}

- (void)searchPhotos:(NSString *)text page:(NSInteger)page latitude:(float)latitude longitude:(float)longitude
{
	self.functionPath = @"search.json";
	NSMutableString *request = [NSMutableString stringWithFormat:@"?query=%@&page=%zd&lat=%f&lon=%f&range=%.1f",
						 text, page, latitude, longitude, kPDSearchRange];
	if (kPDSearchDaytime > 0) {
		[request appendFormat:@"&time=%ld", (long)kPDSearchDaytime];
	}
	if (kPDSearchSeasonsEnabled) {
		[request appendFormat:@"&season=%ld", (long)kPDSearchSeason];
	}

	[self requestToGetFunctionWithString:request];
}

@end
