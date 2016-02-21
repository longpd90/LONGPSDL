//
//  PDPlanMapViewController.h
//  Pashadelic
//
//  Created by LongPD on 8/12/14.
//
//

#import "PDPhotoToolsViewController.h"
#import "PDDrawMoon.h"
#import "PDPlan.h"

typedef enum MoonPhase {
	FirstQuarter = 0,
	Lastquarter,
}MoonPhase;

@interface PDPlanMapViewController : PDPhotoToolsViewController <UIActionSheetDelegate>

@property (strong, nonatomic) CLLocation *planLocation;
@property (nonatomic, strong) SunMoonCalcGobal *sunMoonCalc;
@property (strong, nonatomic) PDPlan *plan;
@property NSInteger PDMoonPhase;
@property (strong, nonatomic) NSDate *planeDate;
@property (weak, nonatomic) IBOutlet UIImageView *sunriseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunsetImageView;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moonriseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moonsetImageView;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *moonriseLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *moonsetLabel;
@property (weak, nonatomic) IBOutlet PDDrawMoon *draw;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *latLonLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

- (void)loadPlaceWithLatitude:(float)lat andLongitude:(float)lng;
- (IBAction)shareButton:(id)sender;

@end
