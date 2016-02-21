//
//  PDLandmarkAnnotation.m
//  Pashadelic
//
//  Created by LTT on 6/19/14.
//
//

#import "PDLandmarkAnnotation.h"

@implementation PDLandmarkAnnotation

- (id)initWithLocation:(CLLocationCoordinate2D)location
{
    self = [super init];
    if (self) {
        _coordinate = location;
        _title = nil;
    }
    return self;
}

- (MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"LandmarkAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    return annotationView;
}

- (void)setLocation:(PDLocation *)location
{
    _location = location;
    [self setCoordinate:CLLocationCoordinate2DMake(location.latitude, location.longitude)];
}

@end
