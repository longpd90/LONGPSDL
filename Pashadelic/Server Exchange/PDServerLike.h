//
//  PDServerLike.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
@class PDPhoto;

@interface PDServerLike : PDServerExchange

- (void)likePhoto:(PDPhoto *)photo;
- (void)unlikePhoto:(PDPhoto *)photo;

@end
