//
//  PDPhotosMapView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotosMapView.h"
#import "PDPlanAnnotaion.h"
#import "PDPlanAnnotaionView.h"

@interface PDPhotosMapView (Private)
- (NSDate *)currentDate;
- (void)removePhotoLocationAnnotation;
- (void)addPointYouWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (void)plotRouteOnMap:(CLLocationCoordinate2D )lastLocation atCurrent2DLocation:(CLLocationCoordinate2D )currentLocation;
@end

@implementation PDPhotosMapView

- (NSDate *)currentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate date];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *timeComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit |
                                                        NSMonthCalendarUnit | NSYearCalendarUnit)
                                              fromDate:date];
    NSInteger  day = [timeComp day];
    NSInteger  month = [timeComp month];
    NSInteger  year = [timeComp year];
    NSInteger hour = [timeComp hour];
    NSInteger minute = [timeComp minute];

    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld", (long)year, (long)month, (long)day,(long)hour,(long)minute];
    NSDate *currentDate = [dateFormatter dateFromString:dateString];
    return currentDate;
}

- (void)resetSunYouCoordinate
{
    [self removeSunMoonAnnotation];
    [self removeYouPointAnnotation];
    self.sunMoonCoord = EmptyLocationCoordinate;
    self.youCoord = EmptyLocationCoordinate;
}

- (BOOL)isCoordinate2DValid:(CLLocationCoordinate2D)coordinate
{
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        if (coordinate.latitude != 0 && coordinate.longitude != 0) {
            return YES;
        } else
            return NO;
    } else
        return NO;
}

- (void)clearMap
{
	[self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)initialize
{
	[super initialize];
    self.tapToMapPin = NO;
	self.changeMapModeButton = [[PDGradientButton alloc] initWithFrame:CGRectZero];
	[_changeMapModeButton setTitle:NSLocalizedString(@"satellite", nil) forState:UIControlStateNormal];
	_changeMapModeButton.titleLabel.font = kPDNavigationBarButtonFont;
	_changeMapModeButton.layer.cornerRadius = 5;
	_changeMapModeButton.gradientLayer.cornerRadius = 5;
	_changeMapModeButton.layer.borderWidth = 1;
	[_changeMapModeButton addTarget:self action:@selector(toggleMapViewMode:) forControlEvents:UIControlEventTouchUpInside];
	[_changeMapModeButton setGrayGradientButtonStyle];
	[self addSubview:_changeMapModeButton];
    
    self.bottomYMapButton = 10;
    self.sunMoonDate = [self currentDate];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(didTapMap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.mapView addGestureRecognizer:tapRecognizer];
    [self resetSunYouCoordinate];
    
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pinAnnotationDidChange:)
                                                 name:kPDPinAnnotationCenterDidChangeNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateSunMoonShowOptions:)
                                                 name:kPDSunMoonOptionChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateSunMoonDateTimeOptions:)
                                                 name:kPDSunMoonDateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdatePointYou:)
                                                 name:kPDCameraAnnotationCenterDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didToucheBeganAnnotation)
                                                 name:kPDPinAnnotationCenterDidTochesBeganNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didToucheEndMapPinAnnotation)
                                                 name:kPDPinAnnotationCenterDidTochesEndNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didToucheBeganAnnotation)
                                                 name:kPDPinAnnotationCameraDidTochesBeganNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didToucheEndAnnotation)
                                                 name:kPDPinAnnotationCameraDidTochesEndNotification
                                               object:nil];    
    
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDPinAnnotationCenterDidTochesBeganNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDPinAnnotationCenterDidTochesEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDPinAnnotationCameraDidTochesBeganNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDPinAnnotationCameraDidTochesEndNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDPinAnnotationCenterDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDSunMoonOptionChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDSunMoonDateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDCameraAnnotationCenterDidChangeNotification object:nil];
}

- (void)toggleMapViewMode:(id)sender
{
	if (self.mapView.mapType == MKMapTypeStandard) {
		self.mapView.mapType = MKMapTypeSatellite;
		[_changeMapModeButton setTitle:NSLocalizedString(@"hybrid", nil) forState:UIControlStateNormal];
		
	} else if (self.mapView.mapType == MKMapTypeSatellite) {
		self.mapView.mapType = MKMapTypeHybrid;
		[_changeMapModeButton setTitle:NSLocalizedString(@"map", nil) forState:UIControlStateNormal];
		
	} else if (self.mapView.mapType == MKMapTypeHybrid) {
		self.mapView.mapType = MKMapTypeStandard;
		[_changeMapModeButton setTitle:NSLocalizedString(@"satellite", nil) forState:UIControlStateNormal];
	}
	
}

- (CLLocationCoordinate2D)centerMapViewCoordinate
{
    return self.mapView.centerCoordinate;
}

- (CLLocationCoordinate2D)sunMoonCoordinate
{
    return _sunMoonCoord;
}

- (MKUserTrackingMode)userTrackingMode
{
    return self.mapView.userTrackingMode;
}

- (void)reloadMap
{
    [self removePhotoLocationAnnotation];
	CLLocationCoordinate2D maxPosition = CLLocationCoordinate2DMake(-90, -180);
	CLLocationCoordinate2D minPosition = CLLocationCoordinate2DMake(90, 180);
	
	for (NSInteger i = 0; i < self.items.count; i++) {
		id item = [self.items objectAtIndex:i];
		if (![item isKindOfClass:[PDPhoto class]]) continue;
		PDPhoto *photo = [self.items objectAtIndex:i];
		if (photo.latitude == 0 && photo.longitude == 0) continue;
		photo.itemDelegate = self.itemSelectDelegate;
		PDPhotoLocationAnnotation *annotation = [[PDPhotoLocationAnnotation alloc] init];
		annotation.photo = photo;		
		[self.mapView addAnnotation:annotation];
		
		maxPosition.latitude = MAX(maxPosition.latitude, photo.latitude);
		maxPosition.longitude = MAX(maxPosition.longitude, photo.longitude);		
		minPosition.latitude = MIN(minPosition.latitude, photo.latitude);
		minPosition.longitude = MIN(minPosition.longitude, photo.longitude);
	}
	self.mapView.region = [[PDLocationHelper sharedInstance] regionForMax:maxPosition andMinPosition:minPosition];
}

- (void)addAnnotationPlanWithLatitude:(double )latitude withLongitude:(double )longitude withImage:(UIImage *)image{
    self.planImage = image;

    [self removePhotoLocationAnnotation];
	CLLocationCoordinate2D maxPosition = CLLocationCoordinate2DMake(-90, -180);
	CLLocationCoordinate2D minPosition = CLLocationCoordinate2DMake(90, 180);
    
    PDPlanAnnotaion *planAnnotation = [[PDPlanAnnotaion alloc] initWithTitle:@"Plan" coordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    [self.mapView addAnnotation:planAnnotation];
    
    maxPosition.latitude = MAX(maxPosition.latitude, latitude);
    maxPosition.longitude = MAX(maxPosition.longitude,longitude);
    minPosition.latitude = MIN(minPosition.latitude, latitude);
    minPosition.longitude = MIN(minPosition.longitude, longitude);
    self.mapView.region = [[PDLocationHelper sharedInstance] regionForMax:maxPosition andMinPosition:minPosition];
}

- (void)reloadMapWithoutReloadRegion
{
    [self removePhotoLocationAnnotation];
	
	for (NSInteger i = 0; i < self.items.count; i++) {
		id item = [self.items objectAtIndex:i];
		if (![item isKindOfClass:[PDPhoto class]]) continue;
		PDPhoto *photo = [self.items objectAtIndex:i];
		if (photo.latitude == 0 && photo.longitude == 0) continue;
		photo.itemDelegate = self.itemSelectDelegate;
		PDPhotoLocationAnnotation *annotation = [[PDPhotoLocationAnnotation alloc] init];
		annotation.photo = photo;
		[self.mapView addAnnotation:annotation];
	}
}

- (void)changeUserTrackingMode
{
    if (self.mapView.userTrackingMode == MKUserTrackingModeNone) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
        self.mapView.showsUserLocation = YES;
    } else if (self.mapView.userTrackingMode == MKUserTrackingModeFollow) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    } else {
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    }

}

- (void)addAnnotationSunMoonWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self removeYouPointAnnotation];
    if ([self isCoordinate2DValid:coordinate]) {
        self.sunMoonCoord = coordinate;
        self.youCoord = coordinate;
        
        if (_sunMoonAnnotation) {
            [self.mapView removeAnnotation:_sunMoonAnnotation];
            self.sunMoonAnnotation = nil;
        }
        if (_pinAnnotation) {
            [self.mapView removeAnnotation:_pinAnnotation];
            self.pinAnnotation = nil;
        }

        _pinAnnotation = [[MapPinAnnotation alloc] initWithTitle:@"MapPinAnnotation" coordinate:coordinate];
        [self.mapView addAnnotation:_pinAnnotation];
        
        _sunMoonAnnotation = [[SunMoonAnnotation alloc] initWithTitle:@"SunMoonAnnotation" coordinate:coordinate];
        [self.mapView addAnnotation:_sunMoonAnnotation];
        
        [self.mapView selectAnnotation:_sunMoonAnnotation animated:NO];

        
    }
    
}

- (void)addPointYouWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if ([self isCoordinate2DValid:coordinate]) {
        if (self.sunMoonAnnotation) {
            if (!_cameraAnnotation) {
                self.youCoord = coordinate;
                self.cameraAnnotation = [[CameraAnnotation alloc] initWithTitle:@"CameraAnnotation" coordinate:self.youCoord];
                [self.mapView addAnnotation:_cameraAnnotation];
                [self plotRouteOnMap:self.youCoord atCurrent2DLocation:self.sunMoonCoord];
            }
        }
    }
}

- (void)zoomToRegionForMax:(CLLocationCoordinate2D)maxLocation andMin:(CLLocationCoordinate2D)minLocation
{
    MKCoordinateRegion currentRegion = [[PDLocationHelper sharedInstance] regionForMax:maxLocation
                                                                        andMinPosition:minLocation];
    [self.mapView setRegion:currentRegion animated:YES];
}

- (void)zoomToRegion:(MKCoordinateRegion)region
{
    [self.mapView setRegion:region animated:YES];
    [self resetSunYouCoordinate];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	NSInteger width = 60;
	NSInteger height = 26;
	_changeMapModeButton.frame = CGRectMake(self.width - width - 10, self.height - height - _bottomYMapButton, width, height);
}

- (void)setHiddenPhotoAnnotations:(BOOL)hidden
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        MKAnnotationView *anView = [self.mapView viewForAnnotation:annotation];
        if ([anView isKindOfClass:[PDPhotoLocationAnnotation class]]) {
            [anView setHidden:hidden];
        }
    }
}

- (void)setHiddenSunMoonAnnotation:(BOOL)hidden
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        MKAnnotationView *anView = [self.mapView viewForAnnotation:annotation];
        if ([anView isKindOfClass:[SunMoonAnnotationView class]]) {
            [anView setHidden:hidden];
        }
    }
}

- (void)removePhotoLocationAnnotation
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[PDPhotoLocationAnnotation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
}

- (void)removeSunMoonAnnotation
{
    if (self.pinAnnotation) {
        [self.mapView removeAnnotation:self.pinAnnotation];
        self.pinAnnotation = nil;
    }
    if (self.sunMoonAnnotation) {
        [self.mapView removeAnnotation:self.sunMoonAnnotation];
        self.sunMoonAnnotation = nil;
    }
    [self removeYouPointAnnotation];
}

- (void)removeYouPointAnnotation
{
    if (self.cameraAnnotation) {
        [self.mapView removeAnnotation:self.cameraAnnotation];
        self.cameraAnnotation = nil;
        [self.mapView removeOverlay:_polyLine];
    }
}

- (void)dealloc
{
	[self releaseMemory];
}

#pragma - mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    _sunMoonAnnotationView = nil;
    if ([annotation isKindOfClass:[SunMoonAnnotation class]]) {
        static NSString * const kSunMoonAnnotationIdentifier = @"SunMoonIdentifier";
        if (!_sunMoonAnnotationView) {
            _sunMoonAnnotationView = [[SunMoonAnnotationView alloc] initWithAnnotation:_sunMoonAnnotation
                                                                       reuseIdentifier:kSunMoonAnnotationIdentifier
                                                                              withDate:self.sunMoonDate
                                                                          withLatitude:self.sunMoonCoord.latitude
                                                                         withLongitude:self.sunMoonCoord.longitude];
            _sunMoonAnnotationView.draggable = YES;
        }
        return _sunMoonAnnotationView;
    }
    _pinAnnotationView = nil;
    if ([annotation isKindOfClass:[MapPinAnnotation class]]) {
        
        static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
        _pinAnnotationView = (MapPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
        if (!_pinAnnotationView) {
            
            _pinAnnotationView = [MapPinAnnotationView annotationViewWithAnnotation:annotation
                                                                    reuseIdentifier:kPinAnnotationIdentifier
                                                                            mapView:self.mapView];
        }
        return _pinAnnotationView;
    }
    
    _cameraAnnotationView = nil;

    if ([annotation isKindOfClass:[CameraAnnotation class]]) {
        static NSString *const kCameraAnnotationIdentifier = @"CameraIdentifier";
        _cameraAnnotationView = (CameraAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kCameraAnnotationIdentifier];
        if (!_cameraAnnotationView) {
            _cameraAnnotationView = [CameraAnnotationView annotationViewWithAnnotation:annotation
                                                                       reuseIdentifier:kCameraAnnotationIdentifier
                                                                               mapView:self.mapView];
        }
        return _cameraAnnotationView;
    }
    
    if ([annotation isKindOfClass:[PDPhotoLocationAnnotation class]]) {
        PDPhotoLocationAnnotation *photoAnnotation = (PDPhotoLocationAnnotation *) annotation;
        
        PDPhotoLocationView *locationView = (PDPhotoLocationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"PDPhotoLocationView"];
        if (!locationView) {
            locationView = [[PDPhotoLocationView alloc] initWithAnnotation:photoAnnotation reuseIdentifier:@"PDPhotoLocationView"];
        }
        
        locationView.photoViewDelegate = _photoViewDelegate;
        locationView.photo = photoAnnotation.photo;
        return locationView;
    }
    if ([annotation isKindOfClass:[PDPlanAnnotaion class]]) {
        PDPlanAnnotaion *planAnnotation = (PDPlanAnnotaion *) annotation;
        PDPlanAnnotaionView *planAnnotationView = (PDPlanAnnotaionView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"PlanAnnotationView"];
        if (!planAnnotationView) {
            planAnnotationView = [[PDPlanAnnotaionView alloc] initWithAnnotation:planAnnotation reuseIdentifier:@"PlanAnnotationView" withImage:self.planImage];
        }
        
        return planAnnotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
    if (mode == MKUserTrackingModeFollowWithHeading) {
        [[PDLocationHelper sharedInstance] updateHeading];
    } else {
        [[PDLocationHelper sharedInstance] stopUpdateHeading];
    }
    if (mode == MKUserTrackingModeNone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDSetUserTrackingModeNone object:nil];

        self.mapView.showsUserLocation = NO;
        [self.mapView bringSubviewToFront:_pinAnnotationView];
    }
    NSNumber *state = [NSNumber numberWithInt:mode];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDUserTrackingModeChangedNotification object:state];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKAnnotationView *anView in views) {
        if ([anView.annotation isKindOfClass:[MapPinAnnotation class]]) {
            anView.layer.zPosition = 4.0;
        } else if ([anView.annotation isKindOfClass:[CameraAnnotation class]]) {
            anView.layer.zPosition = 3.0;
        } else if ([anView.annotation isKindOfClass:[SunMoonAnnotation class]]) {
            anView.layer.zPosition = 2.0;
        } else {
            anView.layer.zPosition = 1.0;
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(mapViewRegionDidChanged) object:nil];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self mapViewRegionDidChanged];
	});
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{

    MKOverlayView *overlayView = nil;
    if (overlay == self.polyLine) {
        self.polyLineView = [[MKPolylineView alloc] initWithPolyline:self.polyLine];
        self.polyLineView.lineWidth = 4.0;
        self.polyLineView.strokeColor = [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:1.0];
        self.polyLineView.fillColor = [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:1.0];
        overlayView = self.polyLineView;
    }
    return overlayView;
}

#pragma - mark Notification

- (void) didToucheBeganAnnotation
{
    
    self.tapToMapPin = YES;
    if (_polyLine) {
        [self.mapView removeOverlay:_polyLine];
        self.polyLine = nil;
    }
}

- (void) didToucheEndMapPinAnnotation
{
    self.tapToMapPin = NO;
    if (_cameraAnnotation && [self isCoordinate2DValid:self.youCoord]) {
        CLLocationCoordinate2D *plotLocation = malloc(sizeof(CLLocationCoordinate2D) * 2);
        plotLocation[0] = self.youCoord;
        plotLocation[1] = self.sunMoonCoord;
        self.polyLine = [MKPolyline polylineWithCoordinates:plotLocation count:2];
        if (self.polyLine) {
            [self.mapView addOverlay:_polyLine];
        }
        free(plotLocation);
    }
    
}

- (void )didToucheEndAnnotation{
    self.tapToMapPin = NO;
    CLLocationCoordinate2D *plotLocation = malloc(sizeof(CLLocationCoordinate2D) * 2);
    plotLocation[0] = self.youCoord;
    plotLocation[1] = self.sunMoonCoord;
    self.polyLine = [MKPolyline polylineWithCoordinates:plotLocation count:2];
    if (self.polyLine) {
        [self.mapView addOverlay:_polyLine];
    }
    free(plotLocation);
    
}

- (void)pinAnnotationDidChange:(NSNotification *)notification
{
    CLLocation *newLocation = [notification object];
    if ([self isCoordinate2DValid:newLocation.coordinate]) {
        self.sunMoonCoord = newLocation.coordinate;
        self.pinAnnotation.coordinate = newLocation.coordinate;
        self.sunMoonAnnotation.coordinate = newLocation.coordinate;
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDUpdateSunMoonAnnotationNotification object:newLocation];
    }
}

- (void)didUpdateSunMoonShowOptions:(NSNotification *)notification
{
    if (self.sunMoonAnnotation) {
        UIButton *btnClicked = [notification object];
        switch (btnClicked.tag) {
            case 0:
                self.sunMoonAnnotation.isHiddenSunRise = !btnClicked.selected;
                [kPDUserDefaults setBool:!btnClicked.selected forKey:kPDSunRiseHiddenKey];
                break;
            case 1:
                self.sunMoonAnnotation.isHiddenSunSet = !btnClicked.selected;
                [kPDUserDefaults setBool:!btnClicked.selected forKey:kPDSunSetHiddenKey];
                break;
            case 2:
                self.sunMoonAnnotation.isHiddenMoonRise = !btnClicked.selected;
                [kPDUserDefaults setBool:!btnClicked.selected forKey:kPDMoonRiseHiddenKey];
                break;
            case 3:
                self.sunMoonAnnotation.isHiddenMoonSet = !btnClicked.selected;
                [kPDUserDefaults setBool:!btnClicked.selected forKey:kPDMoonSetHiddenKey];
                break;
            default:
                break;
        }
        [self.mapView removeAnnotation:self.sunMoonAnnotation];
        [self.mapView addAnnotation:self.sunMoonAnnotation];
    }
}

- (void)didUpdateSunMoonDateTimeOptions:(NSNotification *)notification
{
    self.sunMoonDate = (NSDate *)[notification object];
}

- (void)didUpdatePointYou:(NSNotification *)notification
{
    CLLocation *newLocation = [notification object];
    if ([self isCoordinate2DValid:newLocation.coordinate] &&
        [self isCoordinate2DValid:self.sunMoonCoord]) {
        self.youCoord = newLocation.coordinate;
        self.cameraAnnotation.coordinate = self.youCoord;
    }
}

- (void)plotRouteOnMap:(CLLocationCoordinate2D )lastLocation atCurrent2DLocation:(CLLocationCoordinate2D )currentLocation {
    
    if (_polyLine) {
        [self.mapView removeOverlay:_polyLine];
        self.polyLine = nil;
    }
    CLLocationCoordinate2D *plotLocation = malloc(sizeof(CLLocationCoordinate2D) * 2);
    plotLocation[0] = lastLocation;
    plotLocation[1] = currentLocation;
    self.polyLine = [MKPolyline polylineWithCoordinates:plotLocation count:2];
    if (self.polyLine) {
        [self.mapView addOverlay:_polyLine];
    }
    free(plotLocation);
}

- (void)didTapMap:(UIGestureRecognizer *)recognizer
{
    if (self.tapToMapPin == NO) {
        CGPoint touchPoint = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D newCoord = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        [self addPointYouWithCoordinate:newCoord];
    }
}

- (void)mapViewRegionDidChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDMapViewRegionDidChangeNotification object:nil];
}

@end
