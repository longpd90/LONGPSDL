//
//  PDServerPhotoToolsNearbyLoader.h
//  Pashadelic
//
//  Created by TungNT2 on 5/11/13.
//
//

#import "PDServerExchange.h"

@interface PDServerPhotoToolsNearbyLoader : PDServerExchange
- (void)loadNearbySorting:(NSInteger)sorting range:(double)range longitude:(float)longitude latitude:(float)latitude;
@end
