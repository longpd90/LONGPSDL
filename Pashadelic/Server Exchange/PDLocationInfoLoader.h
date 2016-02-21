//
//  PDLocationInfoLoader.h
//  Pashadelic
//
//  Created by LongPD on 6/18/14.
//
//

#import "PDServerExchange.h"

@interface PDLocationInfoLoader : PDServerExchange

- (void)loadInfoLocation;
- (void)loadLocationInfoWithName:(NSString *)name locationID:(NSUInteger)locationID;
- (void)loadlandmarkWithId:(NSUInteger)landmarkId;

@end
