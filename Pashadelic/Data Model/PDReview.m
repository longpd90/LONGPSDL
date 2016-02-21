//
//  PDReview.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDReview.h"

@implementation PDReview

- (void)loadFromDictionary:(NSDictionary *)dictionary
{
	self.thumbnailURL = [dictionary urlForKey:@"avatar"];
	self.userID = [dictionary intForKey:@"user_id"];
	self.identifier = [dictionary intForKey:@"id"];
	self.username = [dictionary stringForKey:@"username"];
	self.text = [dictionary stringForKey:@"description"];
	self.date = [dictionary unixDateForKey:@"created_at"];
	self.rating = [dictionary intForKey:@"stars"];
}

- (void)itemWasSelected
{
	if ([self.itemDelegate respondsToSelector:@selector(itemDidSelect:)]) {
		PDUser *user = [[PDUser alloc] init];
		user.identifier = self.userID;
		[self.itemDelegate itemDidSelect:user];
	}

}

- (NSString *)followItemName
{
	return [NSString stringWithFormat:@"gtags/%zd/follow_unfollow.json", self.identifier];
}

@end
