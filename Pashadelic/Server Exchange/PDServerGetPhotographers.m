//
//  PDServerPhotographers.m
//  Pashadelic
//
//  Created by LTT on 6/16/14.
//
//

#import "PDServerGetPhotographers.h"

@implementation PDServerGetPhotographers

- (void)getPhotographersInLocation:(PDLocation *)location andPage:(NSInteger)page
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
        self.functionPath = [NSString stringWithFormat:@"%@/%ld/photographers.json",nameOfType,(long)location.identifier];
    NSString *request = [NSString stringWithFormat:@"?page=%d", page];
    [self requestToGetFunctionWithString:request];
}

@end
