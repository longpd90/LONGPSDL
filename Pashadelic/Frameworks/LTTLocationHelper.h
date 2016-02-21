//
//  LTTLocationHelper.h
//  Pashadelic
//
//  Created by TungNT2 on 3/19/14.
//
//

#import "LTTSingleton.h"
#import <CoreLocation/CoreLocation.h>

#define LTTLocationChangedNotification          @"LTTLocationChangedNotification"

typedef void (^LTTLocationHelperCompletion)(NSError *error, CLLocation *location);

@interface LTTLocationHelper : LTTSingleton <CLLocationManagerDelegate>

@property (nonatomic, strong, readonly) CLLocation *location;
@property (nonatomic, assign, readonly) BOOL isLocationReceived;

- (void)updateLocation:(LTTLocationHelperCompletion)completion;
- (void)updateLocationWithAccuracy:(CLLocationAccuracy)acceptableAccuarcy
                   maximumWaitTime:(NSTimeInterval)maximumWaitTime
                   maximumAttempts:(NSInteger)maximumAttempts
                      onCompletion:(LTTLocationHelperCompletion)completion;

- (void)updateHeading;
- (void)stopUpdateHeading;

@end
