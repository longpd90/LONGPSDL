//
//  PDPhotoLandMark.m
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDPhotoLandMarkItem.h"

@implementation PDPhotoLandMarkItem

- (void)loadDataFromDictionary:(NSDictionary *)dictionary
{
    self.identifier = [dictionary intForKey:@"id"];
	self.name = [dictionary stringForKey:@"name"];
    self.desc = [dictionary stringForKey:@"description"];
    self.alias = [dictionary stringForKey:@"description"];
    self.category = [dictionary stringForKey:@"description"];
	self.address = [dictionary stringForKey:@"address"];
	self.latitude = [[dictionary objectForKey:@"latitude"]doubleValue];
    self.longitude = [[dictionary objectForKey:@"longitude"]doubleValue];
    self.photoCount = [dictionary intForKey:@"photos_count"];
    self.userCount = [dictionary intForKey:@"photographers_count"];
    self.avatarListURL = [NSURL URLWithString:[dictionary stringForKey:@"avatar_list_url"]];
    self.avatarTileURL = [NSURL URLWithString:[dictionary stringForKey:@"avatar_tile_url"]];
}

@end
