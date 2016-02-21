//
//  PDServerLocationLoader.m
//  Pashadelic
//
//  Created by TungNT2 on 6/18/14.
//
//

#import "PDServerLocationLoader.h"

@implementation PDServerLocationLoader

- (void)loadLocationWithName:(NSString *)name locationID:(NSUInteger)locationID page:(NSUInteger)page
{
    self.functionPath = [NSString stringWithFormat:@"%@/%d.json", name, locationID];
    [self requestToGetFunctionWithString:nil];
}

- (void)loadlandmarkWithId:(NSUInteger)landmarkId
{
    self.functionPath = [NSString stringWithFormat:@"landmarks/%d.json", landmarkId];
    [self requestToGetFunctionWithString:nil];
}

@end
