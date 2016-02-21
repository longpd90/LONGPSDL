//
//  PDRegisterDeviceToken.h
//  Pashadelic
//
//  Created by TungNT2 on 11/18/13.
//
//

#import "PDUrbanAirshipExchange.h"

@interface PDRegisterDeviceToken : PDUrbanAirshipExchange
- (void)registerDeviceToken:(NSString *)deviceToken;
- (void)registerDeviceToken:(NSString *)deviceToken WithAlias:(NSString *)alias andTags:(NSArray *)tags;
@end
