//
//  PDLandmarkMagicHourCell.m
//  Pashadelic
//
//  Created by LTT on 6/20/14.
//
//

#import "PDLandmarkMagicHourCell.h"

@implementation PDLandmarkMagicHourCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setContentCell:(NSDate *)date andLocation:(CLLocation *)location
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(8.0, 8.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    self.date = date;
    _magicHourLabel.text = NSLocalizedString(@"magic hour", nil);
    _blueHourFirstLabel.text = NSLocalizedString(@"blue hour", nil);
    _moonRiseLabel.text = NSLocalizedString(@"moonrise", nil);
    _moonSetLabel.text = NSLocalizedString(@"moonset", nil);
    _blueHourSecondLabel.text = NSLocalizedString(@"blue hour", nil);
    _goldenHourFirstLabel.text = NSLocalizedString(@"golden hour", nil);
    _goldenHourSecondLabel.text = NSLocalizedString(@"golden hour", nil);
    _startLabel.text = NSLocalizedString(@"start", nil);
    _endLabel.text = NSLocalizedString(@"end", nil);
    _magicHourLabel.transform = CGAffineTransformMakeRotation(- M_PI_2);
    float lat = location.coordinate.latitude;
    float lng = location.coordinate.longitude;
    
    if (!_sunMoonCalc) {
        self.sunMoonCalc = [[SunMoonCalcGobal alloc] init];
    }
    [self.sunMoonCalc computeMoonriseAndMoonSet:date withLatitude:lat withLongitude:lng];
    [self.sunMoonCalc computeSunriseAndSunSet:date withLatitude:lat withLongitude:lng];
    
    BOOL moonRiseBeforeMoonSet = (self.sunMoonCalc.timeRiseMoon.timeIntervalSince1970 < self.sunMoonCalc.timeSetMoon.timeIntervalSince1970);
    
    if (moonRiseBeforeMoonSet) {
        if (self.sunMoonCalc.MoonRise) {
            self.moonRiseTimeLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        }
        if (self.sunMoonCalc.MoonSet)
        {
            self.moonSetTimeLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
        }
    } else {
        if (self.sunMoonCalc.MoonSet == YES ) {
            self.moonRiseTimeLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
        }
        if (self.sunMoonCalc.MoonRise == YES)
        {
            self.moonSetTimeLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        }
    }
    
    NSDictionary *sunTimes = [_sunMoonCalc getSunTimesWithDate:date andLatitude:lat andLogitude:lng];
    
    NSDate *goldenHour =  (NSDate *)[sunTimes objectForKey:@"goldenHour"];
    NSDate *sunriseTime = (NSDate *)[sunTimes objectForKey:@"sunrise"];
    NSDate *sunsetStartTime = (NSDate *)[sunTimes objectForKey:@"sunsetStart"];
    NSDate *sunsetTime = (NSDate *)[sunTimes objectForKey:@"sunset"];
    NSDate *goldenHourEnd = (NSDate *)[sunTimes objectForKey:@"goldenHourEnd"];
    NSDate *sunRiseEndTime = (NSDate *)[sunTimes objectForKey:@"sunriseEnd"];
    NSDate *dawn = (NSDate *)[sunTimes objectForKey:@"dawn"];
    NSDate *dusk = (NSDate *)[sunTimes objectForKey:@"dusk"];
    
    _bluehourFirstStartLabel.text = [NSString stringWithFormat:@"%@:%@",[dawn stringValueFormattedBy:@"HH"],
                                     [dawn stringValueFormattedBy:@"mm"]];
    _bluehourFirstEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunriseTime stringValueFormattedBy:@"HH"],
                                   [sunriseTime stringValueFormattedBy:@"mm"]];
    _sunriseStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunriseTime stringValueFormattedBy:@"HH"],
                               [sunriseTime stringValueFormattedBy:@"mm"]];
    _sunriseEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunRiseEndTime stringValueFormattedBy:@"HH"],
                             [sunRiseEndTime stringValueFormattedBy:@"mm"]];
    
    _goldenHourStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunRiseEndTime stringValueFormattedBy:@"HH"],
                                  [sunRiseEndTime stringValueFormattedBy:@"mm"]];
    _goldenHourEndLabel.text = [NSString stringWithFormat:@"%@:%@",[goldenHourEnd stringValueFormattedBy:@"HH"],
                                [goldenHourEnd stringValueFormattedBy:@"mm"]];
    
    _goldenhourSecondStartLabel.text = [NSString stringWithFormat:@"%@:%@",[goldenHour stringValueFormattedBy:@"HH"],
                                        [goldenHour stringValueFormattedBy:@"mm"]];
    _goldenhourSecondEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetStartTime stringValueFormattedBy:@"HH"],
                                      [sunsetStartTime stringValueFormattedBy:@"mm"]];
    
    _sunsetStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetStartTime stringValueFormattedBy:@"HH"],
                              [sunsetStartTime stringValueFormattedBy:@"mm"]];
    _sunsetEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetTime stringValueFormattedBy:@"HH"],
                            [sunsetTime stringValueFormattedBy:@"mm"]];
    _bluehourSecondStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetTime stringValueFormattedBy:@"HH"],
                                      [sunsetTime stringValueFormattedBy:@"mm"]];
    _bluehourSecondEndLabel.text = [NSString stringWithFormat:@"%@:%@",[dusk stringValueFormattedBy:@"HH"],
                                    [dusk stringValueFormattedBy:@"mm"]];
}
@end
