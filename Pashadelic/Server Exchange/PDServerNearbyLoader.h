//
//  PDServerNearbyLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"

@interface PDServerNearbyLoader : PDServerExchange

- (void)loadNearbyPage:(NSInteger)pageNumber sorting:(NSInteger)sorting range:(double)range;
- (void)loadNearbyPhotos:(NSString *)text
              pageNumber:(NSInteger)pageNumber
               longitude:(double)longitude
                latitude:(double)latitude;
- (void)loadNearbyPhotosForMap:(NSString *)text
                    pageNumber:(NSInteger)pageNumber
                     longitude:(double)longitude
                      latitude:(double)latitude;


@end
