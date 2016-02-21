//
//  PDServerLandmarkLoader.h
//  Pashadelic
//
//  Created by TungNT2 on 7/23/13.
//
//

#import "PDServerExchange.h"

@interface PDServerLandmarkLoader : PDServerExchange

- (void)loadLandmarkWithLongitude:(double)longitude latitude:(double)latitude range:(float)range page:(NSInteger)page;

@end
