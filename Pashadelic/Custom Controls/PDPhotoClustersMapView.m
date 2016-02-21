//
//  PDPhotoClustersMapView.m
//  Pashadelic
//
//  Created by TungNT2 on 12/26/13.
//
//

#import "PDPhotoClustersMapView.h"

#define MERCATOR_OFFSET     268435456
#define MERCATOR_RADIUS     85445659.44705395
#define MAX_GOOGLE_LEVELS   20
#define MAXSPAN             110

@interface PDPhotoClustersMapView ()
@end
@implementation PDPhotoClustersMapView

- (void)initialize
{
    [super initialize];
}

- (void)changeRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
                            radius:(double)radius
                          animated:(BOOL)animated
{
		if (!CLLocationCoordinate2DIsValid(coordinate)) {
			coordinate = CLLocationCoordinate2DMake(0, 0);
		}
    MKCoordinateRegion region = [self validRegion:coordinate withRadius:radius];
    [self.mapView setRegion:region animated:animated];
}

#pragma mark - MapView Utilities

- (MKCoordinateRegion )validRegion:(CLLocationCoordinate2D )centerRegion withRadius:(float )radius
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerRegion, radius * 2.5, radius * 2.5);
    if (region.span.latitudeDelta > MAXSPAN) {
        region.span.latitudeDelta = MAXSPAN;
    }
    if (region.span.longitudeDelta > MAXSPAN) {
        region.span.longitudeDelta = MAXSPAN;
    }
    return region;
}

- (CLLocationCoordinate2D)centerCoordinate
{
    double longitude = self.mapView.centerCoordinate.longitude;
    double latitude = self.mapView.centerCoordinate.latitude;
    return CLLocationCoordinate2DMake(latitude, longitude);
}

- (double)getZoomLevelFromMapView:(MKMapView *)mapView {
    MKCoordinateRegion reg = mapView.region; // the current visible region
    MKCoordinateSpan span = reg.span; // the deltas
    CLLocationCoordinate2D centerCoordinate=reg.center; // the center in degrees
    // Get the left and right most lonitudes
    CLLocationDegrees leftLongitude = (centerCoordinate.longitude-(span.longitudeDelta/2));
    CLLocationDegrees rightLongitude = (centerCoordinate.longitude+(span.longitudeDelta/2));
    CGSize mapSizeInPixels = self.superview.bounds.size; // the size of the display window
    
    // Get the left and right side of the screen in fully zoomed-in pixels
    double leftPixel = [self longitudeToPixelSpaceX:leftLongitude];
    double rightPixel = [self longitudeToPixelSpaceX:rightLongitude];
    // The span of the screen width in fully zoomed-in pixels
    double pixelDelta = abs(rightPixel-leftPixel);
    
    // The ratio of the pixels to what we're actually showing
    double zoomScale = mapSizeInPixels.width /pixelDelta;
    // Inverse exponent
    double zoomExponent = log2(zoomScale);
    // Adjust our scale
    double zoomLevel = zoomExponent + 20;
    return zoomLevel;
}

#pragma mark - Map conversion methods

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    if (latitude == 90.0) {
        return 0;
    } else if (latitude == -90.0) {
        return MERCATOR_OFFSET * 2;
    } else {
        return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
    }
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

@end
