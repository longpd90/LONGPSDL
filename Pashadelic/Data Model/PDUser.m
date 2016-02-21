//
//  PDPeople.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface PDUser ()
- (void)loadSlidesFromDictionary:(NSDictionary *)dictionary;
@end

@implementation PDUser

- (void)loadShortDataFromDictionary:(NSDictionary *)dictionary
{
	self.identifier = [dictionary intForKey:@"id"];
	self.thumbnailURL = [dictionary urlForKey:@"avatar_url"];
	self.name = [dictionary stringForKey:@"username"];
	self.followStatus = [dictionary boolForKey:@"follow_status"];
	self.location = [dictionary stringForKey:@"location"];
	self.userPhotoThumbnails = [dictionary objectForKey:@"photos"];
}

- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary
{
	if (self.identifier == 0) {
		self.identifier = [dictionary intForKey:@"id"];
	}
	
	self.followingsCount = [dictionary intForKey:@"followings_count"];
	self.fullImageURL = [dictionary urlForKey:@"avatar"];
	self.followersCount = [dictionary intForKey:@"followers_count"];
	self.location = [dictionary stringForKey:@"location"];
	self.address = [dictionary stringForKey:@"address"];
	self.interests = [dictionary stringForKey:@"interests"];
	self.details = [dictionary stringForKey:@"description"];
	self.photoLevel = [dictionary stringForKey:@"photo_level"];
	self.name = [dictionary stringForKey:@"username"];
	self.fullName = [dictionary stringForKey:@"full_name"];
	self.thumbnailURL = [dictionary urlForKey:@"avatar"];
	self.photosCount = [dictionary intForKey:@"photos_count"];
	self.pinsCount = [dictionary intForKey:@"pins_count"];
	self.followersCount = [dictionary intForKey:@"followers_count"];
	self.followStatus = [dictionary boolForKey:@"follow_status"];
	self.photoSpotButtonImageURL = [dictionary urlForKey:@"btn_photo_spot"];
	self.pinsButtonImageURL = [dictionary urlForKey:@"btn_pin"];
	self.followersButtonImageURL = [dictionary urlForKey:@"btn_follower"];
	self.followingsButtonImageURL = [dictionary urlForKey:@"btn_following"];
	[self loadSlidesFromDictionary:dictionary];
    
    NSArray *photosInfo = dictionary[@"photos"];
	NSMutableArray *arrayPhotos = [NSMutableArray arrayWithCapacity:photosInfo.count];
	for (NSDictionary *photoInfo in photosInfo) {
		PDPhoto *photo = [[PDPhoto alloc] init];
		[photo loadShortDataFromDictionary:photoInfo];
		[arrayPhotos addObject:photo];
	}
	self.photos = arrayPhotos;
    
}

- (void)loadSlidesFromDictionary:(NSDictionary *)dictionary
{
	NSArray *slides = [dictionary objectForKey:@"slides"];
	if ([slides isKindOfClass:[NSArray class]]) {
		NSMutableArray *slidesURL = [NSMutableArray array];
		for (id slide in slides) {
			if ([slide isKindOfClass:[NSDictionary class]]) {
				NSArray *objects = [slide allObjects];
				id object = objects.firstObject;
				if ([object isKindOfClass:[NSString class]]) {
					[slidesURL addObject:object];
				}
			} else if ([slide isKindOfClass:[NSString class]]) {
				[slidesURL addObject:slide];
			}
			
		}
		self.slides = [NSArray arrayWithArray:slidesURL];
	}
}

- (void)setFullImageURL:(NSURL *)fullImageURL
{
	if (fullImageURL.absoluteString.length == 0) {
		[super setFullImageURL:[[NSBundle mainBundle] URLForResource:@"profile_image_holder" withExtension:@"png"]];
	} else {
		[super setFullImageURL:fullImageURL];
	}
}

- (void)setThumbnailURL:(NSURL *)thumbnailURL
{
	if (thumbnailURL.absoluteString.length == 0) {
		[super setThumbnailURL:[[NSBundle mainBundle] URLForResource:@"profile_image_holder_thumb" withExtension:@"png"]];
	} else {
		[super setThumbnailURL:thumbnailURL];
	}
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%ld - %@", (long)self.identifier, self.name];
}

- (NSString *)followItemName
{
	return [NSString stringWithFormat:@"users/%ld/follow_unfollow.json", (long)self.identifier];
}

@end
