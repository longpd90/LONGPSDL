//
//  PDCreateLandmark.m
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/7/14.
//
//

#import "PDServerCreateLandmark.h"

@implementation PDServerCreateLandmark
- (void)createLandmark:(PDPOIItem *)landmark
{
    self.functionPath = @"landmarks.json";
    NSString *request = [NSString stringWithFormat:@"[landmarks]name=%@&[landmarks]latitude=%f&[landmarks]longitude=%f", landmark.name, landmark.latitude, landmark.longitude];
    [self requestToPostFunctionWithString:request];
}
@end
