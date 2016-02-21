//
//  PDPhoto.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class PDPhoto;
@class PDUser;
@class PDPOIItem;
@class PDLocation;
enum PDPhotoChangedState {
	PDPhotoChangedStatePin = 0,
	PDPhotoChangedStateLike
};

@protocol PDPhotoViewDelegate <NSObject>
- (void)photo:(PDPhoto *)photo didSelectInView:(UIView *)view image:(UIImage *)image;
@end

#define kPDPhotoListImageWidth 240

typedef void(^PDPhotoActionCompletionBlock)(void);


@interface PDPhoto : PDItem

@property (assign, nonatomic) NSInteger likesCount;
@property (assign, nonatomic) NSInteger pinsCount;
@property (assign, nonatomic) NSInteger commentsCount;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double altitude;
@property (assign, nonatomic) BOOL pinnedStatus;
@property (assign, nonatomic) BOOL likedStatus;
@property (assign, nonatomic) NSInteger photoWidth;
@property (assign, nonatomic) NSInteger photoHeight;
@property (assign, nonatomic) CGSize photoListImageSize;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *details;
@property (copy, nonatomic) NSString *location;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) PDUser *user;
@property (strong, nonatomic) PDPOIItem *poiItem;
@property (strong, nonatomic) PDLocation *landmark;
@property (strong, nonatomic) PDLocation *country;
@property (strong, nonatomic) PDLocation *state;
@property (strong, nonatomic) PDLocation *city;
@property (copy, nonatomic) NSString *cameraInfo;
@property (copy, nonatomic) NSString *focalLength;
@property (copy, nonatomic) NSString *manufacter;
@property (copy, nonatomic) NSString *lens;
@property (copy, nonatomic) NSString *filter;
@property (copy, nonatomic) NSString *shutterSpeed;
@property (copy, nonatomic) NSString *aperture;
@property (copy, nonatomic) NSString *isoFilm;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) NSString *source;
@property (copy, nonatomic) NSDate *createdDate;
@property (strong, nonatomic) NSString *mapImageURLString;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger spotId;
@property (assign, nonatomic) NSInteger tripod;
@property (assign, nonatomic) NSInteger is_crowded;
@property (assign, nonatomic) NSInteger is_parking;
@property (assign, nonatomic) NSInteger is_dangerous;
@property (assign, nonatomic) NSInteger indoor;
@property (assign, nonatomic) NSInteger is_permission;
@property (assign, nonatomic) NSInteger is_paid;
@property (assign, nonatomic) NSInteger difficulty_access;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDictionary *exifData;
@property (strong, nonatomic) NSArray *likingsUser;
@property (strong, nonatomic) NSArray *piningsUser;

- (id)init;
- (double)distanceInMeters;
- (CLLocationCoordinate2D)coordinates;
- (NSString *)distanceInString;
- (NSString *)likesCountInString;
- (NSString *)pinsCountInString;
- (NSString *)commentsCountInString;
- (void)likePhoto;
- (void)pinPhoto;
- (void)likePhotoWithCompletionBlock:(PDPhotoActionCompletionBlock)completionBlock;
- (void)pinPhotoWithCompletionBlock:(PDPhotoActionCompletionBlock)completionBlock;
- (void)unPinPhoto;
@end
