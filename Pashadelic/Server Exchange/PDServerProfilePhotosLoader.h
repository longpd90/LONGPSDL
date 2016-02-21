//
//  PDProfilePhotosLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
#import "PDUserProfile.h"

@interface PDServerProfilePhotosLoader : PDServerExchange

- (void)loadPhotosForProfile:(PDUserProfile *)profile page:(NSInteger)page;

@end
