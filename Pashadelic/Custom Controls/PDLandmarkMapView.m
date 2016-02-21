//
//  PDLandmarkMapView.m
//  Pashadelic
//
//  Created by TungNT2 on 6/21/14.
//
//

#import "PDLandmarkMapView.h"
#import "PDLocation.h"
#import "PDLandmarkAnnotation.h"
#import "PDLandmarkAnnotationCalloutView.h"

@implementation PDLandmarkMapView

- (void)removeLandmarkAnnotation
{
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[PDLandmarkAnnotation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
}

- (void)reloadMap
{
    [self removeLandmarkAnnotation];
	CLLocationCoordinate2D maxPosition = CLLocationCoordinate2DMake(-90, -180);
	CLLocationCoordinate2D minPosition = CLLocationCoordinate2DMake(90, 180);
	
	for (NSInteger i = 0; i < self.items.count; i++) {
		id item = [self.items objectAtIndex:i];
		if (![item isKindOfClass:[PDLocation class]]) continue;
		PDLocation *location = [self.items objectAtIndex:i];
		if (location.latitude == 0 && location.longitude == 0) continue;
		PDLandmarkAnnotation *landmarkAnnotation = [[PDLandmarkAnnotation alloc] init];
		landmarkAnnotation.location = location;
		[self.mapView addAnnotation:landmarkAnnotation];
		
		maxPosition.latitude = MAX(maxPosition.latitude, location.latitude);
		maxPosition.longitude = MAX(maxPosition.longitude, location.longitude);
		minPosition.latitude = MIN(minPosition.latitude, location.latitude);
		minPosition.longitude = MIN(minPosition.longitude, location.longitude);
	}
	self.mapView.region = [[PDLocationHelper sharedInstance] regionForMax:maxPosition andMinPosition:minPosition];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[PDLandmarkAnnotation class]]) {
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"LandmarkAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LandmarkAnnotation"];
            annotationView.image = [UIImage imageNamed:@"landmark-annotation.png"];
        } else
            annotationView.annotation = annotation;
        return annotationView;
    } else
        return [super mapView:mapView viewForAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if([view.annotation isKindOfClass:[PDLandmarkAnnotation class]]) {
        PDLandmarkAnnotationCalloutView *calloutView = [PDLandmarkAnnotationCalloutView loadFromNibNamed:@"PDLandmarkAnnotationCalloutView"];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        PDLandmarkAnnotation *landmarkAnnotation = (PDLandmarkAnnotation *)view.annotation;
        calloutView.location = landmarkAnnotation.location;
        [view addSubview:calloutView];
        [view bringSubviewToFront:calloutView];
    } else
        [super mapView:mapView didSelectAnnotationView:view];
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[PDLandmarkAnnotation class]]) {
        for (UIView *subview in view.subviews ){
            [subview removeFromSuperview];
        }
    }
}

@end
