//
//  PDSunMoonView.h
//  Pashadelic
//
//  Created by LongPD on 2/6/14.
//
//

#import <Foundation/Foundation.h>
#define Radian M_PI / 180.0

enum typeOfARView
{
    SunPoint = 0,
    MoonPoint = 1,
    EquatorPoint = 2,
    SunNow = 3,
    MoonNow = 4,
    BlueHour = 5,
    GoldenHour = 6,
    Latitude = 7,
    Node,
    Another
};

@interface PDARSunMoonView : NSObject
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) float azimuth;
@property (nonatomic, assign) float altitude;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL added;
- (id)initWithType:(NSInteger)type
           azimuth:(float)azimuth
          altitude:(float)altitude
              time:(NSDate *)time;
- (void)setAzimuth:(float)azimuth altitude:(float)altitude andTime:(NSDate *)time;
@end