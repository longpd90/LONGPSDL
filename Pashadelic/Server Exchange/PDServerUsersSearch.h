//
//  PDServerUsersSearch.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 17/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"

@interface PDServerUsersSearch : PDServerExchange

- (void)searchUsers:(NSString *)text page:(NSInteger)page;

@end
