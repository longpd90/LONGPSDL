//
//  PDARView.h
//  Pashadelic
//
//  Created by LongPD on 2/6/14.
//
//

#import <UIKit/UIKit.h>
#import "PDARAlgorithm.h"

@interface PDARView : UIView
{
	CMMotionManager *motionManager;
    CMRotationMatrix rotationMatrix;
    mat4f_t projectionCameraTransform;
	mat4f_t projectionTransform;
	mat4f_t cameraTransform;
    vec4f_t *placeOfGridCoordinate;
	vec4f_t *placeOfSunCoordinate;
    vec4f_t *placeOfMoonCoordinate;
    vec4f_t *placeOfNowCoordinate;
    vec4f_t *placeOfBlueFirstCoordinate;
    vec4f_t *placeOfBlueSecondCoordinate;
    vec4f_t *placeOfGoldenFirstCoordinate;
    vec4f_t *placeOfGoldenSecondCoordinate;
    vec4f_t *placeOfOverlayEquatorPoints;
}

@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSMutableArray *gridPoints;
@property (strong, nonatomic) NSMutableArray *sunPoints;
@property (strong, nonatomic) NSMutableArray *moonPoints;
@property (strong, nonatomic) NSMutableArray *nowPoints;
@property (strong, nonatomic) NSMutableArray *goldenHourFirstPoints;
@property (strong, nonatomic) NSMutableArray *goldenHourSecondPoints;
@property (strong, nonatomic) NSMutableArray *blueHourFirstPoints;
@property (strong, nonatomic) NSMutableArray *blueHourSecondPoints;
@property (strong, nonatomic) NSMutableArray *overlayEquatorPoints;
@property CGPoint tempPoint;

- (void)startRunning;
- (void)stopRunning;
- (void)initialize;
- (void)updatePlacesOfPointCoordinates;
- (void)refresh;
- (void)hiddenSun:(BOOL )hidden;
- (void)hiddenMoon:(BOOL )hidden;
- (void)updateNowOfPointCoordinates;
- (void)refreshNow;
- (void)updateARViewWithLatitude:(double)latitude longitude:(double)longitude;

@end
