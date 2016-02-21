//
//  PDLandmarkForecastViewController.h
//  Pashadelic
//
//  Created by LTT on 6/20/14.
//
//

#import "PDForeCastWeatherViewController.h"

@interface PDLandmarkForecastViewController : PDForeCastWeatherViewController
<UITableViewDelegate, UITableViewDataSource,PDDayCellDelegate, PDMagicHourCellDelegate, MGServerExchangeDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *todayImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewWeather;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *forecastLabel;
- (IBAction)didToucheBackButton:(id)sender;
@end
