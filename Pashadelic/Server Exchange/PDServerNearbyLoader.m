//
//  PDServerNearbyLoader.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerNearbyLoader.h"
#import "PDLocationHelper.h"

@interface PDServerNearbyLoader ()
- (NSMutableString *)appendFilterDataFromRequest:(NSMutableString *)request;
@end
@implementation PDServerNearbyLoader

- (BOOL)isValidLocationWithLatitude:(double)latitude longitude:(double)longitude
{
	if (latitude == 0 && longitude == 0) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(serverExchange:didFailWithError:)]) {
            [self.delegate serverExchange:self didFailWithError:NSLocalizedString(@"Cannot determinate location, please try again later" , nil)];
        }
		return NO;
	} else
        return YES;
}

- (void)loadNearbyPage:(NSInteger)pageNumber sorting:(NSInteger)sorting range:(double)range
{
    double latitude = [[PDLocationHelper sharedInstance] latitudes];
	double longitude = [[PDLocationHelper sharedInstance] longitudes];
    
    if (![self isValidLocationWithLatitude:latitude longitude:longitude]) return;
    [kPDUserDefaults setObject:[[PDLocationHelper sharedInstance] latitudeStringValue]
                        forKey:kPDUserLocationLatitudeKey];
    [kPDUserDefaults setObject:[[PDLocationHelper sharedInstance] longitudeStringValue]
                        forKey:kPDUserLocationLongitudeKey];
	self.functionPath = @"nearby.json";
	
	
	NSMutableString *request = [NSMutableString stringWithFormat:
								@"?lon=%f&lat=%f&range=%f&page=%ld",
								longitude, latitude, range, (long)pageNumber];
	if (kPDNearbyDaytime > 0) {
		[request appendFormat:@"&time=%ld", (long)kPDNearbyDaytime];
	}
	if (kPDNearbySeasonsEnabled) {
		[request appendFormat:@"&season=%ld", (long)kPDNearbySeason];
	}
	
	if (sorting == PDNearbySortTypeByPopularity) {
		[request appendFormat:@"&sort=popular"];
	} else {
		[request appendFormat:@"&sort=date"];
	}
	
	[self requestToGetFunctionWithString:request];
}

- (NSMutableString *)appendFilterDataFromRequest:(NSMutableString *)request
{
    NSMutableString *appendedRequest = request;
    
    if (kPDFilterNearbyRange > 0) {
        [appendedRequest appendFormat:@"&range=%f", kPDFilterNearbyRange];
    }
    if (kPDFilterNearbyDateFrom > 0) {
		[appendedRequest appendFormat:@"&date_from=%ld", (long)kPDFilterNearbyDateFrom];
	}
	if (kPDFilterNearbyDateTo > 0) {
		[appendedRequest appendFormat:@"&date_to=%ld", (long)kPDFilterNearbyDateTo];
	}
	if (kPDFilterNearbyTimeFrom > 0) {
		[appendedRequest appendFormat:@"&time_from=%ld", (long)kPDFilterNearbyTimeFrom];
	}
	if (kPDFilterNearbyTimeTo > 0) {
		[appendedRequest appendFormat:@"&time_to=%ld", (long)kPDFilterNearbyTimeTo];
	}
    
    if (kPDFilterNearbySortType == PDNearbySortTypeByPopularity) {
		[appendedRequest appendFormat:@"&sort=popular"];
	} else if (kPDFilterNearbySortType == PDNearbySortTypeByDate) {
		[appendedRequest appendFormat:@"&sort=date"];
	} else if (kPDFilterNearbySortType == PDNearbySortTypeByDistance) {
        [appendedRequest appendFormat:@"&sort=distance"];
    } else {
        [appendedRequest appendFormat:@"&sort=date"];
    }
    return appendedRequest;
}

- (void)loadNearbyPhotos:(NSString *)text pageNumber:(NSInteger)pageNumber longitude:(double)longitude latitude:(double)latitude
{
    if (![self isValidLocationWithLatitude:latitude longitude:longitude]) return;
    
    self.functionPath = @"nearby.json";
    NSMutableString *request = [NSMutableString stringWithFormat:@"?page=%ld", (long)pageNumber];
  
	if (text && text.length > 0) {
        [request appendFormat:@"&query=%@", text];
    }
    if (!latitude == 0 && !longitude == 0) {
		[request appendFormat:@"&lon=%f&lat=%f", longitude, latitude];
	}
    request = [self appendFilterDataFromRequest:request];
    
	[self requestToGetFunctionWithString:request];
}

- (void)loadNearbyPhotosForMap:(NSString *)text pageNumber:(NSInteger)pageNumber longitude:(double)longitude latitude:(double)latitude
{
    if (![self isValidLocationWithLatitude:latitude longitude:longitude]) return;
    
    self.functionPath = @"nearby.json";
    
    NSMutableString *request = [NSMutableString stringWithFormat:@"?page=%ld", (long)pageNumber];
    
    if (text && text.length > 0) {
        [request appendFormat:@"&query=%@", text];
    }
    if (!latitude == 0 && !longitude == 0) {
		[request appendFormat:@"&lon=%f&lat=%f", longitude, latitude];
	}
    request = [self appendFilterDataFromRequest:request];
    [request appendFormat:@"&per=500"];
    
	[self requestToGetFunctionWithString:request];
}

@end
