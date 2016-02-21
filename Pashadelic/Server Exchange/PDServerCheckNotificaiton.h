//
//  PDServerCheckNotificaiton.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDServerExchange.h"
#import "PDNotificationItem.h"

@interface PDServerCheckNotificaiton : PDServerExchange
@property (strong, nonatomic) PDNotificationItem *item;

- (void)checkNotification:(PDNotificationItem *)item;

@end
