//
//  PDUserProfile.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDUserProfile.h"

@implementation PDUserProfile

- (id)init
{
	self = [super init];
	if (self) {
		self.nearbyPins = [NSMutableArray array];
		self.pins = [NSMutableArray array];
	}
	return self;
}


- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary
{
	[super loadFullDataFromDictionary:dictionary];
	if (!self.photoCollections) {
		self.photoCollections = [NSArray array];
	}
	self.identifier = [dictionary intForKey:@"id"];
	self.name = [dictionary stringForKey:@"username"];
	self.thumbnailURL = [dictionary urlForKey:@"avatar"];
	self.followingsCount = [dictionary intForKey:@"followed_users_count"];
	self.followersCount = [dictionary intForKey:@"followers_count"];
	self.photosCount = [dictionary intForKey:@"photos_count"];
	self.pinsCount = [dictionary intForKey:@"pins_count"];
}

- (void)loadEditInfoFromDictionary:(NSDictionary *)dictionary
{
	self.name = [dictionary stringForKey:@"username"];
	self.firstName = [dictionary stringForKey:@"first_name"];
	self.lastName = [dictionary stringForKey:@"last_name"];
	self.email = [dictionary stringForKey:@"email"];
	self.phone = [dictionary stringForKey:@"phone"];
	self.desc = [dictionary stringForKey:@"description"];
	self.sex = [dictionary intForKey:@"sex"];
	self.countryID = [dictionary intForKey:@"country_id"];
	self.country = [dictionary stringForKey:@"country_name"];
	self.stateID = [dictionary intForKey:@"state_id"];
	self.state = [dictionary stringForKey:@"state_name"];
	self.city = [dictionary stringForKey:@"location"];
	self.interests = [dictionary stringForKey:@"interests"];
	self.level = [dictionary intForKey:@"photo_level"];
}

- (void)setUnreadItemsCount:(NSUInteger)newUnreadItemsCount
{
    _unreadItemsCount = newUnreadItemsCount;
    if (self.unreadItemsCount > MaxThreeDigitsNumber) {
        self.unreadItemsCount = MaxThreeDigitsNumber;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDUnreadItemsCountChangedNotification object:nil];
}

- (void)setPlansUpcomingCount:(NSUInteger)newUnreadItemsCount
{
    _plansUpcomingCount = newUnreadItemsCount;
    if (self.plansUpcomingCount > MaxTwoDigitsNumber) {
        self.plansUpcomingCount = MaxTwoDigitsNumber;
    }
}

@end
