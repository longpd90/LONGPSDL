//
//  PDUrbanAirshipExchange.m
//  Pashadelic
//
//  Created by TungNT2 on 11/18/13.
//
//

#import "PDUrbanAirshipExchange.h"

@implementation PDUrbanAirshipExchange

- (NSString *)serverAddress
{
    return kPDUrbanAirshipAddress;
}

- (void)setHeadersForHTTPRequest:(NSMutableURLRequest *)request
{
    [super setHeadersForHTTPRequest:request];
    NSString *credentials = [NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", kPDUrbanAirshipAppKey, kPDUrbanAirshipAppSecret]
                                     dataUsingEncoding:NSUTF8StringEncoding] base64Encoding]];
    [request setValue:credentials forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
}

@end
