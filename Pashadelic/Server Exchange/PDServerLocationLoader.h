//
//  PDServerLocationLoader.h
//  Pashadelic
//
//  Created by TungNT2 on 6/18/14.
//
//

#import "PDServerExchange.h"

@interface PDServerLocationLoader : PDServerExchange
- (void)loadLocationWithName:(NSString *)name locationID:(NSUInteger)locationID page:(NSUInteger)page;
- (void)loadlandmarkWithId:(NSUInteger)landmarkId;
@end
