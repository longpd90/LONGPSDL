//
//  ExampleAnnotation.m
//  CustomCallout
//
//  Created by Jacob Jennings on 9/8/11.
//
//  This is my solution to the SO question "MKAnnotationView - Lock custom annotation view to pin on location updates":
//  http://stackoverflow.com/questions/6392931/mkannotationview-lock-custom-annotation-view-to-pin-on-location-updates
//
//  CalloutAnnotationView based on the work at: 
//  http://blog.asolutions.com/2010/09/building-custom-map-annotation-callouts-part-1/
//  
//  The Example* classes represent things you will probably change in your own project to fit your needs.  Consider CalloutAnnotationView abstract - it must be subclassed (here it's subclass is ExampleCalloutView), and linked with a xib connecting the IBOutlet for contentView.  The callout should resize to fit whatever view you supply as contentView.  

#import "PDPhotoLocationAnnotation.h"

@implementation PDPhotoLocationAnnotation
@synthesize coordinate, mapView, photo;

- (MKAnnotationView*)annotationViewInMap:(MKMapView*) aMapView;
{
    if (!locationView) {
        locationView = (PDPhotoLocationView *) [aMapView dequeueReusableAnnotationViewWithIdentifier:@"PDPhotoLocationView"];
        if (!locationView)
            locationView = [[PDPhotoLocationView alloc] initWithAnnotation:self reuseIdentifier:@"PDPhotoLocationView"];
    } else
        locationView.annotation = self;
	locationView.photo = photo;
    return locationView;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
    [self.mapView addAnnotation:self];
    if (locationView) {		
        [locationView setAnnotation:self];
    }
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

- (void)setPhoto:(PDPhoto *)newPhoto
{
	photo = newPhoto;
	
	[self setCoordinate:CLLocationCoordinate2DMake(photo.latitude, photo.longitude)];
}

- (NSString *)title
{
	return @" ";
}

- (NSString *)subtitle
{
	return @" ";
}

@end