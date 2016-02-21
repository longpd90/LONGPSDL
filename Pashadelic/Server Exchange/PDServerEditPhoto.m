//
//  PDServerEditPhoto.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 3/10/12.
//
//

#import "PDServerEditPhoto.h"
#import "PDPOIItem.h"

@implementation PDServerEditPhoto

- (void)uploadPhotoData:(PDPhoto *)photo title:(NSString *)title description:(NSString *)description tags:(NSString *)tags
{
	self.functionPath = [NSString stringWithFormat:@"/photos/%zd.json", photo.identifier];
	NSMutableString *parameters = [NSMutableString stringWithFormat:@"[photo]title=%@&[photo]description=%@&[photo]tag_list=%@&photo[poi_id]=%zd&[photo]longitude=%f&[photo]latitude=%f",
							[title urlEncodeUsingEncoding:self.dataEncoding],
							[description urlEncodeUsingEncoding:self.dataEncoding],
							[tags urlEncodeUsingEncoding:self.dataEncoding],
                            photo.poiItem.identifier,
                            photo.longitude,
                            photo.latitude];
    if (photo.tripod != kPDNoTip)
        [parameters appendFormat:@"&photo[tripod]=%ld", (long)photo.tripod];
    
    if (photo.is_crowded != kPDNoTip)
        [parameters appendFormat:@"&photo[is_crowded]=%ld", (long)photo.is_crowded];
    
	if (photo.is_parking != kPDNoTip)
        [parameters appendFormat:@"&photo[is_parking]=%ld", (long)photo.is_parking];
    
    if (photo.is_dangerous != kPDNoTip)
        [parameters appendFormat:@"&photo[is_dangerous]=%ld", (long)photo.is_dangerous];
    
    if (photo.indoor != kPDNoTip)
        [parameters appendFormat:@"&photo[indoor]=%ld", (long)photo.indoor];
    
    if (photo.is_permission != kPDNoTip)
        [parameters appendFormat:@"&photo[is_permission]=%ld", (long)photo.is_permission];
    
    if (photo.is_paid != kPDNoTip)
        [parameters appendFormat:@"&photo[is_paid]=%ld", (long)photo.is_paid];
    
    if (photo.difficulty_access != 0)
        [parameters appendFormat:@"&photo[difficulty]=%ld", (long)photo.difficulty_access];
    
	[self requestToPutFunctionWithString:parameters];
}

@end
