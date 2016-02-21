//
//  PDServerNotificationSettings.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 05.01.13.
//
//

#import "PDServerNotificationSettings.h"
#import "PDProfileNotificationsViewController.h"

@implementation PDServerNotificationSettings

- (void)setNotificationsSettings:(BOOL [][2])settings
{
	self.functionPath = [NSString stringWithFormat:@"users/%zd.json", kPDUserID];
	NSString *parameters = [NSString stringWithFormat:
							@"[user][notification_attributes]follow_me=%@"
							"&[user][email_notification_attributes]follow_me=%@"
							"&[user][notification_attributes]pins_my_photo=%@"
							"&[user][email_notification_attributes]pins_my_photo=%@"
							"&[user][notification_attributes]likes_my_photo=%@"
							"&[user][email_notification_attributes]likes_my_photo=%@"
							"&[user][notification_attributes]comments_my_photo=%@"
							"&[user][email_notification_attributes]comments_my_photo=%@",
							settings[kNotificationSectionFollow][0] ? @"true" : @"false",
							settings[kNotificationSectionFollow][1] ? @"true" : @"false",
							settings[kNotificationSectionPin][0] ? @"true" : @"false",
							settings[kNotificationSectionPin][1] ? @"true" : @"false",
							settings[kNotificationSectionLike][0] ? @"true" : @"false",
							settings[kNotificationSectionLike][1] ? @"true" : @"false",
							settings[kNotificationSectionComment][0] ? @"true" : @"false",
							settings[kNotificationSectionComment][1] ? @"true" : @"false", nil];
	
	[self requestToPutFunctionWithString:parameters];
}

- (void)loadNotificationSettings
{
	self.functionPath = [NSString stringWithFormat:@"users/%zd/edit_notifications.json", kPDUserID];
	[self requestToGetFunctionWithString:nil];
}

@end
