//
//  PDGeoTag.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.05.13.
//
//

#import "PDPOIItem.h"
#import "PDLocationHelper.h"

@implementation PDPOIItem

- (id)initWithPhoto:(PDPhoto *)photo
{
	self = [super init];
	if (self) {
		self.photo = photo;
	}
	return self;
}

- (NSString *)title
{
	return self.name;
}

- (NSString *)subtitle
{
	return self.location;
}

- (CLLocationCoordinate2D)coordinate
{
	return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary
{
	self.identifier = [dictionary intForKey:@"id"];
	self.name = [dictionary stringForKey:@"name"];
    self.avatarURL = [NSURL URLWithString:[dictionary stringForKey:@"avatar_list_url"]];
	self.followStatus = [dictionary boolForKey:@"follow_status"];
	self.followersCount = [dictionary intForKey:@"followers_count"];
	self.rating = roundf([dictionary floatForKey:@"rating"]);
	self.phone = [dictionary stringForKey:@"tel"];
    self.totalCount = [dictionary intForKey:@"total_count"];
	self.photosCount = [dictionary intForKey:@"photos_count"];
    self.avatarTileURL = [dictionary stringForKey:@"avatar_tile_url"];
    self.photosgraphersCount = [dictionary intForKey:@"photosgraphers_count"];
	self.latitude = [dictionary doubleForKey:@"latitude"];
	self.longitude = [dictionary doubleForKey:@"longitude"];
	self.location = [dictionary stringForKey:@"address"];
	self.location = [self.location stringByReplacingOccurrencesOfString:@",," withString:@""];
	self.info = [dictionary stringForKey:@"description"];
	self.reviewsCount = [dictionary intForKey:@"reviews_count"];
	
	NSArray *photosInfo = dictionary[@"photos"];
	NSMutableArray *photos = [NSMutableArray arrayWithCapacity:photosInfo.count];
	for (NSDictionary *photoInfo in photosInfo) {
		PDPhoto *photo = [[PDPhoto alloc] init];
		[photo loadShortDataFromDictionary:photoInfo];
		[photos addObject:photo];
		if (photos.count >= kPDMaxItemsPerPage) break;
	}
	self.photos = photos;
}

- (NSString *)followItemName
{
	return [NSString stringWithFormat:@"gtags/%zd/follow_unfollow.json", self.identifier];
}

- (double)distanceInMeters
{
	return [[PDLocationHelper sharedInstance] distanceToLatitude:self.latitude
													   longitude:self.longitude];
}

- (NSString *)distanceInString
{
	int distance = [self distanceInMeters];
	
	if (distance < 0) {
		return @"";
	} else 	if (distance < 1000) {
		return [NSString stringWithFormat:@"%zd", (NSInteger) distance];
	} else {
		return [NSString stringWithFormat:@"%.1f", (double) distance / 1000];
	}
}

- (NSString *)unitDistanceString
{
    int distance = [self distanceInMeters];
    if (distance < 0) {
		return @"";
	}
    else if (distance < 1000) {
        return [NSString stringWithFormat:@"%@",NSLocalizedString(@"m", nil)];
    } else {
        return [NSString stringWithFormat:@"%@",NSLocalizedString(@"km", nil)];
    }
}

@end
