//
//  PDServerSpotReviewsLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerPhotosReviewsLoader : PDServerExchange

- (void)loadReviewsForPhoto:(PDPhoto *)photo;
						

@end
