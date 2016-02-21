//
//  PDServerDeactiveAccountFeedback.h
//  Pashadelic
//
//  Created by TungNT2 on 12/24/13.
//
//

#import "PDServerExchange.h"

@interface PDServerDeactiveAccountFeedback : PDServerExchange
- (void)sendDeactiveAccountFeedbackWithBody:(NSString *)body;
@end
