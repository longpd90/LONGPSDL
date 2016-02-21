//
//  PDServerLogin.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerLoginExchange.h"

@interface PDServerLogin : PDServerLoginExchange

- (void)loginWithUsername:(NSString *)username password:(NSString *)password;

@end
