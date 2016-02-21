//
//  LTTMotionHelper.m
//  Pashadelic
//
//  Created by TungNT2 on 4/1/14.
//
//

#import "LTTMotionHelper.h"

@interface LTTMotionHelper ()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) LTTMotionHelperCompletion completionBlock;
@property (nonatomic, strong) NSTimer *timer;
- (void)checkTrueNorth;
- (void)updateMotion;
@end

@implementation LTTMotionHelper
@synthesize motionManager, deviceMotion, completionBlock, timer;

- (id)init
{
    self = [super init];
    if (self) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 1.0 / 30.0;
    }
    return self;
}

- (void)updateDeviceMotion:(LTTMotionHelperCompletion)completion
{
    [self stopUpdateDeviceMotion];
    self.completionBlock = completion;
    if ([motionManager isDeviceMotionAvailable]) {
        // Reference frame in which the Z axis is vertical and the X axis points toward magnetic north.
        //Note that using this reference frame may require device movement to calibrate the magnetometer.

        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 30.0
                                                 target:self
                                               selector:@selector(updateMotion)
                                               userInfo:nil
                                                repeats:YES];
        [self performSelector:@selector(checkTrueNorth) withObject:nil afterDelay:1.5];
    } else {
        deviceMotion = nil;
        NSMutableDictionary *errorInfo = [NSMutableDictionary dictionary];
        [errorInfo setValue:NSLocalizedString(@"Device Motion Not Available", nil) forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:errorInfo];
        self.completionBlock(error, nil);
    }
    
}

- (void)checkTrueNorth
{
    if (motionManager.deviceMotion == nil) {
        [self stopUpdateDeviceMotion];
        [motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 / 30.0
                                                 target:self
                                               selector:@selector(updateMotion)
                                               userInfo:nil
                                                repeats:YES];
    }
}

- (void)updateMotion
{
    if (motionManager.deviceMotion) {
        deviceMotion = self.motionManager.deviceMotion;
        self.completionBlock(nil, deviceMotion);
    }
}

- (void)stopUpdateDeviceMotion
{
    [timer invalidate];
    timer = nil;
    if (motionManager.isDeviceMotionAvailable && motionManager.isDeviceMotionActive) {
        [motionManager stopDeviceMotionUpdates];
    }
}

@end
