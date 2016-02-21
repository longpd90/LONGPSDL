//
//  PDPlanDetailViewController.h
//  Pashadelic
//
//  Created by LongPD on 11/14/13.
//
//

#import "PDViewController.h"
#import "PDPhotosMapView.h"
#import "PDPlan.h"
#import "PDDynamicFontLabel.h"
#import "SunMoonCalcGobal.h"
#import "PDDrawMoon.h"
#import "PDOverlayView.h"
#import "SSTextView.h"
typedef enum MoonPhase {
	FirstQuarter = 0,
	Lastquarter,
}MoonPhase;

@interface PDPlanDetailViewController : PDViewController <PDOverlayViewDelegate>
@property (strong, nonatomic) PDPhotosMapView *photoMapView;
@property (strong, nonatomic) SunMoonCalcGobal *sunMoonCalc;
@property (nonatomic, strong) PDDrawMoon *drawMoon;
@property int PDMoonPhase;
@property (nonatomic, strong) PDOverlayView *overlayView;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *planImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapMakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet SSTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *readmoreButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundMapView;
@property (weak, nonatomic) IBOutlet UIView *mapPlaceholderView;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;

@property (strong, nonatomic) IBOutlet UIView *magicHourView;
@property (weak, nonatomic) IBOutlet UILabel *magicHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *blueHourFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;

@property (weak, nonatomic) IBOutlet UILabel *bluehourFirstStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *bluehourFirstEndLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunriseStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseEndLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *goldenHourFirstLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *goldenHourSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *blueHourSecondLabel;

@property (weak, nonatomic) IBOutlet UILabel *goldenHourStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenHourEndLabel;

@property (weak, nonatomic) IBOutlet UILabel *goldenhourSecondStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenhourSecondEndLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunsetStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *bluehourSecondStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *bluehourSecondEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *moonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moonRiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moonSetImageView;
@property (weak, nonatomic) IBOutlet UILabel *moonRiseLabel;
@property (weak, nonatomic) IBOutlet UILabel *moonSetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moonImage;

@property (strong, nonatomic) PDPlan *planEntity;
@property double lat;
@property double lng;
- (IBAction)readmoreButton:(id)sender;
- (IBAction)routePlan:(id)sender;
- (void)setPlan:(PDPlan *)plan;

@end
