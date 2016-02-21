//
//  PDServerSignup.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 17/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerLoginExchange.h"

@interface PDServerSignup : PDServerLoginExchange

- (void)signupWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email;

@end
