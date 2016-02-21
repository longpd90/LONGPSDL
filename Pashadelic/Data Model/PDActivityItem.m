//
//  PDFeedItem.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.09.13.
//
//

#import "PDActivityItem.h"

@implementation PDActivityItem

- (void)loadShortDataFromDictionary:(NSDictionary *)dictionary
{
  if ([dictionary objectForKey:@"exif"]) {
    [super loadShortDataFromDictionary:dictionary];
    return;
  }
	self.thumbnailURL = [dictionary urlForKey:@"track_image"];
	self.fullImageURL = self.thumbnailURL;
	self.identifier = [dictionary intForKey:@"track_id"];
	self.photoHeight = [dictionary intForKey:@"height"];
	self.photoWidth = [dictionary intForKey:@"width"];
	self.likedStatus = [dictionary intForKey:@"like_status"];
    self.pinnedStatus = [dictionary intForKey:@"pin_status"];
  	self.photoListImageSize = [UIImageView sizeThatFitImageSize:CGSizeMake(self.photoWidth, self.photoHeight)
                                                    maxViewSize:CGSizeMake(kPDPhotoListImageWidth, MAXFLOAT)];
    self.listOfID = [self listIdFromString:[dictionary stringForKey:@"list_ids"]];
  
	if (!self.userActivity) {
		self.userActivity = [PDUser new];
	}
    self.userActivity.identifier = [[self.listOfID lastObject] intValue];
	self.userActivity.name = [dictionary stringForKey:@"username"];
	self.userActivity.thumbnailURL = [dictionary urlForKey:@"avatar_url"];
	self.userActivity.fullImageURL = self.userActivity.thumbnailURL;
  
	self.actionTitle = [dictionary stringForKey:@"activity_title"];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    self.createdDate = [dateFormatter dateFromString:[dictionary stringForKey:@"created_at"]];
    
    if (!self.user) {
		self.user = [PDUser new];
	}
    self.user.identifier = [dictionary intForKey:@"track_owner_id"];

}

- (void)setValuesFromArray:(NSArray *)array
{
	for (NSDictionary *value in array) {
		NSString *key = [value objectForKey:@"key"];
		SEL selector = NSSelectorFromString(key);
		if ([self respondsToSelector:selector]) {
			[self setValue:[value objectForKey:@"value"] forKey:key];
		}
	}
}

- (NSArray *)listIdFromString:(NSString *)string
{
  if ([self arrayFromString:string splitByString:@","]) {
    return [self arrayFromString:string splitByString:@","];
  } else {
    return [NSArray arrayWithObject:string];
  }
}

- (NSArray *)arrayFromString:(NSString *)string splitByString:(NSString *)split
{
  if ([string rangeOfString:split].location != NSNotFound) {
    return [NSArray arrayWithArray:[string componentsSeparatedByString:split]];
  } else
    return nil;
}

@end
