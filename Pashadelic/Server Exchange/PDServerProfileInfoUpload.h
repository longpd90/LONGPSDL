//
//  PDServerProfileInfoUpload.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 16/10/12.
//
//

#import "PDServerExchange.h"

@interface PDServerProfileInfoUpload : PDServerExchange

- (void)uploadProfileInfo:(PDUserProfile *)profile;

@end
