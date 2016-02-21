//
//  PDComment.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDComment.h"

@implementation PDComment

- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary
{
	self.comment = [dictionary stringForKey:@"comment"];
	self.date = [NSDate dateWithTimeIntervalSince1970:[dictionary intForKey:@"created_at"]];
	self.identifier = [dictionary intForKey:@"id"];
	self.user = [[PDUser alloc] init];
	[self.user loadShortDataFromDictionary:dictionary];
	self.user.identifier = [dictionary intForKey:@"user_id"];
    self.replyToID = [dictionary intForKey:@"reply_to_id"];
}

- (void)setItemDelegate:(id<PDItemSelectDelegate>)itemDelegate
{
	[super setItemDelegate:itemDelegate];
	[self.user setItemDelegate:itemDelegate];
	[self.photo setItemDelegate:itemDelegate];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ - %@", self.user, self.comment];
}

@end
