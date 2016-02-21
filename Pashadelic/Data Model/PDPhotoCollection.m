//
//  PDPhotoCollection.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 10.07.13.
//
//

#import "PDPhotoCollection.h"

@implementation PDPhotoCollection

- (void)loadFromDictionary:(NSDictionary *)dictionary
{
	self.identifier = [dictionary intForKey:@"id"];
	self.title = [dictionary stringForKey:@"name"];
	self.desc = [dictionary stringForKey:@"description"];
	self.thumbnailURL = [dictionary stringForKey:@"image_tile_url"];
	self.photosCount = [dictionary intForKey:@"photos_count"];
}

@end
