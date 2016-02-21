//
//  DayCell.m
//  ForecastLayout
//
//  Created by Viet Ta Quoc on 9/5/13.
//  Copyright (c) 2013 Viet Ta Quoc. All rights reserved.
//

#import "PDWeatherCell.h"
#import "FontAwesomeKit.h"
#import "NSDate+Extra.h"

typedef enum MoonPhase {
	FirstQuarter = 0,
	Lastquarter,
}MoonPhase;

@implementation PDWeatherCell
@synthesize monthLabel,dayLabel,weather;

- (void)awakeFromNib
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    CGSize size = CGSizeMake(20, 20);
	FAKIcon *iconDown = [FAKFontAwesome angleDownIconWithSize:18];
	iconDown.attributes = attributes;
	_iconAngleDown = [iconDown imageWithSize:size];
    
    FAKIcon *iconRight = [FAKFontAwesome angleRightIconWithSize:18];
    iconRight.attributes = attributes;
	_iconAngleRight = [iconRight imageWithSize:size];
    _moonLabel.text = NSLocalizedString(@"moon", nil);
    _weatherLabel.text = NSLocalizedString(@"weather", nil);
    [_btnShowDetail setBackgroundImage:_iconAngleRight forState:UIControlStateNormal];
    [_btnShowDetail setBackgroundImage:_iconAngleDown forState:UIControlStateSelected];
}

- (IBAction)showAndHiddenDetailWeather:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(toggleCellWithIndex:)]) {
        [self.delegate toggleCellWithIndex:self.tag];
    }
}

- (void)toggleImageButtonShowDetatilWeather
{
    if (_btnShowDetail.selected) {
        _btnShowDetail.selected = NO;
    }
    else{
        _btnShowDetail.selected = YES;
    }
    _lineCellImageView.hidden = _btnShowDetail.selected;

}

- (void)setContentCell:(NSDate *)date andLocation:(CLLocation *)location
{
    float lat = location.coordinate.latitude;
    float lng = location.coordinate.longitude;
    if (!_sunMoonCalc) {
        self.sunMoonCalc = [[SunMoonCalcGobal alloc] init];
    }
    [self.sunMoonCalc computeMoonriseAndMoonSet:date withLatitude:lat withLongitude:lng];
    [self.sunMoonCalc computeSunriseAndSunSet:date withLatitude:lat withLongitude:lng];
    
    if (_sunMoonCalc.todayHaveMoon == YES) {
        if (self.sunMoonCalc.MoonRise == YES )
            [self drawMoonPhaseWithLat:lat withDate:self.sunMoonCalc.timeRiseMoon];
        else if (self.sunMoonCalc.MoonSet == YES)
            [self drawMoonPhaseWithLat:lat withDate:self.sunMoonCalc.timeSetMoon];
        else
            [self drawMoonPhaseWithLat:lat withDate:date];
    }
  
    NSString *monthString =[ date stringValueFormattedBy:@"MMM"];
    monthString = [monthString stringByReplacingOccurrencesOfString:@" " withString:@""];
    monthLabel.text =  monthString;
    int dayValue = [[date stringValueFormattedBy:@"dd"]intValue];
    dayLabel.text = [NSString stringWithFormat:@"%zd",dayValue];
    if (self.tag == 0){
        _weekDayLabel.text = NSLocalizedString(@"Today", nil);
    }
    else if (self.tag == 1){
        _weekDayLabel.text = NSLocalizedString(@"Tomorrow", nil);
    }
    else{
        _weekDayLabel.text = [[date stringValueFormattedBy:@"EEE"]capitalizedString];
    }
}

- (void)drawMoonPhaseWithLat:(float)lat withDate:(NSDate *)dateC
{
    NSDate *dateC2 = [NSDate dateWithTimeInterval:1 sinceDate:dateC];
    
    double fraction = [_sunMoonCalc getMoonFraction:dateC];
    double fraction2 = [_sunMoonCalc getMoonFraction:dateC2];
    double moonFraction = fraction2 - fraction;

    float op = fraction;
    
    [self.draw drawMoon:10 andOption:op color:[UIColor whiteColor]];

    if (moonFraction > 0)
        _PDMoonPhase = FirstQuarter;
    else
        _PDMoonPhase = Lastquarter;
    
    if (((lat > 0 ) && (_PDMoonPhase == FirstQuarter)) || ((lat < 0) && (_PDMoonPhase == Lastquarter)))
        _draw.transform = CGAffineTransformMakeRotation(M_PI);
    else
        _draw.transform = CGAffineTransformMakeRotation(0);
}

- (void)setContentForWeather:(PDWeather *)newWeather
{
    self.weather.image = newWeather.iconImage;
}

@end
