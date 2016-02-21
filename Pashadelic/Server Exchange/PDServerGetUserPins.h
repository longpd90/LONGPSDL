//
//  PDServerUserPinnedPhotosLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"


@interface PDServerGetUserPins : PDServerExchange

- (void)loadPinnedPhotosForUser:(PDUser *)user page:(NSInteger)page sorting:(NSInteger)sorting;

@end
