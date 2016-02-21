//
//  PDLocationHelper.m
//  Pashadelic
//
//  Created by TungNT2 on 3/14/14.
//
//

#import "PDLocationHelper.h"

@implementation PDLocationHelper

#pragma mark - Utilities

- (CLRegion *)convertMapRegion:(MKCoordinateRegion)region
{
	CLLocation *regionEnd = [[CLLocation alloc] initWithLatitude:region.span.latitudeDelta + region.center.latitude
                                                       longitude:region.span.longitudeDelta + region.center.longitude];
	CLLocation *center = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
	CLLocationDistance distance = [center distanceFromLocation:regionEnd];
    
    CLCircularRegion *regionObject = [[CLCircularRegion alloc] initWithCenter:region.center radius:distance identifier:@"mapRegion"];
    return regionObject;
}

- (MKCoordinateRegion)regionForMax:(CLLocationCoordinate2D)maxPosition andMinPosition:(CLLocationCoordinate2D)minPosition
{
	MKCoordinateSpan span;
	CLLocationCoordinate2D center;
	center = CLLocationCoordinate2DMake((maxPosition.latitude + minPosition.latitude) / 2,
                                        (maxPosition.longitude + minPosition.longitude) / 2);
	if (center.latitude < -90 || center.latitude > 90 || center.longitude < -180 || center.longitude > 180) {
		center = CLLocationCoordinate2DMake(0, 0);
		span.latitudeDelta = 89;
		span.longitudeDelta = 179;
	} else {
		span.latitudeDelta = ABS(maxPosition.latitude - minPosition.latitude) * 1.05;
		span.longitudeDelta = ABS(maxPosition.longitude - minPosition.longitude) * 1.05;
		span.latitudeDelta = MAX(MIN(90, span.latitudeDelta), 0.01);
		span.longitudeDelta = MAX(MIN(180, span.longitudeDelta), 0.01);
	}
	MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
	return region;
}

- (double)distanceToLatitude:(double)latitude longitude:(double)longitude
{
	if (!self.isLocationReceived) return -1;
	if (latitude == 0 && longitude == 0) return -1;
	if (self.latitudes == 0 && self.longitudes == 0) return -1;
	
	double lat1  = M_PI * self.latitudes / 180;
	double lon1  = M_PI * self.longitudes / 180;
	
	double lat2  = M_PI * latitude / 180;
	double lon2  = M_PI * longitude / 180;
	
	double earthRadius = 3958.75;
	double dLat = lat2-lat1;
	double dLon = lon2-lon1;
	double a = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
	double c = 2 * atan2(sqrt(a), sqrt(1-a));
	double distance = earthRadius * c;
	double meterConversion = 1609.00;
	return distance * meterConversion;
}

- (NSString *)latitudeStringValue
{
	return [@(self.location.coordinate.latitude) stringValue];
}

- (NSString *)longitudeStringValue
{
	return [@(self.location.coordinate.longitude) stringValue];
}

- (double)latitudes
{
	return self.location.coordinate.latitude;
}

- (double)longitudes
{
	return self.location.coordinate.longitude;
}

- (CLLocationCoordinate2D)coordinates
{
    return self.location.coordinate;
}

@end
