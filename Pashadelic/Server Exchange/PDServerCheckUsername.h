//
//  PDServerCheckUsername.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"

@interface PDServerCheckUsername : PDServerExchange

- (void)checkUsername:(NSString *)username;

@end
