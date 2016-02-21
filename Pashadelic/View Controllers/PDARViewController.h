//
//  PDARViewController.h
//  Pashadelic
//
//  Created by LongPD on 2/6/14.
//
//

#import "PDViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PDCaptureSessionManager.h"
#import "PDARView.h"
#import "PDARDatePicker.h"

@interface PDARViewController : PDViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *blueHourFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueHourFirstStart;
@property (weak, nonatomic) IBOutlet UILabel *blueHourFirstEnd;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *goldenHourFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenHourFirstStart;
@property (weak, nonatomic) IBOutlet UILabel *goldenHourFirstEnd;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *goldenHourSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldenHourSecondStart;
@property (weak, nonatomic) IBOutlet UILabel *goldenHourSencondEnd;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *blueHourSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *blueHourSecondStart;
@property (weak, nonatomic) IBOutlet UILabel *blueHourSecondEnd;

@property (strong, nonatomic) NSDate *date;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bellowView;
@property (weak, nonatomic) IBOutlet UIButton *sunButton;
@property (weak, nonatomic) IBOutlet UIButton *moonButton;
@property (weak, nonatomic) IBOutlet UIButton *gridButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;


@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) PDCaptureSessionManager *captureManager;
@property (strong, nonatomic) PDARView *arView;
@property (strong, nonatomic) PDARDatePicker* datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormater;
@property (assign, nonatomic) BOOL datePickerShowing;
@property (assign, nonatomic) BOOL isWeather;
@property (strong, nonatomic) UIView *overlayView;
- (void)setupARWeatherView;
- (IBAction)resetTimeToNow:(id)sender;
- (IBAction)showHiddenSun:(id)sender;
- (IBAction)showHiddenMoon:(id)sender;
- (IBAction)showHiddenGird:(id)sender;
- (IBAction)showInfoView:(id)sender;

@end
