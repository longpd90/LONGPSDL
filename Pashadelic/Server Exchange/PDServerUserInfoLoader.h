//
//  PDServerUserInfoLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 03.02.13.
//
//

#import "PDServerExchange.h"


@interface PDServerUserInfoLoader : PDServerExchange

- (void)loadUserInfo:(PDUser *)user;

@end
