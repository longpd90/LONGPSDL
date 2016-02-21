//
//  PDServerCheckNotificaiton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDServerCheckNotificaiton.h"

@implementation PDServerCheckNotificaiton

- (void)checkNotification:(PDNotificationItem *)item
{
	self.item = item;
	
	if (item.targetType == 1) {
		self.functionPath = [NSString stringWithFormat:@"notifications/%ld.json?photo_id=%zd", (long)item.identifier, item.targetID];
	} else {
		self.functionPath = [NSString stringWithFormat:@"notifications/%ld.json", (long)item.identifier];
	}
		
	[self requestToPutFunctionWithString:nil];
}

@end
