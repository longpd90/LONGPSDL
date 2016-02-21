//
//  PDDeleteDeviceToken.m
//  Pashadelic
//
//  Created by TungNT2 on 11/19/13.
//
//

#import "PDDeleteDeviceToken.h"

@implementation PDDeleteDeviceToken
- (void)deactiveDeviceToken:(NSString *)deviceToken
{
    self.functionPath = [NSString stringWithFormat:@"%@%@/", @"device_tokens/", deviceToken];
    [self requestToDeleteFunction];
}
@end
