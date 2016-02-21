//
//  PDLocationInfoViewController.h
//  Pashadelic
//
//  Created by LongPD on 6/18/14.
//
//

#import "PDPhotoTableViewController.h"
#import "PDLocationInfoTableView.h"
#import "PDDrawMoon.h"
#import "PDLocationInfoLoader.h"
#import "PDLocation.h"

@interface PDLocationInfoViewController : PDTableViewController

@property (strong, nonatomic) PDLocationInfoTableView *locationTableView;
@property int PDMoonPhase;
@property (strong, nonatomic) PDLocation *location;

@property (strong, nonatomic) PDLocationInfoLoader *locationInfoLoader;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunRiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunSetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moonSetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moonRiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *angleRightImageView;
@property (weak, nonatomic) IBOutlet UIView *graphicView;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *moonRiseLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *moonSetLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *sunRiseLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
@property (weak, nonatomic) IBOutlet PDDrawMoon *drawMoon;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *monthButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *timeButton;
@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *forecastLabel;


- (IBAction)showGraphicsByMonth:(id)sender;
- (IBAction)showGraphicsByTime:(id)sender;
- (IBAction)forecastWeatherDidClicked:(id)sender;

@end
