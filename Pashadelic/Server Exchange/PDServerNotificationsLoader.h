//
//  PDServerNotificationsLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 20.04.13.
//
//

#import "PDServerExchange.h"

@interface PDServerNotificationsLoader : PDServerExchange

- (void)loadNotifications:(NSInteger)page;

@end
