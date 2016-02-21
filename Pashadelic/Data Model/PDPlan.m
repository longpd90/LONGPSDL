//
//  PDPan.m
//  Pashadelic
//
//  Created by LongPD on 11/14/13.
//
//

#import "PDPlan.h"

@implementation PDPlan
- (void)loadDataFromDictionary:(NSDictionary *)dictionary
{
	self.identifier = [dictionary intForKey:@"id"];
	self.name = [dictionary stringForKey:@"name"];
    self.desc = [dictionary stringForKey:@"description"];
    self.time = [dictionary stringForKey:@"planed_at"];
    self.userID = [dictionary intForKey:@"user_id"];
	self.address = [dictionary stringForKey:@"address"];
	self.latitude = [[dictionary objectForKey:@"lat"]doubleValue];
    self.longitude = [[dictionary objectForKey:@"lon"]doubleValue];
    self.participantsCount = [dictionary intForKey:@"participants_count"];
    self.capacity = [dictionary intForKey:@"capacity"];
    self.photo = [[PDPhoto alloc]init];
    NSArray *photos = [dictionary objectForKey:@"photos"];
    if (photos.count != 0) {
        [self.photo loadShortDataFromDictionary:[photos objectAtIndex:0]];
    }
    
    self.user = [[PDUser alloc] init];
    [self.user loadFullDataFromDictionary:[dictionary objectForKey:@"creator"]];
    [self.user loadShortDataFromDictionary:[dictionary objectForKey:@"creator"]];
    [self loadPaticipantsWithDictionnary:dictionary];
    self.comments = [self loadCommentsFromArray:dictionary[@"comments"]];
    self.commentsCount = [dictionary intForKey:@"comments_count"];
    self.joinStatus = [dictionary boolForKey:@"join_status"];
    [self updateMapImageURL];
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

- (void)loadPaticipantsWithDictionnary:(NSDictionary *)dictionary
{
    NSMutableArray *result = [dictionary objectForKey:@"participants"];
    NSMutableArray *participants = [[NSMutableArray alloc] init];
	if ([participants isKindOfClass:[NSArray class]]) {
		for (NSDictionary *participant in result) {
			PDUser *user = [[PDUser alloc] init];
            [user loadShortDataFromDictionary:participant];
            [participants addObject:user];
		}
	}
    self.paticipants = participants;
}

- (NSArray *)loadCommentsFromArray:(NSArray *)sourceArray
{
    if (![sourceArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *item in sourceArray) {
        PDComment *comment = [[PDComment alloc] init];
        [comment loadFullDataFromDictionary:item];
        if (!comment.identifier)
            continue;
        [array addObject:comment];
    }
    return array;
}

@end
