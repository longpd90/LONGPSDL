//
//  PDFeedItem.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.11.12.
//
//

#import "PDNotificationItem.h"

@implementation PDNotificationItem

- (void)loadShortDataFromDictionary:(NSDictionary *)dictionary
{
	self.created = [dictionary unixDateForKey:@"created_at"];
	self.text = [dictionary stringForKey:@"text"];
	self.identifier = [dictionary intForKey:@"id"];
	self.targetID = [dictionary intForKey:@"target_id"];
	self.sourceID = [dictionary intForKey:@"source_id"];
	self.targetType = [dictionary intForKey:@"target_type"];
	self.checked = [dictionary boolForKey:@"checked"];
	self.targetIconURL = [dictionary stringForKey:@"target_icon"];
	self.sourceImageURL = [dictionary stringForKey:@"source_image"];
	self.targetImageURL = [dictionary stringForKey:@"target_image"];
	
	NSString *feedType = [dictionary stringForKey:@"feedable_type"];
	if ([feedType isEqualToString:@"Like"]) {
		self.feedType = PDEventTypeLike;
	} else if ([feedType isEqualToString:@"Pin"]) {
		self.feedType = PDEventTypePin;
	} else if ([feedType isEqualToString:@"UserRelation"]) {
		self.feedType = PDEventTypeFollow;
	} else if ([feedType isEqualToString:@"Comment"]) {
		self.feedType = PDEventTypeComment;
	} else if ([feedType isEqualToString:@"Reply"]) {
		self.feedType = PDEventTypeComment;
	} else if ([feedType isEqualToString:@"Upcoming"]) {
		self.feedType = PDEventTypePopular;
	} else if ([feedType isEqualToString:@"Featured"]) {
		self.feedType = PDEventTypeFeature;
	} else if ([feedType isEqualToString:@"Poi"]) {
		self.feedType = PDEventTypePOI;
	} else if ([feedType isEqualToString:@"PlanParticipant"])
        self.feedType = PDEventTypePlan;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, %@", self.text, self.created];
}

- (PDPhoto *)photoItem
{
	if (self.feedType == PDEventTypeFollow || self.feedType == PDEventTypeFeature || self.feedType == PDEventTypePlan) return nil;
	
	if (!_photoItem) {
		_photoItem = [PDPhoto new];
		_photoItem.identifier = self.targetID;
		_photoItem.fullImageURL = [NSURL URLWithString:self.targetImageURL];
	}
	
	return _photoItem;
}

//- (PDPlan *)planItem
//{
//    
//}

@end
