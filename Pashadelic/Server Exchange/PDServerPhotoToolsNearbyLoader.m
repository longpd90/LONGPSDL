//
//  PDServerPhotoToolsNearbyLoader.m
//  Pashadelic
//
//  Created by TungNT2 on 5/11/13.
//
//

#import "PDServerPhotoToolsNearbyLoader.h"

@implementation PDServerPhotoToolsNearbyLoader

- (void)loadNearbySorting:(NSInteger)sorting range:(double)range longitude:(float)longitude latitude:(float)latitude
{
	if (latitude == 0 && longitude == 0) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(serverExchange:didFailWithError:)]) {
            [self.delegate serverExchange:self didFailWithError:NSLocalizedString(@"Cannot determinate location, please try again later" , nil)];
        }
		return;
	}
	self.functionPath = @"nearby.json";
    
	NSMutableString *request = [NSMutableString stringWithFormat:
								@"?lon=%f&lat=%f&range=%f",
								longitude, latitude, range];
	if (kPDPhotoToolsNearbyDateFrom > 0) {
		[request appendFormat:@"&date_from=%zd", kPDPhotoToolsNearbyDateFrom];
	}
	if (kPDPhotoToolsNearbyDateTo > 0) {
		[request appendFormat:@"&date_to=%zd", kPDPhotoToolsNearbyDateTo];
	}
	if (kPDPhotoToolsNearbyTimeFrom > 0) {
		[request appendFormat:@"&time_from=%zd", kPDPhotoToolsNearbyTimeFrom];
	}
	if (kPDPhotoToolsNearbyTimeTo > 0) {
		[request appendFormat:@"&time_to=%zd", kPDPhotoToolsNearbyTimeTo];
	}
    
	if (sorting == PDNearbySortTypeByPopularity) {
		[request appendFormat:@"&sort=popular"];
	} else {
		[request appendFormat:@"&sort=date"];
	}
	
	[self requestToGetFunctionWithString:request];
}
@end
