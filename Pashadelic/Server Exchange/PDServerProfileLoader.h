//
//  PDServerProfileLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
#import "PDUserProfile.h"

@interface PDServerProfileLoader : PDServerExchange

- (void)loadUserProfile:(PDUserProfile *)profile;

@end