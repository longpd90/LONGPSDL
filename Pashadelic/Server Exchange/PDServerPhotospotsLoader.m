//
//  PDServerPhotospotsLoader.m
//  Pashadelic
//
//  Created by LTT on 6/17/14.
//
//

#import "PDServerPhotospotsLoader.h"

@implementation PDServerPhotospotsLoader

- (void)getPhotospotsInLocation:(PDLocation *)location sortType:(NSInteger)sort page:(NSInteger)page
{
    NSString *nameOfType;
    switch (location.locationType) {
        case PDLocationTypeCountry:
            nameOfType = @"countries";
            break;
        case PDLocationTypeState:
            nameOfType = @"states";
            break;
        case PDLocationTypeCity:
            nameOfType = @"cities";
            break;
        case PDLocationTypeLandmark:
            nameOfType = @"landmarks";
            break;
        default:
            break;
    }
    self.functionPath = [NSString stringWithFormat:@"%@/%ld/photos.json",nameOfType,(long)location.identifier];
    NSString *request;
    switch (sort) {
        case 0:
            request = [NSString stringWithFormat:@"?page=%ld", (long)page];
            break;
        case 1:
            request = [NSString stringWithFormat:@"?sort=newest&page=%ld", (long)page];
            break;
        case 2:
            request = [NSString stringWithFormat:@"?sort=next30days&page=%ld", (long)page];
            break;
        default:
            break;
    }
    [self requestToGetFunctionWithString:request];
}

@end
