//
//  DayCell.h
//  ForecastLayout
//
//  Created by Viet Ta Quoc on 9/5/13.
//  Copyright (c) 2013 Viet Ta Quoc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDDrawMoon.h"
#import "SunMoonCalcGobal.h"
#import <CoreLocation/CoreLocation.h>
#import "PDWeather.h"

@protocol PDDayCellDelegate <NSObject>
@optional
-(void)toggleCellWithIndex:(NSInteger)index;
@end

@interface PDWeatherCell : UITableViewCell
@property (nonatomic, strong) id<PDDayCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *moonLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnShowDetail;
@property (weak, nonatomic) IBOutlet UILabel *weekDayLabel;
@property (nonatomic,strong) IBOutlet UILabel *monthLabel;
@property (nonatomic,strong) IBOutlet UILabel *dayLabel;
@property (nonatomic,strong) IBOutlet UIImageView *weather;
@property (weak, nonatomic) IBOutlet UIImageView *lineCellImageView;
@property (nonatomic, strong) UIImage *iconAngleRight;
@property (nonatomic, strong) UIImage *iconAngleDown;
@property (nonatomic, strong) SunMoonCalcGobal *sunMoonCalc;
@property (weak, nonatomic) IBOutlet PDDrawMoon *draw;
@property NSInteger PDMoonPhase;

- (IBAction)showAndHiddenDetailWeather:(id)sender;
- (void)setContentCell:(NSDate *)date andLocation:(CLLocation *)location;
- (void)setContentForWeather:(PDWeather *)newWeather;
- (void)toggleImageButtonShowDetatilWeather;

@end
