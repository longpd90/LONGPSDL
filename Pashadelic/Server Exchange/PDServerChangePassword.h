//
//  PDServerChangePassword.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 10.12.12.
//
//

#import "PDServerExchange.h"

@interface PDServerChangePassword : PDServerExchange

- (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;

@end
