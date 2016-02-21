//
//  PDNewHomeViewController.h
//  Pashadelic
//
//  Created by LongPD on 9/5/13.
//
//

#import <UIKit/UIKit.h>
#import "PDTableViewController.h"
#import "SunMoonCalcGobal.h"
#import "PDWeatherLoader.h"
#import "PDWeather.h"
#import "PDMagicHourCell.h"
#import "PDWeatherCell.h"

@interface PDForeCastWeatherViewController : PDViewController
<UITableViewDelegate, UITableViewDataSource, PDDayCellDelegate, PDMagicHourCellDelegate, MGServerExchangeDelegate>

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableViewWeather;
@property (weak, nonatomic) IBOutlet UILabel *forecastLabel;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, strong) SunMoonCalcGobal *sunMoonCalc;
@property (nonatomic, strong) PDWeatherLoader *weatherLoader;
@property (nonatomic, strong) PDWeather *todayWeather;
@property (weak, nonatomic) IBOutlet UIImageView *todayImageView;
@property (nonatomic, strong) UIImage *todayPhoto;
@property (nonatomic, strong ) NSArray *weathers;
@property (nonatomic, strong) NSDate *currentDate;
@property BOOL didRotateShapMoon;
@property NSInteger PDMoonPhase;
@property (assign, nonatomic) NSInteger currentExpandedCell;
@property (assign, nonatomic) NSInteger currentNumberOfCell;
@property (nonatomic) float expandedCellHeight;
- (IBAction)didToucheBackButton:(id)sender;
- (void)fetchData;
@end
