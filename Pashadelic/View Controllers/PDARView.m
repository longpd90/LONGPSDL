//
//  PDARView.m
//  Pashadelic
//
//  Created by LongPD on 2/6/14.
//
//

#import "PDARView.h"
#import "SunMoonCalcGobal.h"
#import "SunPosition.h"
#import "MoonPosition.h"
#import "PDARSunMoonView.h"
#import <AVFoundation/AVFoundation.h>
#import "LTTMotionHelper.h"

#define kLTTARMoonColor      [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0]
#define kLTTARSunColor       [UIColor colorWithRed:255/255.0 green:100/255.0 blue:0 alpha:1.0]
#define kLTTARGoldenColor    [UIColor colorWithRed:200/255.0 green:200/255.0 blue:0 alpha:1]
#define kLTTARBlueColor      [UIColor colorWithRed:51.0/255 green:102.0/255 blue:1 alpha:1]
#define kLTTAROverlayBlueColor   [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:0.5]
#define kLTTAROverlayGoldenColor [UIColor colorWithRed:255/255.0 green:200/255.0 blue:50/255 alpha:0.5]
#define kLTTNumberOfPointsInLong 36
#define kLTTNumberOfPointsInLat 24
#define kLTTNumberOfHourInDay 24
#define kLTTFullRotationInDegree 360
#define kLTTNumberOfSubPoint 3
#define kLTTSecondsInHour 3600
#define kLTTSecondsInMin 60

@interface PDARView ()

@property (nonatomic, strong) SunMoonCalcGobal *sunMoonCal;
@property (nonatomic, assign) BOOL isHiddenSunPath;
@property (nonatomic, assign) BOOL isHiddenMoonPath;
@property (nonatomic, assign) BOOL isHiddenGoldenOverlay;
@property (nonatomic, assign) BOOL isHiddenBludeOverlay;
@property (nonatomic, strong) UIColor *gridColor;
@property (nonatomic, strong) CMDeviceMotion *deviceMotion;
@end

@implementation PDARView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)startRunning
{
    [[LTTMotionHelper sharedInstance] updateDeviceMotion:^(NSError *error, CMDeviceMotion *deviceMotion){
        if (error) {
					[UIAlertView showAlertWithTitle:nil message:error.localizedDescription];
        } else {
            _deviceMotion = deviceMotion;
            if (_deviceMotion != nil) {
                rotationMatrix = _deviceMotion.attitude.rotationMatrix;
                transformFromCMRotationMatrix(cameraTransform, &rotationMatrix);
                [self setNeedsDisplay];
            }
        }
    }];
}

- (void)stopRunning
{
    [[LTTMotionHelper sharedInstance] stopUpdateDeviceMotion];
}

- (void)dealloc
{
    [[LTTMotionHelper sharedInstance] stopUpdateDeviceMotion];
}

- (void)initialize
{
    self.gridPoints = [[NSMutableArray alloc] init];
    self.sunPoints = [[NSMutableArray alloc] init];
    self.moonPoints = [[NSMutableArray alloc] init];
    self.nowPoints = [[NSMutableArray alloc] init];
    self.blueHourFirstPoints = [[NSMutableArray alloc] init];
    self.blueHourSecondPoints = [[NSMutableArray alloc] init];
    self.goldenHourFirstPoints = [[NSMutableArray alloc] init];
    self.goldenHourSecondPoints = [[NSMutableArray alloc] init];
    self.overlayEquatorPoints = [[NSMutableArray alloc] init];
    self.sunMoonCal = [[SunMoonCalcGobal alloc] init];
    
    _date = [self currentDate];
    self.gridColor = [UIColor colorWithWhite:1 alpha:0.8];
}

- (void)layoutSubviews{
    // creat projection matrix with true frame of ARView.
    createProjectionMatrix(projectionTransform, 60.0f * DEGREES_TO_RADIANS, self.bounds.size.width*1.0f / self.bounds.size.height, 0.25f, 1000.0f);
}

#pragma mark - private

// Update places of point coordinates

- (void)updatePlacesOfPointCoordinates
{
    placeOfGridCoordinate = [self calculateCoordinatePoint:self.gridPoints];
    [self updateNowOfPointCoordinates];
}

// recaculate position of point to draw magicHour point with date
- (void)refreshPointsOfMagicHour:(NSMutableArray *)array withFirstTime:(NSDate *)firstTime secondTime:(NSDate *)secondTime andType:(NSInteger)type
{
    if (array.count > 0) {
        for (int i = 0; i < array.count; i ++) {
            PDARSunMoonView *aRSunmoonView = (PDARSunMoonView *)array[i];
            NSDate *date;
            if (i == 0) {
                date = firstTime;
            } else {
                date = secondTime;
            }
            SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:date andLatitude:_latitude andLongitude:_longitude];
            [aRSunmoonView setAzimuth:sunPosition.azimuth altitude:sunPosition.altitude andTime:date];
        }
    }else{
        for (int i = 0; i < 2; i ++) {
            NSDate *date;
            if (i == 0) {
                date = firstTime;
            } else {
                date = secondTime;
            }
            SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:date andLatitude:_latitude andLongitude:_longitude];
            [self addObjectToArray:array withdate:date azimuth:sunPosition.azimuth altitude:sunPosition.altitude andType:type ];
        }
    }
    
}

// Recaculate position of points, which be used to draw overlay
- (void)refreshPointsToDrawOverlay:(NSMutableArray *)array withFirstTime:(NSDate *)firstTime andSecondTime:(NSDate *)secondTime
{
    if (array.count > 0) {
        for (int i = 0; i < kLTTNumberOfHourInDay; i ++) {
            PDARSunMoonView *aRSunmoonView = (PDARSunMoonView *)array[i];
            SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:firstTime andLatitude:_latitude andLongitude:_longitude];
            [aRSunmoonView setAzimuth:(Radian * i * kLTTFullRotationInDegree/kLTTNumberOfHourInDay) altitude:sunPosition.altitude andTime:firstTime];
        }
        for (int i = kLTTNumberOfHourInDay; i < kLTTNumberOfHourInDay * 2 - 1; i++) {
            PDARSunMoonView *aRSunmoonView = (PDARSunMoonView *)array[i];
            SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:secondTime andLatitude:_latitude andLongitude:_longitude];
            [aRSunmoonView setAzimuth:(Radian * i * kLTTFullRotationInDegree/kLTTNumberOfHourInDay) altitude:sunPosition.altitude andTime:secondTime];
        }
    }
    else{
        SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:firstTime andLatitude:_latitude andLongitude:_longitude];
        for (int i = 0; i < kLTTNumberOfHourInDay; i ++) {
            [self addObjectToArray:array
                          withdate:nil
                           azimuth:(Radian * i * kLTTFullRotationInDegree/kLTTNumberOfHourInDay)
                          altitude:sunPosition.altitude
                           andType:Another];
        }
        sunPosition = [_sunMoonCal getSunPositionWithDate:secondTime andLatitude:_latitude andLongitude:_longitude];
        for (int i = 0; i < kLTTNumberOfHourInDay; i++) {
            [self addObjectToArray:array
                          withdate:nil
                           azimuth:(Radian * i * kLTTFullRotationInDegree/kLTTNumberOfHourInDay)
                          altitude:sunPosition.altitude
                           andType:Another];
        }
    }
}

// called the update time
- (void)refreshNow
{
    int hour = [[_date stringValueFormattedBy:@"HH"] intValue];
    int minute = [[_date stringValueFormattedBy:@"mm"] intValue];
    
    NSDictionary *sunTimes = [_sunMoonCal getSunTimesWithDate:_date andLatitude:_latitude andLogitude:_longitude];
    NSDate *dawn =  [sunTimes objectForKey:@"dawn"];
    NSDate *sunriseTime = [sunTimes objectForKey:@"sunrise"];
    NSDate *sunRiseEndTime = [sunTimes objectForKey:@"sunriseEnd"];
    NSDate *goldenHourEnd = [sunTimes objectForKey:@"goldenHourEnd"];
    NSDate *goldenHour = [sunTimes objectForKey:@"goldenHour"];
    NSDate *sunsetStartTime = [sunTimes objectForKey:@"sunsetStart"];
    NSDate *sunsetTime = [sunTimes objectForKey:@"sunset"];
    NSDate *dusk = [sunTimes objectForKey:@"dusk"];
    
    // initialize or update blue hour points
    [self refreshPointsOfMagicHour:self.blueHourFirstPoints
                     withFirstTime:dawn
                        secondTime:sunriseTime
                           andType:BlueHour];
    [self refreshPointsOfMagicHour:self.blueHourSecondPoints
                     withFirstTime:sunsetTime
                        secondTime:dusk
                           andType:BlueHour];
    
    //  initialize or updategolden hour points
    [self refreshPointsOfMagicHour:self.goldenHourFirstPoints
                     withFirstTime:sunRiseEndTime
                        secondTime:goldenHourEnd
                           andType:GoldenHour];
    [self refreshPointsOfMagicHour:self.goldenHourSecondPoints
                     withFirstTime:goldenHour
                        secondTime:sunsetStartTime
                           andType:GoldenHour];
    
    // initialize or update now points
    if (self.nowPoints.count > 0) {
        for (int i = 0; i < 2; i ++) {
            if (i == 0) {
                PDARSunMoonView *aRSunmoonView = (PDARSunMoonView *)self.nowPoints[i];
                MoonPosition *moonPosition = [_sunMoonCal getMoonPositionWithDate:_date andLatitude:_latitude andLongitude:_longitude];
                [aRSunmoonView setAzimuth:moonPosition.azimuth altitude:moonPosition.altitude andTime:_date];
            } else {
                PDARSunMoonView *aRSunmoonView = (PDARSunMoonView *)self.nowPoints[i];
                SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:_date andLatitude:_latitude andLongitude:_longitude];
                [aRSunmoonView setAzimuth:sunPosition.azimuth altitude:sunPosition.altitude andTime:_date];
            }
        }
    }else{
        for (int i = 0; i < 2; i ++) {
            if (i == 0) {
                MoonPosition *moonPosition = [_sunMoonCal getMoonPositionWithDate:_date andLatitude:_latitude andLongitude:_longitude];
                [self addObjectToArray:self.nowPoints
                              withdate:_date
                               azimuth:moonPosition.azimuth
                              altitude:moonPosition.altitude
                               andType:MoonNow];
            } else {
                SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:_date andLatitude:_latitude andLongitude:_longitude];
                [self addObjectToArray:self.nowPoints
                              withdate:_date
                               azimuth:sunPosition.azimuth
                              altitude:sunPosition.altitude
                               andType:SunNow];
            }
        }
    }
    
    // initialize or update sun & moon points
    if (self.sunPoints.count > 0) {
        for (int i = 0; i < self.sunPoints.count; i ++) {
            PDARSunMoonView *aRSunmoonView = (PDARSunMoonView *)self.sunPoints[i];
            NSDate *date = [NSDate dateWithTimeInterval:(i - hour)*kLTTSecondsInHour - minute * kLTTSecondsInMin sinceDate:_date];
            SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:date andLatitude:_latitude andLongitude:_longitude];
            [aRSunmoonView setAzimuth:sunPosition.azimuth altitude:sunPosition.altitude andTime:date];
        }
    }else{
        for (int i = 0; i < kLTTNumberOfHourInDay; i ++) {
            NSDate *date = [NSDate dateWithTimeInterval:(i - hour)*kLTTSecondsInHour - minute * kLTTSecondsInMin sinceDate:_date];
            SunPosition *sunPosition = [_sunMoonCal getSunPositionWithDate:date andLatitude:_latitude andLongitude:_longitude];
            [self addObjectToArray:self.sunPoints
                          withdate:date
                           azimuth:sunPosition.azimuth
                          altitude:sunPosition.altitude
                           andType:SunPoint];
        }
    }
    
    if (self.moonPoints.count > 0) {
        for (int i = 0; i < self.moonPoints.count; i ++) {
            PDARSunMoonView *aRSunmoonView = (PDARSunMoonView *)self.moonPoints[i];
            NSDate *date = [NSDate dateWithTimeInterval:(i - hour)*kLTTSecondsInHour - minute * kLTTSecondsInMin sinceDate:_date];
            MoonPosition *moonPosition = [_sunMoonCal getMoonPositionWithDate:date andLatitude:_latitude andLongitude:_longitude];
            [aRSunmoonView setAzimuth:moonPosition.azimuth altitude:moonPosition.altitude andTime:date];
        }
    }else{
        for (int i = 0; i < kLTTNumberOfHourInDay + 1; i ++) {
            NSDate *date = [NSDate dateWithTimeInterval:(i - hour)*kLTTSecondsInHour - minute * kLTTSecondsInMin sinceDate:_date];
            MoonPosition *moonPosition = [_sunMoonCal getMoonPositionWithDate:date andLatitude:_latitude andLongitude:_longitude];
            [self addObjectToArray:self.moonPoints
                          withdate:date
                           azimuth:moonPosition.azimuth
                          altitude:moonPosition.altitude
                           andType:MoonPoint];
        }
    }
    
}

- (void)updateNowOfPointCoordinates
{
    placeOfSunCoordinate = [self calculateCoordinatePoint:self.sunPoints];
    placeOfMoonCoordinate = [self calculateCoordinatePoint:self.moonPoints];
    placeOfBlueFirstCoordinate = [self calculateCoordinatePoint:self.blueHourFirstPoints];
    placeOfGoldenFirstCoordinate = [self calculateCoordinatePoint:self.goldenHourFirstPoints];
    placeOfGoldenSecondCoordinate = [self calculateCoordinatePoint:self.goldenHourSecondPoints];
    placeOfBlueSecondCoordinate = [self calculateCoordinatePoint:self.blueHourSecondPoints];
    placeOfNowCoordinate = [self calculateCoordinatePoint:self.nowPoints];    
}

#pragma mark - Draw in view
- (void)drawRect:(CGRect)rect
{
	multiplyMatrixAndMatrix(projectionCameraTransform, projectionTransform, cameraTransform);
    
    // draw gird
    [self drawGridWithGridPointsOfCoordinate:placeOfGridCoordinate];
    
    // draw sun path
    [self drawPath:placeOfSunCoordinate withArray:self.sunPoints color:kLTTARSunColor andHidden:_isHiddenSunPath];
    
    // draw moon path
    [self drawPath:placeOfMoonCoordinate withArray:self.moonPoints color:kLTTARMoonColor andHidden:_isHiddenMoonPath];
    
    // draw blue hour
    [self drawPath:placeOfBlueFirstCoordinate
         withArray:self.blueHourFirstPoints
             color:kLTTARBlueColor
         andHidden:_isHiddenSunPath];
    [self drawPath:placeOfBlueSecondCoordinate
         withArray:self.blueHourSecondPoints
             color:kLTTARBlueColor
         andHidden:_isHiddenSunPath];
    
    //draw golden hour
    [self drawPath:placeOfGoldenFirstCoordinate
         withArray:self.goldenHourFirstPoints
             color:kLTTARGoldenColor
         andHidden:_isHiddenSunPath];
    [self drawPath:placeOfGoldenSecondCoordinate
         withArray:self.goldenHourSecondPoints
             color:kLTTARGoldenColor
         andHidden:_isHiddenSunPath];
    
    // show moon now and sun now
    if (placeOfNowCoordinate == nil) {
        return;
    }
    
    for (int i = 0; i < self.nowPoints.count; i ++) {
        CGPoint centerPoint;
        BOOL validPoint = YES;
        [self getCenterPointForView:&centerPoint andCheckValid:&validPoint withPlaceOfCoordinate:placeOfNowCoordinate atIndex:i];
		if (validPoint) {
            if (_isHiddenMoonPath && i == 0) {
                ((PDARSunMoonView *)self.nowPoints[i]).imageView.hidden = YES;
            }
            else
            {
                if (_isHiddenSunPath && i == 1) {
                    ((PDARSunMoonView *)self.nowPoints[i]).imageView.hidden = YES;
                }
                else
                {
                    ((PDARSunMoonView *)self.nowPoints[i]).imageView.center = centerPoint;
                    ((PDARSunMoonView *)self.nowPoints[i]).imageView.hidden = NO;
                }
            }
        }
        else
            ((PDARSunMoonView *)self.nowPoints[i]).imageView.hidden = YES;
    }
}

// function caculate coordinate of points
- (vec4f_t *)calculateCoordinatePoint:(NSArray *)array
{
    vec4f_t *results = (vec4f_t *)malloc(sizeof(vec4f_t)* array.count);
    for (int i = 0; i < array.count; i++) {
        float e,n,u;
        // Chuyển đổi vị trí của mặt trăng qua hệ trục ENU
        PDARSunMoonView* aRSunMoonView = (PDARSunMoonView *)array[i];
        convertToNUE(aRSunMoonView.azimuth, aRSunMoonView.altitude,1.0 , &n, &e, &u);
        results[i][0] = (float)n;
        results[i][1] = (float)e;
        results[i][2] = -(float)u;
        results[i][3] = 1.0f;
        if (!aRSunMoonView.added) {
            [self addSubview:aRSunMoonView.imageView];
            aRSunMoonView.added = YES;
            aRSunMoonView.imageView.hidden = YES;
        }
    }
    return results;
}

// draw grid of earth with draw longitude lines and latitude lines
-(void)drawGridWithGridPointsOfCoordinate: (vec4f_t *)placeOfCoordinate
{
    if (placeOfCoordinate == nil) {
		return;
	}
    
    // Draw longitude lines
    for (int i=0; i < kLTTNumberOfPointsInLat / kLTTNumberOfSubPoint; i++) {
        for (int j = 1; j < kLTTNumberOfPointsInLong / kLTTNumberOfSubPoint; j++) {
            CGPoint point1 ;
            BOOL validPoint = YES;
            [self getCenterPointForView:&point1
                                andCheckValid:&validPoint
                  withPlaceOfCoordinate:placeOfGridCoordinate
                                atIndex:i * kLTTNumberOfSubPoint * kLTTNumberOfPointsInLong + j*kLTTNumberOfSubPoint];
            if (validPoint) {
                ((PDARSunMoonView *)self.gridPoints[i * kLTTNumberOfSubPoint *kLTTNumberOfPointsInLong + j*kLTTNumberOfSubPoint]).imageView.center = point1;
                ((PDARSunMoonView *)self.gridPoints[i * kLTTNumberOfSubPoint *kLTTNumberOfPointsInLong + j*kLTTNumberOfSubPoint]).imageView.hidden = NO;
                CGPoint point2 = [self getPointOfViewWithPlaceOfCoordinate:placeOfGridCoordinate atIndex:i * kLTTNumberOfSubPoint *kLTTNumberOfPointsInLong+ (j - 1)*kLTTNumberOfSubPoint];
                
                //draw bolder line in special longitude
                if ( i % 4 == 0) {
                    [self drawLineWithFirstPoint:point1 withSecondPoint:point2 color:_gridColor andLineWidth:4.0];
                }
                else [self drawLineWithFirstPoint:point1 withSecondPoint:point2 color:_gridColor andLineWidth:2.0];
                
                if (j == kLTTNumberOfPointsInLong / kLTTNumberOfSubPoint - 1)
                {
                    CGPoint point2 = [self getPointOfViewWithPlaceOfCoordinate:placeOfGridCoordinate atIndex:0];
                    if ( i % 4 == 0) {
                        [self drawLineWithFirstPoint:point1 withSecondPoint:point2 color:_gridColor andLineWidth:4.0];
                    }
                    else [self drawLineWithFirstPoint:point1 withSecondPoint:point2 color:_gridColor andLineWidth:2.0];
                }
            } else
            {
                ((PDARSunMoonView *)self.gridPoints[i * kLTTNumberOfSubPoint *kLTTNumberOfPointsInLong + j*kLTTNumberOfSubPoint]).imageView.hidden = YES;
            }
            
        }
    }
    // draw latitude lines
    for (int i = 0; i < kLTTNumberOfPointsInLong; i ++) {
        for (int j = 0; j < kLTTNumberOfPointsInLat / kLTTNumberOfSubPoint; j++) {
            CGPoint point1;
            BOOL validPoint = YES;
            [self getCenterPointForView:&point1
                          andCheckValid:&validPoint
                  withPlaceOfCoordinate:placeOfGridCoordinate
                                atIndex:j*kLTTNumberOfPointsInLong *kLTTNumberOfSubPoint + i];
            if (validPoint) {
                CGPoint point2;
                if (kLTTNumberOfSubPoint*(j+1)*kLTTNumberOfPointsInLong + i >= _gridPoints.count) {
                    point2 = [self getPointOfViewWithPlaceOfCoordinate:placeOfGridCoordinate atIndex:kLTTNumberOfPointsInLong - i];
                }else
                    point2 = [self getPointOfViewWithPlaceOfCoordinate:placeOfGridCoordinate atIndex:kLTTNumberOfSubPoint*(j+1)*kLTTNumberOfPointsInLong + i ];
                if ([self validatePoint:point1] || [self validatePoint:point2]) {
                    CGPoint point4 = [self getPointOfViewWithPlaceOfCoordinate:placeOfGridCoordinate
                                                                     atIndex:(kLTTNumberOfSubPoint*j+2)*kLTTNumberOfPointsInLong + i ];
                    CGPoint point3 = [self getPointOfViewWithPlaceOfCoordinate:placeOfGridCoordinate
                                                                     atIndex:(kLTTNumberOfSubPoint*j+1)*kLTTNumberOfPointsInLong + i ];
                    if ( i % kLTTNumberOfSubPoint == 0) {
                        [self drawLineWithFirstPoint:point1 withSecondPoint:point3 color:_gridColor andLineWidth:4.0];
                        [self drawLineWithFirstPoint:point3 withSecondPoint:point4 color:_gridColor andLineWidth:4.0];
                        [self drawLineWithFirstPoint:point4 withSecondPoint:point2 color:_gridColor andLineWidth:4.0];
                    }
                    else
                    {
                        [self drawLineWithFirstPoint:point1 withSecondPoint:point3 color:_gridColor andLineWidth:2.0];
                        [self drawLineWithFirstPoint:point3 withSecondPoint:point4 color:_gridColor andLineWidth:2.0];
                        [self drawLineWithFirstPoint:point4 withSecondPoint:point2 color:_gridColor andLineWidth:2.0];
                    }
                }
                
            }
            else ((PDARSunMoonView *)self.gridPoints[j*kLTTNumberOfPointsInLong*kLTTNumberOfSubPoint + i]).imageView.hidden = YES;
        }
    }
}

// draw Sun/Moon line
- (void)drawPath:(vec4f_t *)vector withArray:(NSArray *)array color:(UIColor *)color andHidden:(BOOL)hidden
{
    if (vector == nil) {
        return;
    }
    if (hidden)
    {
        for (int i = 0; i < array.count; i++) {
            ((PDARSunMoonView *)array[i]).imageView.hidden = YES;
        }
    }
    else {
        for (int i = 0; i < array.count; i ++) {
            CGPoint centerPoint;
            BOOL validPoint = YES;
            [self getCenterPointForView:&centerPoint andCheckValid:&validPoint withPlaceOfCoordinate:vector atIndex:i];
            if (validPoint) {
                ((PDARSunMoonView *)array[i]).imageView.center = centerPoint;
                if (i > 0 && i < array.count) {
                    CGPoint prevPoint = [self getPointOfViewWithPlaceOfCoordinate:vector atIndex:i-1];
                    [self drawLineWithFirstPoint:prevPoint withSecondPoint:centerPoint color:color andLineWidth:3.0];
                }
                if (array.count == kLTTNumberOfHourInDay + 1) {
                    
                } else
                    if (i == array.count - 1) {
                        CGPoint prevPoint = [self getPointOfViewWithPlaceOfCoordinate:vector atIndex:0];
                        [self drawLineWithFirstPoint:prevPoint withSecondPoint:centerPoint color:color andLineWidth:3.0];
                    }
                ((PDARSunMoonView *)array[i]).imageView.hidden = NO;
            } else
                ((PDARSunMoonView *)array[i]).imageView.hidden = YES;
        }
    }
}

// get center of point's view, return center of point's view and bool. bl parameter use to check valid point
- (void)getCenterPointForView:(CGPoint *)point andCheckValid:(BOOL *)valid withPlaceOfCoordinate:(vec4f_t *)pOC atIndex:(NSInteger)index
{
    vec4f_t v;
    multiplyMatrixAndVector(v, projectionCameraTransform, pOC[index]);
    float x = (v[0] / v[3] + 1.0f) * 0.5f;
    float y = (v[1] / v[3] + 1.0f) * 0.5f;
    point->x = x * self.bounds.size.width;
    point->y = self.bounds.size.height - y * self.bounds.size.height;
    if (v[2] < 0) {
        *valid = YES;
    }else *valid = NO;
}

// get center view of point without return bool
- (CGPoint)getPointOfViewWithPlaceOfCoordinate:(vec4f_t *)placeOfCoordinate atIndex:(NSInteger)index
{
    vec4f_t v;
    multiplyMatrixAndVector(v, projectionCameraTransform, placeOfCoordinate[index]);
    float x = (v[0] / v[3] + 1.0f) * 0.5f;
    float y = (v[1] / v[3] + 1.0f) * 0.5f;
    CGPoint tmp = CGPointMake(x*self.bounds.size.width, self.bounds.size.height - y * self.bounds.size.height);
    return tmp;
}

// draw line with 2 points
- (void)drawLineWithFirstPoint: (CGPoint)firstPoint withSecondPoint:(CGPoint)secondPoint color:(UIColor *)color andLineWidth: (float)width
{
    if ([self validatePoint:firstPoint]||[self validatePoint:secondPoint])
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, width);
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextMoveToPoint(context, firstPoint.x, firstPoint.y);
        CGContextAddLineToPoint(context, secondPoint.x, secondPoint.y);
        CGContextStrokePath(context);
    }
}

// check point in screen
- (BOOL)validatePoint:(CGPoint)point
{
    if (point.x < 0 || point.x > self.bounds.size.width ) {
        return NO;
    }
    else if (point.y < 0 || point.y > self.bounds.size.height)
        return NO;
    else
        return YES;
}

// get current date
- (NSDate *)currentDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *timeComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit |
                                                        NSMonthCalendarUnit | NSYearCalendarUnit)
                                              fromDate:date];
    NSInteger  day = [timeComp day];
    NSInteger  month = [timeComp month];
    NSInteger  year = [timeComp year];
    NSInteger hour = [timeComp hour];
    NSInteger minute = [timeComp minute];
    
    NSString *dateString = [NSString stringWithFormat:@"%04ld-%02ld-%02zd %02zd:%02zd", (long)year, (long)month, day,hour,minute];
    NSDate *currentDate = [dateFormatter dateFromString:dateString];
    return currentDate;
}

#pragma mark - hidden sun moon

- (void)hiddenSun:(BOOL)hidden
{
    _isHiddenSunPath = hidden;
}

- (void)hiddenMoon:(BOOL)hidden
{
    _isHiddenMoonPath = hidden;
}

- (void)updateARViewWithLatitude:(double)latitude longitude:(double)longitude
{
    _latitude = latitude;
    _longitude = longitude;
    [self refresh];
}

- (void)refresh
{
    [self refreshNow];
    // initialize points to draw grid
    if (self.gridPoints.count == 0) {
        int typeOfARSunMoonView;
        for (int i = 0; i < kLTTNumberOfPointsInLat; i ++) {
            for (int j = 0; j < kLTTNumberOfPointsInLong; j ++) {
                // initialize special points to draw equator line
                if ((j % 9 == 0) && (j % 18 != 0) && (i%kLTTNumberOfSubPoint == 0)) {
                    typeOfARSunMoonView = EquatorPoint;
                } else if ((j % 3 == 0) && (j % 9 != 0)  && (i % 12 == 0)) {
                    // initialize special points in grid
                    typeOfARSunMoonView = Node;
                }
                else {
                    typeOfARSunMoonView = Latitude;
                }
                
                [self addObjectToArray:self.gridPoints
                              withdate:nil
                               azimuth:(Radian * i * kLTTFullRotationInDegree/(kLTTNumberOfPointsInLat * 2))
                              altitude:(Radian * (kLTTFullRotationInDegree/4 - j * kLTTFullRotationInDegree/kLTTNumberOfPointsInLong))
                               andType:typeOfARSunMoonView];
            }
        }

    }
    [self updatePlacesOfPointCoordinates];
}

# pragma mark - add Positon

- (void)addObjectToArray:(NSMutableArray *)array withdate:(NSDate *)date azimuth:(float)azimuth altitude:(float)altitude andType:(NSInteger)type
{
    PDARSunMoonView *aRSunmoonView = [[PDARSunMoonView alloc] initWithType:type azimuth:azimuth altitude:altitude time:date];
    [array addObject:aRSunmoonView];
}

- (void)removeObjectInArray:(NSMutableArray *)array
{
    if (array.count > 0) {
        for (int i = 0; i < array.count; i ++) {
            PDARSunMoonView *aRSunmoonView = (PDARSunMoonView *)array[i];
            [aRSunmoonView.imageView removeFromSuperview];
        }
    }
    [array removeAllObjects];
}

@end
