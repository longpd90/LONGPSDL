//
//  PDLandmarkMagicHourCell.h
//  Pashadelic
//
//  Created by LTT on 6/20/14.
//
//

#import <UIKit/UIKit.h>
#import "PDDynamicFontLabel.h"
#import "PDWeather.h"
#import "SunMoonCalcGobal.h"
#import "PDDrawMoon.h"

@interface PDLandmarkMagicHourCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *magicHourLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *blueHourFirstLabel;

@property (weak, nonatomic) IBOutlet UILabel *bluehourFirstStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *bluehourFirstEndLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *moonSetLabel;
@property (weak, nonatomic) IBOutlet UILabel *moonSetTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunriseStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseEndLabel;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *goldenHourFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenHourStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenHourEndLabel;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *goldenHourSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenhourSecondStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenhourSecondEndLabel;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetEndLabel;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *moonRiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *moonRiseTimeLabel;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *blueHourSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *bluehourSecondStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *bluehourSecondEndLabel;

@property (strong , nonatomic) NSDate *date;
@property (strong, nonatomic) SunMoonCalcGobal *sunMoonCalc;

- (void)setContentCell:(NSDate *)date andLocation:(CLLocation *)location;
@end
