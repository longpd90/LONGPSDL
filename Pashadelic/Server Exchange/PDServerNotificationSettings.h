//
//  PDServerNotificationSettings.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 05.01.13.
//
//

#import "PDServerExchange.h"

@interface PDServerNotificationSettings : PDServerExchange

- (void)setNotificationsSettings:(BOOL [][2])settings;
- (void)loadNotificationSettings;

@end
