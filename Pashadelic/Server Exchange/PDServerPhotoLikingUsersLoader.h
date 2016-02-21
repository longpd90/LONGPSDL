//
//  PDServerPhotoLikingUsersLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerPhotoLikingUsersLoader : PDServerExchange

- (void)loadLikingUsersForPhoto:(PDPhoto *)photo page:(NSInteger)page;

@end
