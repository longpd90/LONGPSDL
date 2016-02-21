//
//  PDLocationInfoLoader.m
//  Pashadelic
//
//  Created by LongPD on 6/18/14.
//
//

#import "PDLocationInfoLoader.h"

@implementation PDLocationInfoLoader

- (void)loadInfoLocation
{
    self.functionPath = @"cities/445/info.json";
	[self requestToGetFunctionWithString:nil];
}

- (void)loadLocationInfoWithName:(NSString *)name locationID:(NSUInteger)locationID
{
    self.functionPath = [NSString stringWithFormat:@"%@/%d/info.json",name,locationID];
    [self requestToGetFunctionWithString:nil];
}

- (void)loadlandmarkWithId:(NSUInteger)landmarkId
{
    self.functionPath = [NSString stringWithFormat:@"landmarks/%d/info.json", landmarkId];
    [self requestToGetFunctionWithString:nil];
}

@end
