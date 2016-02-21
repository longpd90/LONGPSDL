//
//  LTTMotionHelper.h
//  Pashadelic
//
//  Created by TungNT2 on 4/1/14.
//
//

#import "LTTSingleton.h"
#import <CoreMotion/CoreMotion.h>

typedef void (^LTTMotionHelperCompletion)(NSError *error, CMDeviceMotion *deviceMotion);

@interface LTTMotionHelper : LTTSingleton

@property (strong, nonatomic, readonly) CMDeviceMotion *deviceMotion;

- (void)updateDeviceMotion:(LTTMotionHelperCompletion)completion;
- (void)stopUpdateDeviceMotion;
@end
