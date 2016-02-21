//
//  PDServerUserLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerUserLoader : PDServerExchange
@property (strong, nonatomic) PDUser *userItem;

- (void)loadUser:(PDUser *)user page:(NSInteger)page sorting:(NSInteger)sorting;
@end
