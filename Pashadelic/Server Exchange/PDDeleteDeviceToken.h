//
//  PDDeleteDeviceToken.h
//  Pashadelic
//
//  Created by TungNT2 on 11/19/13.
//
//

#import "PDUrbanAirshipExchange.h"

@interface PDDeleteDeviceToken : PDUrbanAirshipExchange
- (void)deactiveDeviceToken:(NSString *)deviceToken;
@end
