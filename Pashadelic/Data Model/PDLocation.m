//
//  PDLocation.m
//  Pashadelic
//
//  Created by TungNT2 on 6/18/14.
//
//

#import "PDLocation.h"
#import "PDPOIItem.h"

@interface PDLocation ()
- (void)updateMapImageURL;
@end

@implementation PDLocation

- (id)initWithLocationType:(NSUInteger)locationType
{
    self = [super init];
    if (self) {
        self.locationType = locationType;
    }
    return self;
}

- (void)loadShortDataFromDictionary:(NSDictionary *)dictionary
{
    self.identifier = [dictionary intForKey:@"id"];
    self.name = [dictionary stringForKey:@"name"];
    self.avatarURL = [NSURL URLWithString:[dictionary stringForKey:@"avatar_list_url"]];
    self.avatar = [NSURL URLWithString:[dictionary stringForKey:@"avatar"]];
    self.landmarksCount = [dictionary intForKey:@"landmarks_count"];
    self.photosCount = [dictionary intForKey:@"photos_count"];
    self.usersCount = [dictionary intForKey:@"users_count"];
    self.photographersCount = [dictionary intForKey:@"photographers_count"];
}

- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary
{
    [self loadShortDataFromDictionary:dictionary];
    self.latitude = [dictionary floatForKey:@"latitude"];
    self.longitude = [dictionary floatForKey:@"longitude"];
    self.userFollowerCollectCount = [dictionary intForKey:@"snapped_friends_count"];
    self.photos = [self loadPhotosFromArray:dictionary[@"popular_photos"]];
    self.photographers = [self loadUsersFromArray:dictionary[@"photographers"]];
    self.landmarks = [self loadLandmarksFromArray:dictionary[@"popular_landmarks"]];
    self.photographersCount = [dictionary intForKey:@"photographers_count"];
    [self updateMapImageURL];
}

- (NSArray *)loadPhotosFromArray:(NSArray *)sourceArray
{
    if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *item in sourceArray) {
        PDPhoto *photo = [[PDPhoto alloc] init];
        [photo loadShortDataFromDictionary:item];
        photo.date = item[@"taken_on"];
        if (!photo.identifier)
            continue;
        [array addObject:photo];
    }
    return array;
}

- (NSArray *)loadUsersFromArray:(NSArray *)sourceArray
{
    if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *item in sourceArray) {
        PDUser *user = [[PDUser alloc] init];
        [user loadShortDataFromDictionary:item];
        if (!user.identifier)
            continue;
        [array addObject:user];
    }
    return array;
}

- (NSArray *)loadLandmarksFromArray:(NSArray *)sourceArray
{
    if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *item in sourceArray) {
        PDPOIItem *poiItem = [[PDPOIItem alloc] init];
        [poiItem loadFullDataFromDictionary:item];
        if (!poiItem.identifier)
            continue;
        [array addObject:poiItem];
    }
    return array;
}

- (void)updateMapImageURL
{
	NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?"
					 "center=%f,%f"
					 "&zoom=%zd"
					 "&size=%zdx%zd"
					 "&scale=%zd"
					 "&sensor=false"
					 "&markers=color:blue%%7C%f,%f"
					 "&api_key=%@",
					 self.latitude, self.longitude,
					 12,
					 310, 180,
					 (NSInteger)[[UIScreen mainScreen] scale],
					 self.latitude, self.longitude,
					 kPDGoogleMapsAPIToken];
	self.mapImageURLString = url;
}

@end
