//
//  PDLocationHelper.h
//  Pashadelic
//
//  Created by TungNT2 on 3/14/14.
//
//

#import "LTTLocationHelper.h"

@interface PDLocationHelper : LTTLocationHelper

- (double)distanceToLatitude:(double)latitude longitude:(double)longitude;
- (NSString *)latitudeStringValue;
- (NSString *)longitudeStringValue;
- (double)latitudes;
- (double)longitudes;
- (CLLocationCoordinate2D)coordinates;
- (MKCoordinateRegion) regionForMax:(CLLocationCoordinate2D)maxPosition andMinPosition:(CLLocationCoordinate2D) minPosition;
- (CLRegion *)convertMapRegion:(MKCoordinateRegion)region;

@end
