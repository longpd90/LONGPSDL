//
//  ExpandedCell.h
//  WeatherForcastFinal
//
//  Created by Viet Ta Quoc on 9/13/13.
//  Copyright (c) 2013 Viet Ta Quoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PDWeather.h"
#import "SunMoonCalcGobal.h"
#import "PDDynamicFontLabel.h"
#import "PDDrawMoon.h"
@class PDMagicHourCell;
@protocol PDMagicHourCellDelegate <NSObject>

@optional

- (void)didTapARButton:(NSDate *)date;
@end
typedef enum MoonPhase {
	FirstQuarter = 0,
	Lastquarter,
}MoonPhase;

@interface PDMagicHourCell : UITableViewCell
@property (weak, nonatomic) id<PDMagicHourCellDelegate>delegate;
@property (strong, nonatomic) SunMoonCalcGobal *sunMoonCalc;
@property (nonatomic, strong) IBOutlet PDDrawMoon *drawMoon;
@property int PDMoonPhase;
@property (strong , nonatomic) NSDate *date;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *aRLabel;

@property (weak, nonatomic) IBOutlet UIButton *aRButton;
@property (weak, nonatomic) IBOutlet UIImageView *sunImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunRiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunSetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moonRiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moonSetImageView;
@property (weak, nonatomic) IBOutlet UILabel *moonRiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *moonSetLabel;

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *magicHourLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *blueHourFirstLabel;

@property (weak, nonatomic) IBOutlet UILabel *bluehourFirstStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *bluehourFirstEndLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunriseStartLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *goldenHourFirstLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *goldenHourSecondLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *blueHourSecondLabel;

@property (weak, nonatomic) IBOutlet UILabel *goldenHourEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenHourStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenhourSecondStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenhourSecondEndLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunsetEndLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *bluehourSecondStartLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *bluehourSecondEndLabel;


- (IBAction)aRButton:(id)sender;
- (void)setContentCell:(NSDate *)date andLocation:(CLLocation *)location;
@end
