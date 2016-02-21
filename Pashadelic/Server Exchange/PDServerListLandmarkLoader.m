//
//  PDServerListLandmarkLoader.m
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDServerListLandmarkLoader.h"

@implementation PDServerListLandmarkLoader

- (void)loadLandmarksPage:(NSUInteger)page
{
    self.functionPath = @"landmarks.json";
	[self requestToGetFunctionWithString:nil];
}

- (void)loadLocationListLandmarkWithName:(NSString *)name locationID:(NSUInteger)locationID withPageIndex:(NSInteger)page
{
    self.functionPath = [NSString stringWithFormat:@"%@/%d/landmarks.json",name,locationID];
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];

}

- (void)loadlandmarkWithId:(NSUInteger)landmarkId withPageIndex:(NSInteger)page
{
    self.functionPath = [NSString stringWithFormat:@"landmarks/%d/landmarks.json", landmarkId];
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

@end
