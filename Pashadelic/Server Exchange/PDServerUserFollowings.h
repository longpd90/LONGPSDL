//
//  PDServerUserFollowings.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.04.13.
//
//

#import "PDServerExchange.h"



@interface PDServerUserFollowings : PDServerExchange

- (void)loadUserFollowings:(PDUser *)user page:(NSInteger)page;

@end
