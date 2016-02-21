//
//  PDGeoTag.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.05.13.
//
//

#import "PDTag.h"
#import <MapKit/MapKit.h>

@class PDPhoto;

@interface PDPOIItem : PDTag
<MKAnnotation>

@property (weak, nonatomic) PDPhoto *photo;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *info;
@property (copy, nonatomic) NSString *avatarTileURL;
@property (copy, nonatomic) NSURL *avatarURL;

@property (strong, nonatomic) NSArray *photos;
@property (assign, nonatomic) NSUInteger rating;
@property (assign, nonatomic) NSUInteger followersCount;
@property (assign, nonatomic) NSUInteger reviewsCount;
@property (assign, nonatomic) NSUInteger photosCount;
@property (assign, nonatomic) NSUInteger photosgraphersCount;
@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) BOOL followStatus;

- (id)initWithPhoto:(PDPhoto *)photo;
- (NSString *)distanceInString;
- (NSString *)unitDistanceString;

@end
