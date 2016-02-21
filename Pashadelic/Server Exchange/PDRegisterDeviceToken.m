//
//  PDRegisterDeviceToken.m
//  Pashadelic
//
//  Created by TungNT2 on 11/18/13.
//
//

#import "PDRegisterDeviceToken.h"

@implementation PDRegisterDeviceToken

- (void)registerDeviceToken:(NSString *)deviceToken
{
    self.functionPath = [NSString stringWithFormat:@"%@%@/", @"device_tokens/", deviceToken];
    [self requestToPutFunctionWithString:nil];
}

- (void)registerDeviceToken:(NSString *)deviceToken WithAlias:(NSString *)alias andTags:(NSArray *)tags
{
    self.functionPath = [NSString stringWithFormat:@"%@%@/", @"device_tokens/", deviceToken];
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithCapacity:2];
    if (alias != nil && alias.length != 0) {
        [jsonDict setObject:alias forKey:@"alias"];
    }
    if (tags != nil && tags.count != 0) {
        [jsonDict setObject:tags forKey:@"tags"];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonDict) {
        NSLog(@"Got error convert dictionary to json object: %@", error);
        [self requestToPutFunctionWithString:nil];
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self requestToPutFunctionWithString:jsonString];
    }
}

@end
