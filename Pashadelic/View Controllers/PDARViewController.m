//
//  PDARViewController.m
//  Pashadelic
//
//  Created by LongPD on 2/6/14.
//
//

#import "PDARViewController.h"
#import "PDARSunMoonView.h"
#import "SunMoonCalcGobal.h"
#import "UIImage+Extra.h"

@interface PDARViewController ()<PDARDatePickerDelegate>
@property (nonatomic, strong) NSDate *selectedDate;
- (void)initAVCameraView;
- (void)resetAVCameraView;
- (void)teardownAVCapture;
@end

@implementation PDARViewController
@synthesize captureVideoPreviewLayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initAVCameraView];
    [self initARView];
    [self setupContentView];
    self.title = NSLocalizedString(@"SUN/MOON", nil);
    self.customNavigationBar.titleLabel.font = [UIFont fontWithName:PDGlobalLightFontName size:22];
	[self setLeftButtonToMainMenu];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"select date", nil)
                                                               action:@selector(selectDate)]];
    if (self.isWeather)
        [self setIsWeather:self.isWeather];
    else
        _date = [NSDate date];

    _dateFormater = [[NSDateFormatter alloc] init];
    [_dateFormater setDateStyle:NSDateFormatterLongStyle];
    [_dateFormater setTimeStyle:NSDateFormatterShortStyle];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(panRecognized:)];
    [panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:panRecognizer];
    [self initLocationService];
    _overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_overlayView];
    [self setBrightnessOfView:0];
//    [self updateLocation];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self resetAVCameraView];
    [self refreshView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self teardownAVCapture];
}

- (void)viewWillLayoutSubviews
{
    self.captureVideoPreviewLayer.frame = self.view.zeroPositionFrame;
    self.arView.frame = self.view.zeroPositionFrame;
    self.overlayView.frame = self.view.zeroPositionFrame;
    float yOfInfoView = _bellowView.frame.origin.y - _infoView.frame.size.height / 2;
    _infoView.center = CGPointMake(_infoButton.center.x - 10, yOfInfoView);
    if (_infoButton.selected) {
        _infoView.alpha = 0;
    }
    else _infoView.alpha = 1;
    [self.view addSubview:_infoView];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setIsWeather:(BOOL)isWeather
{
    _isWeather = isWeather;
    if (self.isViewLoaded) {
        if (self.isWeather)
            [self setupARWeatherView];
        else
            _date = [NSDate date];
    }
}

#pragma mark - override

- (NSString *)pageName
{
    return @"AR View";
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)refreshView
{
    [_dateFormater setLocale:[NSLocale currentLocale]];
    _dateLabel.text = [_dateFormater stringFromDate:_date];
    self.arView.date = _date;
    [self.arView refresh];
    self.resetButton.hidden = YES;
}

#pragma mark - private

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerRetro];
}

- (void)setupARWeatherView
{
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    self.resetButton.hidden = YES;
    self.dateLabel.x = 70;
    [self setRightBarButtonToButton:nil];
    self.dateLabel.text = [_dateFormater stringFromDate:_date];
    self.arView.date = _date;
    [self.arView refresh];
}

- (void)initARView
{
    self.arView = [[PDARView alloc] initWithFrame:self.view.zeroPositionFrame];
    self.arView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.arView];
}

- (void)initAVCameraView
{
    self.captureManager = [[PDCaptureSessionManager alloc] init];
    [self.captureManager setupSession];
    
	self.captureVideoPreviewLayer = self.captureManager.previewLayer;
    [self.captureVideoPreviewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [self.captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CALayer *rootLayer = [self.view layer];
    [rootLayer setMasksToBounds:YES];
    [self.captureVideoPreviewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:self.captureVideoPreviewLayer];
}

- (void)resetAVCameraView
{
    if (!self.captureManager) {
        [self initAVCameraView];
    }
    [self.captureManager startSession];
    [self.arView startRunning];
    [self.view bringSubviewToFront:self.overlayView];
    [self.view bringSubviewToFront:self.arView];
    [self.view bringSubviewToFront:self.topView];
    [self.view bringSubviewToFront:self.bellowView];
}

- (void)teardownAVCapture
{
    [self.arView stopRunning];
    [self.captureManager stopSession];
}

- (void)setupContentView
{
    [self.gridButton setTitle:NSLocalizedString(@"none", nil) forState:UIControlStateNormal];
    self.gridButton.showsTouchWhenHighlighted = YES;

    [self.resetButton setBackgroundColor:kPDGlobalRedColor];
    [self.resetButton setTitle:NSLocalizedString(@"reset", nil) forState:UIControlStateNormal];
    
	CGFloat fontSize = 17;
	NSDictionary *whiteColorAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self.sunButton setTitle:NSLocalizedString(@"off", nil) forState:UIControlStateNormal];
    [self.sunButton setTitle:NSLocalizedString(@"on", nil) forState:UIControlStateSelected];
	[self.sunButton setFontAwesomeIconForImage:[FAKFontAwesome sunOIconWithSize:fontSize]
                                      forState:UIControlStateNormal
                                    attributes:whiteColorAttribute];
  
    [self.moonButton setTitle:NSLocalizedString(@"off", nil) forState:UIControlStateNormal];
    [self.moonButton setTitle:NSLocalizedString(@"on", nil) forState:UIControlStateSelected];
    self.moonButton.showsTouchWhenHighlighted = YES;
	[self.moonButton setFontAwesomeIconForImage:[FAKFontAwesome moonOIconWithSize:fontSize]
                                       forState:UIControlStateNormal
                                     attributes:whiteColorAttribute];
	
    self.gridButton.showsTouchWhenHighlighted = YES;
	[self.gridButton setFontAwesomeIconForImage:[FAKFontAwesome adjustIconWithSize:fontSize]
                                       forState:UIControlStateNormal
                                     attributes:whiteColorAttribute];
  
    [self.infoButton setTitle:NSLocalizedString(@"off", nil) forState:UIControlStateNormal];
    [self.infoButton setTitle:NSLocalizedString(@"on", nil) forState:UIControlStateSelected];
    self.infoButton.showsTouchWhenHighlighted = YES;
	[self.infoButton setFontAwesomeIconForImage:[FAKFontAwesome infoCircleIconWithSize:fontSize]
                                           forState:UIControlStateNormal
                                     attributes:whiteColorAttribute];
    
    _blueHourFirstLabel.text = NSLocalizedString(@"blue hour", nil);
    _blueHourSecondLabel.text = NSLocalizedString(@"blue hour", nil);
    _goldenHourFirstLabel.text = NSLocalizedString(@"golden hour", nil);
    _goldenHourSecondLabel.text = NSLocalizedString(@"golden hour", nil);

    
}

- (void)setBrightnessOfView:(int)type
{
    switch (type) {
        case 0:
            _overlayView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
            break;
        case 1:
        {
            _overlayView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
            break;
        }
        case 2:
            _overlayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
            break;
        default:
            break;
    }
}

#pragma mark - action

- (IBAction)resetTimeToNow:(id)sender {
    if (!self.resetButton.hidden) {
        self.resetButton.hidden = YES;
        NSDate *now = [NSDate date];
        _dateLabel.text = [_dateFormater stringFromDate:now];
        self.arView.date = now;
        [self.arView refresh];
    }
    [self trackEvent:@"Now"];
}

- (IBAction)showHiddenSun:(id)sender {
    self.sunButton.selected = !self.sunButton.selected;
    [self.arView hiddenSun:!self.sunButton.selected];

}

- (IBAction)showHiddenMoon:(id)sender {
    self.moonButton.selected = !self.moonButton.selected;
    [self.arView hiddenMoon:!self.moonButton.selected];
}

- (IBAction)showHiddenGird:(id)sender {
    if ([self.gridButton.title isEqualToString:NSLocalizedString(@"white", nil)]) {
        [self.gridButton setTitle:NSLocalizedString(@"black", nil) forState:UIControlStateNormal];
        [self setBrightnessOfView:2];
    } else if ([self.gridButton.title isEqualToString:NSLocalizedString(@"black", nil)]) {
        [self.gridButton setTitle:NSLocalizedString(@"none", nil) forState:UIControlStateNormal];
        [self setBrightnessOfView:0];
    } else if ([self.gridButton.title isEqualToString:NSLocalizedString(@"none", nil)]) {
        [self.gridButton setTitle:NSLocalizedString(@"white", nil) forState:UIControlStateNormal];
        [self setBrightnessOfView:1];
    }
}

- (IBAction)showInfoView:(id)sender {
    self.infoButton.selected = !self.infoButton.selected;
    [self updateInfoView];
    if (!_infoButton.selected) {
        [self animatePopUpShow];
    }
    else {
        [self animatePopUpHide];
    }
    
}

- (void) animatePopUpShow {
    _infoView.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    _infoView.alpha = 0;
    _infoView.alpha = 1;
    [UIView commitAnimations];
}

- (void)animatePopUpHide {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    _infoView.alpha = 1;
    _infoView.alpha = 0;
    [UIView commitAnimations];
}

- (void)updateInfoView
{
    SunMoonCalcGobal *sunMoonCal = [[SunMoonCalcGobal alloc] init];
    double latitude = [[PDLocationHelper sharedInstance] latitudes];
    double longitude = [[PDLocationHelper sharedInstance] longitudes];
    NSDictionary *sunTimes = [sunMoonCal getSunTimesWithDate:_date andLatitude:latitude andLogitude:longitude];
    NSDate *dawn =  [sunTimes objectForKey:@"dawn"];
    NSDate *sunriseTime = [sunTimes objectForKey:@"sunrise"];
    NSDate *sunRiseEndTime = [sunTimes objectForKey:@"sunriseEnd"];
    NSDate *goldenHourEnd = [sunTimes objectForKey:@"goldenHourEnd"];
    NSDate *goldenHour = [sunTimes objectForKey:@"goldenHour"];
    NSDate *sunsetStartTime = [sunTimes objectForKey:@"sunsetStart"];
    NSDate *sunsetTime = [sunTimes objectForKey:@"sunset"];
    NSDate *dusk = [sunTimes objectForKey:@"dusk"];
    
    _blueHourFirstStart.text      = [self stringValueFormattedBy:@"HH:mm" andDate:dawn];
    _blueHourFirstEnd.text        = [self stringValueFormattedBy:@"HH:mm" andDate:sunriseTime];
    _goldenHourFirstStart.text    = [self stringValueFormattedBy:@"HH:mm" andDate:sunRiseEndTime];
    _goldenHourFirstEnd.text      = [self stringValueFormattedBy:@"HH:mm" andDate:goldenHourEnd];
    _goldenHourSecondStart.text   = [self stringValueFormattedBy:@"HH:mm" andDate:goldenHour];
    _goldenHourSencondEnd.text    = [self stringValueFormattedBy:@"HH:mm" andDate:sunsetStartTime];
    _blueHourSecondStart.text     = [self stringValueFormattedBy:@"HH:mm" andDate:sunsetTime];
    _blueHourSecondEnd.text       = [self stringValueFormattedBy:@"HH:mm" andDate:dusk];
    
}

- (NSString *)stringValueFormattedBy:(NSString *)formatString andDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}

#pragma mark - UIGestureRecognizer delegate

-(void)panRecognized:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.selectedDate = [_dateFormater dateFromString:_dateLabel.text];
    }
    self.resetButton.hidden = NO;
	NSDate *d1;
    CGPoint distance = [sender translationInView:self.view];

    if (fabs(atan(distance.x/distance.y))<0.3) {
        d1 = [self.selectedDate dateByAddingTimeInterval: - 3600 * round(distance.y/35)];
    } else
        if (fabs(atan(distance.x/distance.y))>1.3) {
            d1 = [self.selectedDate dateByAddingTimeInterval: distance.x * 15];
        }
        else
        {
            self.selectedDate = [_dateFormater dateFromString:_dateLabel.text];
            d1 = self.selectedDate;
        }
    _dateLabel.text = [_dateFormater stringFromDate:d1];
    self.arView.date = d1;
    [self.arView refreshNow];
    [self.arView updateNowOfPointCoordinates];
    self.date = d1;
    [self updateInfoView];
    if (sender.state == UIGestureRecognizerStateEnded) {
        [sender cancelsTouchesInView];
    }
}

#pragma mark - action

- (void)selectDate
{
    if (!_datePicker) {
        _datePicker = [[PDARDatePicker alloc] initWithFrame:CGRectMakeWithSize(0, self.view.height, self.view.frame.size)
                                                    andDate:[_dateFormater dateFromString:_dateLabel.text]] ;
        [self.view addSubview:_datePicker];
        [self.view bringSubviewToFront:_datePicker];
        _datePicker.delegate = self;
    }
    [_datePicker setDate:[_dateFormater dateFromString:_dateLabel.text]];
    
    if (!_datePickerShowing) {
        [self showDatePicker];
    }else{
        [self hideDatePicker];
    }
}

#pragma mark - date picker delegate

- (void)clickDoneBtnWithDate:(NSDate *)date
{
    [self hideDatePicker];
    if ([_dateLabel.text isEqualToString:[_dateFormater stringFromDate:date]]) return;
    _dateLabel.text = [_dateFormater stringFromDate:date];
    [self trackEvent:[NSString stringWithFormat:@"selected date:%@", _dateLabel.text]];
    self.arView.date = date;
    [self.arView refresh];
    self.date =date;
    [self updateInfoView];
    self.resetButton.hidden = NO;
}

- (void)didTouchesScreen
{
    [self hideDatePicker];
}

#pragma mark - show and hidden date picker

- (void)showDatePicker
{
    _datePickerShowing = YES;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _datePicker.y = 0;
                         [self.view bringSubviewToFront:_datePicker];
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)hideDatePicker
{
    _datePickerShowing = NO;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _datePicker.y =  self.view.bounds.size.height;
                     }
                     completion:^(BOOL finished){
                     }];
}

#pragma mark - Override

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    double latitude = [[PDLocationHelper sharedInstance] latitudes];
    double longitude = [[PDLocationHelper sharedInstance] longitudes];
    [self.arView updateARViewWithLatitude:latitude longitude:longitude];
}

- (void)updateLocation
{
    [super updateLocation];
    [[PDLocationHelper sharedInstance] updateLocation:^(NSError *error, CLLocation *location){
        if (error) {
            [self updateLocationDidFailWithError:error];
            return;
        }
        isLocationReceived = YES;
        [self.arView updateARViewWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        [self updateInfoView];
    }];
}

- (void)locationChanged:(NSNotification *)notification
{
    [super locationChanged:notification];
    NSDictionary *locationInfo = notification.userInfo;
    CLLocation *location = [locationInfo objectForKey:@"location"];
    [self.arView updateARViewWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
}

@end
