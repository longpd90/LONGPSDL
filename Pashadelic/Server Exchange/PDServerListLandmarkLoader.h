//
//  PDServerListLandmarkLoader.h
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDServerExchange.h"

@interface PDServerListLandmarkLoader : PDServerExchange

- (void)loadLandmarksPage:(NSUInteger)page;
- (void)loadLocationListLandmarkWithName:(NSString *)name locationID:(NSUInteger)locationID withPageIndex:(NSInteger)page;
- (void)loadlandmarkWithId:(NSUInteger)landmarkId withPageIndex:(NSInteger)page;

@end
