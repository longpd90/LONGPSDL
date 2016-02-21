//
//  PDPhotosMapView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "PDPhotoLocationAnnotation.h"
#import "PDPhotoLocationView.h"
#import "PDItemMapView.h"
#import "MapPinAnnotation.h"
#import "MapPinAnnotationView.h"
#import "SunMoonAnnotationView.h"
#import "CameraAnnotation.h"
#import "CameraAnnotationView.h"
#import "PDGradientButton.h"
#import "PDPhoto.h"
#import "UIView+Extra.h"



static const CLLocationCoordinate2D EmptyLocationCoordinate = {-1000, -1000};

@interface PDPhotosMapView : PDItemMapView
@property (weak, nonatomic) id <PDPhotoViewDelegate> photoViewDelegate;
@property (strong, nonatomic) PDGradientButton *changeMapModeButton;
@property (strong, nonatomic) MapPinAnnotation *pinAnnotation;
@property (strong, nonatomic) MapPinAnnotationView *pinAnnotationView;
@property (strong, nonatomic) NSDate *sunMoonDate;
@property (assign, nonatomic) CLLocationCoordinate2D sunMoonCoord;
@property (strong, nonatomic) SunMoonAnnotation *sunMoonAnnotation;
@property (strong, nonatomic) SunMoonAnnotationView *sunMoonAnnotationView;
@property (assign, nonatomic) CLLocationCoordinate2D youCoord;
@property (strong, nonatomic) CameraAnnotation *cameraAnnotation;
@property (strong, nonatomic) CameraAnnotationView *cameraAnnotationView;
@property (strong, nonatomic) MKPolyline *polyLine;
@property (strong, nonatomic) MKPolylineView *polyLineView;
@property (assign, nonatomic) float bottomYMapButton;
@property (nonatomic , strong) UIImageView *centerMapPin;
@property (strong, nonatomic) UIImage *planImage;
@property BOOL tapToMapPin;

- (IBAction)toggleMapViewMode:(id)sender;
- (void)zoomToRegionForMax:(CLLocationCoordinate2D)maxLocation andMin:(CLLocationCoordinate2D)minLocation;
- (void)zoomToRegion:(MKCoordinateRegion)region;
- (void)setHiddenPhotoAnnotations:(BOOL)hidden;
- (void)setHiddenSunMoonAnnotation:(BOOL)hidden;
- (void)addAnnotationSunMoonWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)removeSunMoonAnnotation;
- (void)resetSunYouCoordinate;
- (void)changeUserTrackingMode;
- (void)removePhotoLocationAnnotation;
- (CLLocationCoordinate2D)sunMoonCoordinate;
- (CLLocationCoordinate2D)centerMapViewCoordinate;
- (MKUserTrackingMode)userTrackingMode;
- (void)reloadMapWithoutReloadRegion;
- (void)addAnnotationPlanWithLatitude:(double )latitude withLongitude:(double )longitude withImage:(UIImage *)image;
- (BOOL)isCoordinate2DValid:(CLLocationCoordinate2D)coordinate;
- (void)addNotification;
- (void)removeNotification;

@end
