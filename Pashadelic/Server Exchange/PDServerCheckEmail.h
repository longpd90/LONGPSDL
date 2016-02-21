//
//  PDServerCheckEmail.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 05.02.13.
//
//

#import "PDServerExchange.h"

@interface PDServerCheckEmail : PDServerExchange

- (void)checkEmail:(NSString *)email;

@end
