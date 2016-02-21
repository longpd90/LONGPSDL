//
//  PDServerProfileUsersLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
#import "PDUserProfile.h"

@interface PDServerProfileUsersLoader : PDServerExchange

- (void)loadUsersForProfile:(PDUserProfile *)profile page:(NSInteger)page usersType:(NSString *)usersType;

@end
