//
//  ExpandedCell.m
//  WeatherForcastFinal
//
//  Created by Viet Ta Quoc on 9/13/13.
//  Copyright (c) 2013 Viet Ta Quoc. All rights reserved.
//

#import "PDMagicHourCell.h"
#import "NSDate+Extra.h"
#import "FontAwesomeKit.h"

@implementation PDMagicHourCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)aRButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapARButton:)]) {
        [self.delegate didTapARButton:self.date];
    }
}

- (void)setContentCell:(NSDate *)date andLocation:(CLLocation *)location
{
    self.date = date;
    self.topView.layer.cornerRadius = 5;
    self.bottomView.layer.cornerRadius = 5;
    self.viewLabel.text = NSLocalizedString(@"View", nil);
    self.aRLabel.text = NSLocalizedString(@"AR", nil);
    _magicHourLabel.text = NSLocalizedString(@"magic hour", nil);
    _blueHourFirstLabel.text = NSLocalizedString(@"blue hour", nil);
    _blueHourSecondLabel.text = NSLocalizedString(@"blue hour", nil);
    _goldenHourFirstLabel.text = NSLocalizedString(@"golden hour", nil);
    _goldenHourSecondLabel.text = NSLocalizedString(@"golden hour", nil);
    _startLabel.text = NSLocalizedString(@"start", nil);
    _endLabel.text = NSLocalizedString(@"end", nil);
    _magicHourLabel.transform = CGAffineTransformMakeRotation(-M_PI_2);
    
	CGFloat fontSize = 20;
	NSDictionary *whiteColorAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *yellowColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalYellowColor};
	[self.sunRiseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:yellowColorAttribute];
	[self.sunSetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:yellowColorAttribute];
	
    float lat = location.coordinate.latitude;
    float lng = location.coordinate.longitude;
    
    if (!_sunMoonCalc) {
        self.sunMoonCalc = [[SunMoonCalcGobal alloc] init];
    }
    [self.sunMoonCalc computeMoonriseAndMoonSet:date withLatitude:lat withLongitude:lng];
    [self.sunMoonCalc computeSunriseAndSunSet:date withLatitude:lat withLongitude:lng];
    
    BOOL moonRiseBeforeMoonSet = (self.sunMoonCalc.timeRiseMoon.timeIntervalSince1970 < self.sunMoonCalc.timeSetMoon.timeIntervalSince1970);
  
	if (moonRiseBeforeMoonSet) {
		[self.moonRiseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		[self.moonSetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		
	} else {
		[self.moonRiseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		[self.moonSetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:whiteColorAttribute];
	}

    if (moonRiseBeforeMoonSet) {
        if (self.sunMoonCalc.MoonRise) {
            self.moonRiseLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        }
        if (self.sunMoonCalc.MoonSet)
        {
            self.moonSetLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
        }
    } else {
        if (self.sunMoonCalc.MoonSet == YES ) {
            self.moonRiseLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
        }
        if (self.sunMoonCalc.MoonRise == YES)
        {
            self.moonSetLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        }
    }

    if (_sunMoonCalc.todayHaveMoon == YES) {
        if (self.sunMoonCalc.MoonRise == YES )
            [self drawMoonPhaseWithLat:lat withDate:self.sunMoonCalc.timeRiseMoon];
        else if (self.sunMoonCalc.MoonSet == YES)
            [self drawMoonPhaseWithLat:lat withDate:self.sunMoonCalc.timeSetMoon];
        else
            [self drawMoonPhaseWithLat:lat withDate:date];
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
    _goldenHourStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunRiseEndTime stringValueFormattedBy:@"HH"],
                                                                     [sunRiseEndTime stringValueFormattedBy:@"mm"]];
    _goldenHourEndLabel.text = [NSString stringWithFormat:@"%@:%@",[goldenHourEnd stringValueFormattedBy:@"HH"],
                                                                   [goldenHourEnd stringValueFormattedBy:@"mm"]];
    _goldenhourSecondStartLabel.text = [NSString stringWithFormat:@"%@:%@",[goldenHour stringValueFormattedBy:@"HH"],
                                        [goldenHour stringValueFormattedBy:@"mm"]];
    _goldenhourSecondEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetStartTime stringValueFormattedBy:@"HH"],
                                                                         [sunsetStartTime stringValueFormattedBy:@"mm"]];
    _sunsetEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetTime stringValueFormattedBy:@"HH"],
                                                               [sunsetTime stringValueFormattedBy:@"mm"]];
    _bluehourSecondStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetTime stringValueFormattedBy:@"HH"],
                                                                         [sunsetTime stringValueFormattedBy:@"mm"]];
    _bluehourSecondEndLabel.text = [NSString stringWithFormat:@"%@:%@",[dusk stringValueFormattedBy:@"HH"],
                                                                       [dusk stringValueFormattedBy:@"mm"]];
}

- (void)drawMoonPhaseWithLat:(float)lat withDate:(NSDate *)dateC
{
    NSDate *dateC2 = [NSDate dateWithTimeInterval:1 sinceDate:dateC];
    
    double fraction = [_sunMoonCalc getMoonFraction:dateC];
    double fraction2 = [_sunMoonCalc getMoonFraction:dateC2];
    double moonFraction = fraction2 - fraction;
    
    float op = fraction;
    
    [self.drawMoon drawMoon:self.drawMoon.width/2 andOption:op color:[UIColor whiteColor]];

    if (moonFraction > 0)
        _PDMoonPhase = FirstQuarter;
    else
        _PDMoonPhase = Lastquarter;

    if (((lat > 0 ) && (_PDMoonPhase == FirstQuarter)) || ((lat < 0) && (_PDMoonPhase == Lastquarter)))
        _drawMoon.transform = CGAffineTransformMakeRotation(M_PI);
    else
        _drawMoon.transform = CGAffineTransformMakeRotation(0);
}

@end
