
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define MGLocationChangedNotification			@"MGLocationChangedNotification"
#define MGLocationReceiveDidFailNotification	@"MGLocationReceiveDidFailNotification"

@interface MGLocationHelper : NSObject 
<CLLocationManagerDelegate > 
{
	CLLocationManager		*locationManager;
}

@property (nonatomic) NSInteger errorCode;
@property (nonatomic, strong)	CLLocationManager		*locationManager; 
@property (nonatomic, readonly) CLLocationCoordinate2D	coordinates;
@property (nonatomic, readonly) BOOL isLocationReceived;
@property (assign, nonatomic) CLLocationAccuracy accuracy;

+ (MGLocationHelper *)sharedInstance;
- (void)updateLocation;
- (void)stopUpdatingLocation;
- (double)distanceToLatitude:(double)latitude longitude:(double)longitude;
- (NSString *)latitudeStringValue;
- (NSString *)longitudeStringValue;
- (double)latitude;
- (double)longitude;
- (MKCoordinateRegion) regionForMax:(CLLocationCoordinate2D)maxPosition andMinPosition:(CLLocationCoordinate2D) minPosition;
- (CLRegion *)convertMapRegion:(MKCoordinateRegion)region;
- (void)updateHeading;
- (void)stopUpdatingHeading;

@end
