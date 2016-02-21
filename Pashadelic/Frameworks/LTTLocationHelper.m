//
//  LTTLocationHelper.m
//  Pashadelic
//
//  Created by TungNT2 on 3/19/14.
//
//

#import "LTTLocationHelper.h"

@interface LTTLocationHelper ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) LTTLocationHelperCompletion completionBlock;

@property (nonatomic, assign) NSInteger attempt;
@property (nonatomic, assign, getter = isScoping) BOOL scoping;
@property (nonatomic, assign) CLLocationAccuracy accuracy;

@property (nonatomic, assign) NSInteger maximumWaitTime;
@property (nonatomic, assign) NSInteger maximumAttempts;

@property (nonatomic, strong) CLLocation *bestEffortAtLocation;
@property (nonatomic, assign) float desiredLocationFreshness;

@property (nonatomic, strong, readwrite) CLLocation *location;

- (BOOL)isLocationServicesAvaiable;
- (BOOL)checkTimeStampsLocation:(CLLocation *)checkLocation;
- (BOOL)isNeedToUpdateLocation;
@end

@implementation LTTLocationHelper
@synthesize locationManager, desiredLocationFreshness, location, isLocationReceived;

#pragma mark - Private

- (id)init
{
	self = [super init];
    if (self) {
        isLocationReceived = NO;
        desiredLocationFreshness = 15.0;
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	}
	return self;
}

- (BOOL)isLocationServicesAvaiable
{
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
        return YES;
    else
        return NO;
}

- (BOOL)checkTimeStampsLocation:(CLLocation *)checkLocation
{
    NSDate *eventDate = checkLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < desiredLocationFreshness)
        return YES;
    else
        return NO;
}

#pragma mark - Public

- (BOOL)isNeedToUpdateLocation
{
    if (location && [self checkTimeStampsLocation:location])
        return NO;
    else
        return YES;
}

- (void)updateLocation:(LTTLocationHelperCompletion)completion
{
    if (![self isNeedToUpdateLocation]) return;
    if ([self isLocationServicesAvaiable])
        [self updateLocationWithAccuracy:25
                         maximumWaitTime:5
                         maximumAttempts:5
                            onCompletion:completion];
    else {
        self.completionBlock = completion;
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"Enable location service for Pashadelic.\nImprove your experience on pashadelic and find photo-spots close to you!", nil) code:kCLErrorDenied userInfo:nil];
        if (self.completionBlock)
            self.completionBlock(error, nil);
    }
}

- (void)updateLocationWithAccuracy:(CLLocationAccuracy)acceptableAccuarcy
                   maximumWaitTime:(NSTimeInterval)maximumWaitTime
                   maximumAttempts:(NSInteger)maximumAttempts
                      onCompletion:(LTTLocationHelperCompletion)completion
{
    [self.locationManager stopUpdatingLocation];
    
    self.completionBlock = completion;
    self.attempt = 0;
    self.bestEffortAtLocation = nil;
    self.scoping = YES;
    self.accuracy = acceptableAccuarcy;
    self.maximumAttempts = maximumAttempts;
    self.maximumWaitTime = maximumWaitTime;
    
    [self performSelector:@selector(stopUpdatingLocationWithBestResult) withObject:nil afterDelay:15.0];
    [self.locationManager startUpdatingLocation];
}

- (void)updateHeading
{
    if ([CLLocationManager headingAvailable]) {
        locationManager.headingFilter = 5;
        [locationManager startUpdatingHeading];
    }
}

#pragma mark - Privagte

- (void)cancelPerformStopUpdatingLocationWithBestResult
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocationWithBestResult) object:nil];
}

- (void)stopUpdatingLocationWithBestResult
{
    if (!self.scoping) {
        return;
    }
    self.scoping = NO;
	[locationManager stopUpdatingLocation];
    [self cancelPerformStopUpdatingLocationWithBestResult];
    
    if (!self.bestEffortAtLocation) return;
    location = self.bestEffortAtLocation;
    if (self.completionBlock) {
        self.completionBlock(nil, self.bestEffortAtLocation);
    }
}

- (void)updateLocationTimeOut
{
    if (!self.scoping) {
        return;
    }
    self.scoping = NO;
    isLocationReceived = NO;
    [locationManager stopUpdatingLocation];
    location = self.bestEffortAtLocation = nil;
    [[PDSingleErrorAlertView instance] showErrorMessage:NSLocalizedString(@"Cannot determinate location, please try again later", nil)];
}

- (void)stopUpdateHeading
{
    [locationManager stopUpdatingHeading];
}

#pragma mark - CLLocationManager delegate

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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	CLLocation *newLocation = [locations lastObject];
    if (newLocation.horizontalAccuracy < 0) return;
    
    NSDate *eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < desiredLocationFreshness) {
        self.attempt++;
        if (self.attempt >= self.maximumAttempts) {
            [self stopUpdatingLocationWithBestResult];
            return;
        }
        if ((self.bestEffortAtLocation == nil) || (newLocation.horizontalAccuracy < self.bestEffortAtLocation.horizontalAccuracy)) {
            self.bestEffortAtLocation = newLocation;
            isLocationReceived = YES;
            // we have our result
            if (self.bestEffortAtLocation.horizontalAccuracy <= self.accuracy) {
                [self stopUpdatingLocationWithBestResult];
            } else {
                
                [self cancelPerformStopUpdatingLocationWithBestResult];
                [self performSelector:@selector(stopUpdatingLocationWithBestResult) withObject:nil afterDelay:self.maximumWaitTime];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (!self.scoping) {
        return;
    }
    self.scoping = NO;
    isLocationReceived = NO;
    [self.locationManager stopUpdatingLocation];
    [self cancelPerformStopUpdatingLocationWithBestResult];
    
    if (self.completionBlock) {
        self.completionBlock(error, nil);
    }
}

@end
