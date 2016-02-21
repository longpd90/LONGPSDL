#import "MGLocationHelper.h"


@implementation MGLocationHelper
@synthesize locationManager, isLocationReceived, coordinates, errorCode;

static MGLocationHelper *_instance;
+ (MGLocationHelper *)sharedInstance
{
	@synchronized(self) {
		
    if (_instance == nil) {
      _instance = [[super alloc] init];
    }
  }
  return _instance;
}

- (id) init
{
	self = [super init];
	
	if (self) {
		isLocationReceived = NO;
		self.accuracy = kCLLocationAccuracyBest;
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
	}
	return self;
}


#pragma mark Public Methods

- (void)stopUpdatingLocation
{
	[locationManager stopUpdatingLocation];
	isLocationReceived = NO;
}

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

- (void) updateLocation
{
	if (locationManager.desiredAccuracy != self.accuracy) {
		[locationManager setDesiredAccuracy:self.accuracy];
	}
	[locationManager startUpdatingLocation];
}

- (double)distanceToLatitude:(double)latitude longitude:(double)longitude
{
	if (!isLocationReceived) return -1;
	if (latitude == 0 && longitude == 0) return -1;
	if (self.latitude == 0 && self.longitude == 0) return -1;
	
	double lat1  = M_PI * coordinates.latitude / 180;
	double lon1  = M_PI * coordinates.longitude / 180;
	
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
	return [@(coordinates.latitude) stringValue];
}

- (NSString *)longitudeStringValue
{
	return [@(coordinates.longitude) stringValue];
}

- (double)latitude
{
	return coordinates.latitude;
}

- (double)longitude
{
	return coordinates.longitude;
}


#pragma mark CLLocationManagerDelegate

- (void)updateHeading
{
  if ([CLLocationManager headingAvailable]) {
    locationManager.headingFilter = 5;
    [locationManager startUpdatingHeading];
  }
}

- (void)stopUpdatingHeading
{
  [locationManager stopUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
  if (newHeading.headingAccuracy < 0) return;
  CLLocationDirection theHeading = ((newHeading.trueHeading > 0) ?
                                    newHeading.trueHeading : newHeading.magneticHeading);
  float oldRad = -manager.heading.trueHeading * M_PI / 180.0f;
  float newRad = -theHeading * M_PI / 180.0f;
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  [userInfo setValue:[NSNumber numberWithFloat:oldRad] forKey:@"oldRad"];
  [userInfo setValue:[NSNumber numberWithFloat:newRad] forKey:@"newRad"];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"didUpdateHeading" object:nil userInfo:userInfo];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	isLocationReceived = NO;
	errorCode = [error code];
	[[NSNotificationCenter defaultCenter] postNotificationName:MGLocationReceiveDidFailNotification
                                                      object:self
                                                    userInfo:@{@"error" : error}];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	coordinates = newLocation.coordinate;
	isLocationReceived = YES;
	NSDictionary *parameters = [NSDictionary dictionaryWithObject:newLocation forKey:@"location"];
	[[NSNotificationCenter defaultCenter] postNotificationName:MGLocationChangedNotification object:self userInfo:parameters];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	CLLocation *newLocation = [locations lastObject];
	coordinates = newLocation.coordinate;
	isLocationReceived = YES;
	NSDictionary *parameters = [NSDictionary dictionaryWithObject:newLocation forKey:@"location"];
	[[NSNotificationCenter defaultCenter] postNotificationName:MGLocationChangedNotification object:self userInfo:parameters];
}


@end
