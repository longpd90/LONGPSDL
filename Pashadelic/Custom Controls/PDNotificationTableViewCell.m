//
//  PDFeedTableViewCell.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.11.12.
//
//

#import "PDNotificationTableViewCell.h"

@implementation PDNotificationTableViewCell

- (void)setNotificationItem:(PDNotificationItem *)notificationItem
{
	[self.sourceButton setImage:nil forState:UIControlStateNormal];
	[self.targetButton setImage:nil forState:UIControlStateNormal];
	self.targetIconImageView.image = nil;
	
	_notificationItem = notificationItem;
	
	[self.sourceButton sd_setImageWithURL:[NSURL URLWithString:notificationItem.sourceImageURL] forState:UIControlStateNormal];
	[self.self.targetButton sd_setImageWithURL:[NSURL URLWithString:notificationItem.targetImageURL] forState:UIControlStateNormal];
	[self.targetIconImageView sd_setImageWithURL:[NSURL URLWithString:notificationItem.targetIconURL]];
	self.sourceButton.enabled = (self.notificationItem.sourceID != 0);
	self.targetButton.enabled = (self.notificationItem.targetID != 0);
	
	if (notificationItem.checked) {
		[(UIImageView *) self.backgroundView setImage:[UIImage imageNamed:@"bg_notification_checked.png"]];
	} else {
		[(UIImageView *) self.backgroundView setImage:[UIImage imageNamed:@"bg_notification.png"]];
	}
	self.notificationLabel.text = notificationItem.text;
}

- (void)showSource:(id)sender
{
	if (self.notificationItem.feedType == PDEventTypePOI) {
		self.photo = [[PDPhoto alloc] init];
		self.photo.identifier = self.notificationItem.sourceID;
		if (self.delegate && [self.delegate respondsToSelector:@selector(photo:didSelectInView:image:)]) {
            [self.delegate photo:self.photo didSelectInView:self.targetButton image:[self.targetButton imageForState:UIControlStateNormal]];
        }
		return;
	}
	
	if (self.notificationItem.feedType == PDEventTypeComment ||
			self.notificationItem.feedType == PDEventTypeReply ||
			self.notificationItem.feedType == PDEventTypeFollow ||
			self.notificationItem.feedType == PDEventTypeLike ||
			self.notificationItem.feedType == PDEventTypePin) {
		if (self.notificationItem.sourceID == 0) return;
		self.user = [[PDUser alloc] init];
		self.user.identifier = self.notificationItem.sourceID;
		self.user.itemDelegate = self.notificationItem.itemDelegate;
		[self.user itemWasSelected];
		
	} else {
		if (self.notificationItem.targetID == 0) return;
		self.photo = [[PDPhoto alloc] init];
		self.photo.identifier = self.notificationItem.targetID;
		if (self.delegate && [self.delegate respondsToSelector:@selector(photo:didSelectInView:image:)]) {
            [self.delegate photo:self.photo didSelectInView:self.targetButton image:[self.targetButton imageForState:UIControlStateNormal]];
        }
	}
}

- (void)showTarget:(id)sender
{
	if (self.notificationItem.feedType == PDEventTypeFollow || self.notificationItem.feedType == PDEventTypePOI) {
		[self showSource:nil];
		
	} else if (self.notificationItem.targetType != 6) {
		if (self.notificationItem.targetID == 0) return;
		self.photo = [[PDPhoto alloc] init];
		self.photo.identifier = self.notificationItem.targetID;
		if (self.delegate && [self.delegate respondsToSelector:@selector(photo:didSelectInView:image:)]) {
            [self.delegate photo:self.photo didSelectInView:self.targetButton image:[self.targetButton imageForState:UIControlStateNormal]];
        }
		
	} else {
        PDPlan *plan = [[PDPlan alloc] init];
        plan.identifier = self.notificationItem.targetID;
        if (self.planDelegate && [self.planDelegate respondsToSelector:@selector(showPlan:)]) {
            [self.planDelegate showPlan:plan];
        }
    }
	if (!serverExchange) {
		serverExchange = [[PDServerCheckNotificaiton alloc] initWithDelegate:self];
	}
	[serverExchange checkNotification:self.notificationItem];
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
}

@end
