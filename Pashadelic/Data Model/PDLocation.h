//
//  PDLocation.h
//  Pashadelic
//
//  Created by TungNT2 on 6/18/14.
//
//

#import "PDItem.h"

@interface PDLocation : PDItem

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (copy, nonatomic) NSURL *avatarURL;
@property (copy, nonatomic) NSURL *avatar;
@property (assign, nonatomic) NSUInteger userFollowerCollectCount;
@property (assign, nonatomic) NSUInteger photosCount;
@property (assign, nonatomic) NSUInteger usersCount;
@property (assign, nonatomic) NSUInteger landmarksCount;
@property (assign, nonatomic) NSUInteger photographersCount;
@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray *photographers;
@property (strong, nonatomic) NSArray *landmarks;
@property (strong, nonatomic) NSString *mapImageURLString;
@property (assign, nonatomic) NSUInteger locationType;

- (id)initWithLocationType:(NSUInteger)locationType;
- (void)loadShortDataFromDictionary:(NSDictionary *)dictionary;
- (void)loadFullDataFromDictionary:(NSDictionary *)dictionary;

@end
