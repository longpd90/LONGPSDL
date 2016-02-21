//
//  PDSunMoonView.m
//  Pashadelic
//
//  Created by LongPD on 2/6/14.
//
//

#import "PDARSunMoonView.h"

#define kSizeOfMoonView 50
@interface PDARSunMoonView ()
@property (nonatomic, strong) UILabel *labelName;
@property (nonatomic, strong) UILabel *labelTime;
@end

@implementation PDARSunMoonView
- (id)initWithType:(NSInteger)type azimuth:(float)azimuth altitude:(float)altitude time:(NSDate *)time {
	self = [super init];
    if (self ) {
        self.type = type;
        //        [self setAzimuth:azimuth altitude:altitude andTime:time];
        self.azimuth =azimuth;
        self.altitude = altitude;
        self.time = time;
        NSString *dateString = [self.time stringValueFormattedBy:@"HH:mm" ];
        
        _labelName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 20)];
        [_labelName setFont:[UIFont systemFontOfSize:13]];
        _labelName.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
        _labelTime = [[UILabel alloc]init];
        [_labelTime setFont:[UIFont boldSystemFontOfSize:14]];
        [_labelTime setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
        _labelTime.text= dateString;
        CGSize size1 = [_labelTime.text sizeWithFont:_labelTime.font];
        _labelTime.bounds = CGRectMake(0.0f, 0.0f, size1.width, size1.height);
        
        switch (self.type) {
            case SunPoint:
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15 , 15)];
                self.imageView.image = [UIImage imageNamed:@"sun-point.png"];
                _labelTime.textColor = [UIColor colorWithRed:255/255.0 green:100/255.0 blue:0 alpha:1];
                _labelTime.center = CGPointMake(40,10);
                break;
            case MoonPoint:
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15 , 15)];
                self.imageView.image = [UIImage imageNamed:@"moon-point.png"];
                if ([_labelTime.text isEqualToString:@"00:00"]) {
                    _labelTime.frame = CGRectMake(0, 0, 100, 20);
                    _labelTime.text = [self.time stringValueFormattedBy:@"HH:mm dd/MM/yy"];
                    _labelTime.center = CGPointMake(70,10);
                } else
                    _labelTime.center = CGPointMake(40,10);
                _labelTime.textColor = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1];
                
                break;
            case EquatorPoint:{
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50 , 50)];
                self.imageView.image = [UIImage imageNamed:@"equator.png"];
                _labelName.center = CGPointMake(self.imageView.frame.size.width/2, self.imageView.frame.size.width/2);
                NSString *name = [self convertStringSpecial:[NSString stringWithFormat:@"%0.1f",(azimuth - altitude) * 180 / M_PI] withView:self.imageView];
                _labelName.text = name;
                _labelTime.text = nil;
                break;
            }
            case SunNow:
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfMoonView , kSizeOfMoonView)];
                self.imageView.image = [UIImage imageNamed:@"sun-now.png"];
                _labelTime.text= nil;
                break;
            case MoonNow:
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfMoonView , kSizeOfMoonView)];
                self.imageView.image = [UIImage imageNamed:@"moon-now.png"];
                _labelTime.text= nil;
                break;
            case BlueHour:
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20 , 20)];
                self.imageView.image = [UIImage imageNamed:@"blue-hour.png"];
                _labelTime.text= nil;
                break;
            case GoldenHour:
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20 , 20)];
                self.imageView.image = [UIImage imageNamed:@"golden-hour.png"];
                _labelTime.text= nil;
                break;
            case Latitude:
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15 , 15)];
                _labelTime.text= nil;
                break;
            case Node:
                self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30 , 30)];
                self.imageView.image = [UIImage imageNamed:@"equator.png"];
                _labelName.center = CGPointMake(15, 15);
                if (abs(altitude * 180/M_PI - -120)<0.01) {
                    _labelName.text = [NSString stringWithFormat:@"-60"];
                }else if (abs(altitude * 180/M_PI - -150)<0.01) {
                    _labelName.text = [NSString stringWithFormat:@"-30"];
                } else if (abs(altitude * 180/M_PI - -210)<0.01) {
                    _labelName.text = [NSString stringWithFormat:@"30"];
                } else if (abs(altitude * 180/M_PI - -240)<0.01) {
                    _labelName.text = [NSString stringWithFormat:@"60"];
                } else
                    _labelName.text = [NSString stringWithFormat:@"%0.0f",altitude * 180/M_PI];
                _labelTime.text = nil;
                break;
            case Another:
                break;
            default:
                break;
        }
        
        CGSize size = [_labelName.text sizeWithFont:_labelName.font];
        _labelName.bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
        [self.imageView addSubview:_labelName];
        [self.imageView addSubview:_labelTime];
    }
    return self;
}

- (void)setAzimuth:(float)azimuth altitude:(float)altitude andTime:(NSDate *)time
{
    self.azimuth = azimuth;
    self.altitude = altitude;
    self.time = time;
    if (self.type == MoonPoint && [_labelTime.text rangeOfString:@"00:00"].location != NSNotFound) {
        _labelTime.text = [time stringValueFormattedBy:@"HH:mm dd/MM/yy"];
    }
}

- (NSString *)convertStringSpecial:(NSString *)string withView:(UIImageView *)imageView
{
    NSString *result ;
    if ([string isEqualToString:@"0.0"]) {
        [_labelName setFont:[UIFont systemFontOfSize:20]];
        result = NSLocalizedString(@"N", nil);
    } else if ([string isEqualToString:@"45.0"]) {
        imageView.frame = CGRectMake(0, 0, 43, 43);
        result = NSLocalizedString(@"NE", nil);
    } else if ([string isEqualToString:@"90.0"]) {
        [_labelName setFont:[UIFont systemFontOfSize:20]];
        result = NSLocalizedString(@"E", nil);
    } else if ([string isEqualToString:@"135.0"]) {
        imageView.frame = CGRectMake(0, 0, 43, 43);
        result = NSLocalizedString(@"SE", nil);
    } else if ([string isEqualToString:@"180.0"]) {
        [_labelName setFont:[UIFont systemFontOfSize:20]];
        result = NSLocalizedString(@"S", nil);
    } else if ([string isEqualToString:@"225.0"]) {
        imageView.frame = CGRectMake(0, 0, 43, 43);
        result = NSLocalizedString(@"SW", nil);
    } else if ([string isEqualToString:@"270.0"]) {
        [_labelName setFont:[UIFont systemFontOfSize:20]];
        result = NSLocalizedString(@"W", nil);
    } else if ([string isEqualToString:@"315.0"]) {
        imageView.frame = CGRectMake(0, 0, 43, 43);
        result = NSLocalizedString(@"NW", nil);
    } else {
        imageView.frame = CGRectMake(0, 0, 35, 35);
        result = string;
    }
    _labelName.center = CGPointMake(imageView.frame.size.width / 2, imageView.frame.size.width / 2);
    return result;
}

@end
