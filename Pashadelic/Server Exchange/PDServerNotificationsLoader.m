//
//  PDServerNotificationsLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 20.04.13.
//
//

#import "PDServerNotificationsLoader.h"

@implementation PDServerNotificationsLoader

- (void)loadNotifications:(NSInteger)page
{
	self.functionPath = @"notifications.json";
    NSString *request = [NSString stringWithFormat:@"?page=%ld",(long)page];
	[self requestToGetFunctionWithString:request];
}

@end
