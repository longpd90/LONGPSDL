//
//  PDDeleteAccount.h
//  Pashadelic
//
//  Created by LongPD on 12/20/13.
//
//

#import "PDServerExchange.h"

@interface PDServerDeleteAccount : PDServerExchange
- (void)deleteAccountWithId:(NSInteger)userId;
@end
