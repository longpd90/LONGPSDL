//
//  PDServerSpotNearbyLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerPhotoNearbyLoader : PDServerExchange

- (void)loadNearbyForPhoto:(PDPhoto *)photo page:(NSInteger)page sorting:(NSInteger)sorting range:(double)range;

@end
