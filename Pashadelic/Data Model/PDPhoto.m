//
//  PDPhoto.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhoto.h"
#import "PDComment.h"
#import "PDServerLike.h"
#import "MWPhotoProtocol.h"
#import "PDPOIItem.h"
#import "PDLocationHelper.h"
#import "PDPhotoNearbyViewController.h"
#import "PDUserProfile.h"
#import "PDAppRater.h"
#import <ImageIO/ImageIO.h>
#import "PDLocation.h"

@interface PDPhoto () <MGServerExchangeDelegate, MWPhoto>

@property (strong, nonatomic) PDPhotoActionCompletionBlock completionBlock;
@property (strong, nonatomic) PDServerExchange *likeServerExchange;
@property (strong, nonatomic) PDServerExchange *pinServerExchange;

- (void)postPhotoStatusChangedNotificationWithState:(NSInteger)state;
- (NSDate *)localTimeFromUTC:(NSString *)utcTimeString;
- (void)fixMinImageWidth;
- (void)imageDidLoadNotify;
- (void)updateMapImageURL;

@end

@implementation PDPhoto

- (id)init
{
    self = [super init];
    if (self) {
        _tripod = kPDNoTip;
        _is_crowded = kPDNoTip;
        _is_parking = kPDNoTip;
        _is_dangerous = kPDNoTip;
        _indoor = kPDNoTip;
        _is_permission = kPDNoTip;
        _is_paid = kPDNoTip;
        _difficulty_access = kPDNoTip;
    }
    return self;
}

- (void)setExifData:(NSMutableDictionary *)exifData
{
    _exifData = exifData;
    
    NSMutableDictionary *GPSInfo = [NSMutableDictionary dictionaryWithDictionary:
									[exifData objectForKey:(NSString *)kCGImagePropertyGPSDictionary]];
	double latitude = [GPSInfo doubleForKey:@"Latitude"];
	double longitude = [GPSInfo doubleForKey:@"Longitude"];
	
	if ([[GPSInfo objectForKey:@"LatitudeRef"] isEqualToString:@"S"]) {
		latitude = -latitude;
	}
	if ([[GPSInfo objectForKey:@"LongitudeRef"] isEqualToString:@"W"]) {
		longitude = -longitude;
	}
    self.latitude = latitude;
    self.longitude = longitude;
}

- (NSString *)likesCountInString
{
	return [self countValueInString:self.likesCount];
}

- (NSString *)pinsCountInString
{
	return [self countValueInString:self.pinsCount];
}

- (NSString *)commentsCountInString
{
	return [self countValueInString:self.commentsCount];
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
		return [NSString stringWithFormat:@"%zd%@", (NSInteger) distance, NSLocalizedString(@"m", nil)];
	} else {
		return [NSString stringWithFormat:@"%.1f%@", (double) distance / 1000, NSLocalizedString(@"km", nil)];
	}
}

- (NSString *)textForShare
{
	return [NSString stringWithFormat:@"%@\n%@", self.title, self.fullImageURL];
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
					 320, 230,
					 (NSInteger)[[UIScreen mainScreen] scale],
					 self.latitude, self.longitude,
					 kPDGoogleMapsAPIToken];
	self.mapImageURLString = url;
}

- (void)likePhoto
{
	if (self.likeServerExchange.isLoading) {
		if (self.completionBlock) {
			self.completionBlock();
			self.completionBlock = nil;
		}
		return;
	}
    
    [PDAppRater userDidSignificantEvent:NO];
    
	PDServerLike *serverLike = [[PDServerLike alloc] initWithDelegate:self];
	self.likeServerExchange = serverLike;
	
	if (self.likedStatus) {
		[serverLike unlikePhoto:self];
	} else {
		[serverLike likePhoto:self];
	}
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:self forKey:@"object"];
	
	if (self.likedStatus) {
		self.likedStatus = NO;
		self.likesCount--;
	} else {
		self.likedStatus = YES;
		self.likesCount++;
	}
	
	[userInfo setObject:@[
						  @{@"value" : [NSNumber numberWithBool:self.likedStatus], @"key" : @"likedStatus"},
						  @{@"value" : [NSNumber numberWithInteger:self.likesCount], @"key" : @"likesCount"}] forKey:@"values"];
    [self postPhotoStatusChangedNotificationWithState:PDPhotoChangedStateLike];
	[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
														object:self
													  userInfo:userInfo];
	if (self.completionBlock) {
		self.completionBlock();
		self.completionBlock = nil;
	}
}

- (void)likePhotoWithCompletionBlock:(PDPhotoActionCompletionBlock)completionBlock
{
	self.completionBlock = completionBlock;
	[self likePhoto];
}

- (void)pinPhoto
{
	if (self.pinServerExchange.isLoading) {
		if (self.completionBlock) {
			self.completionBlock();
			self.completionBlock = nil;
		}
		return;
	}
    
    [PDAppRater userDidSignificantEvent:NO];
    
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:self forKey:@"object"];
	if (!self.pinnedStatus) {
		self.pinnedStatus = YES;
		self.pinsCount++;
		kPDAppDelegate.userProfile.pinsCount++;
		@synchronized(kPDAppDelegate.userProfile.pins) {
			[kPDAppDelegate.userProfile.pins addObject:self];
		}
	}
	[userInfo setObject:@[
						  @{@"value" : [NSNumber numberWithBool:self.pinnedStatus], @"key" : @"pinnedStatus"},
						  @{@"value" : [NSNumber numberWithInteger:self.pinsCount], @"key" : @"pinsCount"}] forKey:@"values"];
	
    [self postPhotoStatusChangedNotificationWithState:PDPhotoChangedStatePin];
	[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
														object:self
													  userInfo:userInfo];
	if (self.completionBlock) {
		self.completionBlock();
		self.completionBlock = nil;
	}
}

- (void)unPinPhoto
{
	if (self.pinServerExchange.isLoading) {
		if (self.completionBlock) {
			self.completionBlock();
			self.completionBlock = nil;
		}
		return;
	}
	
	PDServerPin *serverPin = [[PDServerPin alloc] initWithDelegate:self];
	self.pinServerExchange = serverPin;
	
	if (self.pinnedStatus) {
		[serverPin unpinPhoto:self];
    }
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:self forKey:@"object"];
	if (self.pinnedStatus) {
		self.pinnedStatus = NO;
		self.pinsCount--;
		kPDAppDelegate.userProfile.pinsCount--;
		@synchronized(kPDAppDelegate.userProfile.pins) {
			[kPDAppDelegate.userProfile.pins removeObject:self];
		}
	}
	self.pinServerExchange = nil;
	[userInfo setObject:@[
						  @{@"value" : [NSNumber numberWithBool:self.pinnedStatus], @"key" : @"pinnedStatus"},
						  @{@"value" : [NSNumber numberWithInteger:self.pinsCount], @"key" : @"pinsCount"}] forKey:@"values"];
	
    [self postPhotoStatusChangedNotificationWithState:PDPhotoChangedStatePin];
	[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
														object:self
													  userInfo:userInfo];
	if (self.completionBlock) {
		self.completionBlock();
		self.completionBlock = nil;
	}
}

- (void)pinPhotoWithCompletionBlock:(PDPhotoActionCompletionBlock)completionBlock
{
	self.completionBlock = completionBlock;
	[self pinPhoto];
}

- (CLLocationCoordinate2D)coordinates
{
	return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (void)fixMinImageWidth
{
	if (self.photoWidth < kPDAppDelegate.window.width) {
		double proportion = kPDAppDelegate.window.width / self.photoWidth;
		self.photoWidth = kPDAppDelegate.window.width;
		self.photoHeight *= proportion;
	}
}

- (void)loadShortDataFromDictionary:(NSDictionary *)dictionary
{
	if ([dictionary isKindOfClass:[NSNull class]]) return;
	
	self.identifier = [dictionary intForKey:@"id"];
    self.spotId = [dictionary intForKey:@"spot_id"];
    self.status = [dictionary intForKey:@"status"];
	self.likesCount = [dictionary intForKey:@"likes_count"];
	self.pinsCount = [dictionary intForKey:@"pins_count"];
	self.likedStatus = [dictionary boolForKey:@"like_status"];
	self.pinnedStatus = [dictionary boolForKey:@"pin_status"];
	self.commentsCount = [dictionary intForKey:@"comments_count"];
	self.latitude = [dictionary doubleForKey:@"lat"];
	self.longitude = [dictionary doubleForKey:@"lon"];
	self.photoHeight = [dictionary intForKey:@"height"];
	self.photoWidth = [dictionary intForKey:@"width"];
	[self fixMinImageWidth];
	self.photoListImageSize = [UIImageView sizeThatFitImageSize:CGSizeMake(_photoWidth, _photoHeight)
												maxViewSize:CGSizeMake(kPDPhotoListImageWidth, MAXFLOAT)];
	if (self.photoListImageSize.height == 0) {
		self.photoListImageSize = CGSizeMake(400, 100);
	}
	self.location = [dictionary stringForKey:@"location"];
	self.location = [self.location stringByReplacingOccurrencesOfString:@",," withString:@""];
	self.title = [dictionary stringForKey:@"title"];
	
	static NSDateFormatter *dateFormatter;
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	}
	self.createdDate = [dateFormatter dateFromString:[dictionary stringForKey:@"created_at"]];
  
	if (self.thumbnailURL.absoluteString.length == 0) {
		self.thumbnailURL = [dictionary urlForKey:@"image_tile_url"];
	}
	if (self.fullImageURL.absoluteString.length == 0) {
		self.fullImageURL = [dictionary urlForKey:@"image_list_url"];
	}
	
	if (!self.user) {
		self.user = [[PDUser alloc] init];
		self.user.name = [dictionary stringForKey:@"owner_username"];
		self.user.identifier = [dictionary intForKey:@"owner_id"];
		self.user.thumbnailURL = [dictionary urlForKey:@"owner_avatar_url"];		
	}
	[self updateMapImageURL];
}

- (NSDate *)localTimeFromUTC:(NSString *)utcTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter dateFromString:utcTimeString];
}

- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary
{
	[self loadShortDataFromDictionary:dictionary];
	
	if (!self.user) {
		self.user = [[PDUser alloc] init];
	}
	[self.user loadFullDataFromDictionary:[dictionary objectForKey:@"owner"]];
	self.source = [dictionary stringForKey:@"source"];
	self.altitude = [dictionary doubleForKey:@"altitude"];
	self.date = [dictionary stringForKey:@"taken_on"];
	self.details = [dictionary stringForKey:@"description"];
    
    if ([dictionary objectForKey:@"tripod"] == (id)[NSNull null]) {
        self.tripod = - 1;
    }else{
        self.tripod = [dictionary intForKey:@"tripod"];
    }
    if ([dictionary objectForKey:@"is_crowded"] == (id)[NSNull null]) {
        self.is_crowded = - 1;
    }else{
        self.is_crowded = [dictionary intForKey:@"is_crowded"];
    }
    if ([dictionary objectForKey:@"is_dangerous"] == (id)[NSNull null]) {
        self.is_dangerous = - 1;
    }else{
        self.is_dangerous = [dictionary intForKey:@"is_dangerous"];
    }
    if ([dictionary objectForKey:@"is_paid"] == (id)[NSNull null]) {
        self.is_paid = - 1;
    }else{
        self.is_paid = [dictionary intForKey:@"is_paid"];
    }
    if ([dictionary objectForKey:@"is_parking"] == (id)[NSNull null]) {
        self.is_parking = - 1;
    }else{
        self.is_parking = [dictionary intForKey:@"is_parking"];
    }
    if ([dictionary objectForKey:@"is_permission"] == (id)[NSNull null]) {
        self.is_permission = - 1;
    }else{
        self.is_permission = [dictionary intForKey:@"is_permission"];
    }
    if ([dictionary objectForKey:@"indoor"] == (id)[NSNull null]) {
        self.indoor = - 1;
    }else{
        self.indoor = [dictionary intForKey:@"indoor"];
    }
    
    if ([dictionary objectForKey:@"difficulty"] == (id)[NSNull null]) {
        self.difficulty_access = - 1;
    }else{
        self.difficulty_access = [dictionary intForKey:@"difficulty"];
    }
    
	NSDictionary *exifData = [dictionary objectForKey:@"exif"];
	self.cameraInfo = [exifData stringForKey:@"camera_model"];
	self.aperture = [exifData stringForKey:@"aperture_value"];
	self.focalLength = [exifData stringForKey:@"focal_length"];
	self.isoFilm = [exifData stringForKey:@"iso_speed_ratings"];
	self.shutterSpeed = [exifData stringForKey:@"shutter_speed_value"];
    self.manufacter = [exifData stringForKey:@"make"];
    self.lens = [exifData stringForKey:@"lens_model"];
    self.filter = [exifData stringForKey:@"make"];

	NSDictionary *poiInfo = dictionary[@"poi"];
	if ([poiInfo isKindOfClass:[NSDictionary class]]) {
		if (poiInfo.count > 0) {
			self.poiItem = [[PDPOIItem alloc] initWithPhoto:self];
			[self.poiItem loadFullDataFromDictionary:poiInfo];
		}
	}
    
    NSDictionary *landmarkInfo = dictionary[@"poi"];
	if ([landmarkInfo isKindOfClass:[NSDictionary class]]) {
		if (landmarkInfo.count > 0) {
			self.landmark = [[PDLocation alloc] initWithLocationType:PDLocationTypeLandmark];
			[self.landmark loadShortDataFromDictionary:landmarkInfo];
		}
	}
    
    NSDictionary *countryInfo = dictionary[@"country"];
    if (countryInfo && [countryInfo isKindOfClass:[NSDictionary class]]) {
        self.country = [[PDLocation alloc] initWithLocationType:PDLocationTypeCountry];
        [self.country loadShortDataFromDictionary:countryInfo];
    }
    
    NSDictionary *stateInfo = dictionary[@"state"];
    if (stateInfo && [stateInfo isKindOfClass:[NSDictionary class]]) {
        self.state = [[PDLocation alloc] initWithLocationType:PDLocationTypeState];
        [self.state loadShortDataFromDictionary:stateInfo];
    }
    
    NSDictionary *cityInfo = dictionary[@"city"];
    if (cityInfo && [cityInfo isKindOfClass:[NSDictionary class]]) {
        self.city = [[PDLocation alloc] initWithLocationType:PDLocationTypeCity];
        [self.city loadShortDataFromDictionary:cityInfo];
    }
    
	id dictionaryTags = [dictionary objectForKey:@"tags"];
	if ([dictionaryTags isKindOfClass:[NSArray class]]) {
		self.tags = [dictionaryTags componentsJoinedByString:@", "];
	} else if ([dictionaryTags isKindOfClass:[NSString class]]) {
		self.tags = dictionaryTags;
	}
	self.comments = [self loadCommentsFromArray:dictionary[@"comments"]];
	[self updateMapImageURL];
    
    NSArray *likingsUserInfo = dictionary[@"liking_users"];
	NSMutableArray *likingsUser = [NSMutableArray arrayWithCapacity:likingsUserInfo.count];
	for (NSDictionary *userInfo in likingsUserInfo) {
		PDUser *user = [[PDUser alloc] init];
		[user loadShortDataFromDictionary:userInfo];
		[likingsUser addObject:user];
	}
	self.likingsUser = likingsUser;
    
    NSArray *piningsUserInfo = dictionary[@"pining_users"];
	NSMutableArray *piningsUser = [NSMutableArray arrayWithCapacity:piningsUserInfo.count];
	for (NSDictionary *userInfo in piningsUserInfo) {
		PDUser *user = [[PDUser alloc] init];
		[user loadShortDataFromDictionary:userInfo];
		[piningsUser addObject:user];
	}
	self.piningsUser = piningsUser;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%ld %@, %ldx%ld", (long)self.identifier, self.title, (long)self.photoWidth, (long)self.photoHeight];
}

- (NSInteger)photoHeight
{
	if (_photoHeight > 0) return _photoHeight;
	
	return [UIScreen mainScreen].bounds.size.height / 3;
}

- (NSInteger)photoWidth
{
	if (_photoWidth > 0) return _photoWidth;
	
	return [UIScreen mainScreen].bounds.size.width;

}

- (NSString *)followItemName
{
	return [NSString stringWithFormat:@"photos/%ld/follow_unfollow.json", (long)self.identifier];
}

- (void)postPhotoStatusChangedNotificationWithState:(NSInteger)state
{
    NSDictionary *statusInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:state] forKey:@"state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDPhotoStatusChangedNotification object:self userInfo:statusInfo];
}


#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
}

- (void)imageDidLoadNotify
{
	[[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_LOADING_DID_END_NOTIFICATION object:self];
}

#pragma mark - MWPhoto

- (UIImage *)underlyingImage
{
	return [self cachedFullImage];
}

- (void)loadUnderlyingImageAndNotify
{
	[[SDWebImageManager sharedManager] downloadImageWithURL:self.fullImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
		[self performSelector:@selector(imageDidLoadNotify) withObject:nil afterDelay:0.5];
	}];
}

- (void)unloadUnderlyingImage
{
	[[SDImageCache sharedImageCache] removeImageForKey:self.fullImageURL.absoluteString fromDisk:NO];
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
