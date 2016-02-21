//
//  PDPlanDetailViewController.m
//  Pashadelic
//
//  Created by LongPD on 11/14/13.
//
//

#import "PDPlanDetailViewController.h"
#import "Globals.h"
#import "NSDate+Extra.h"
#define MaxHeightLocationLabel 35
#define MaxHeightDescriptionLabel 40

@interface PDPlanDetailViewController ()

@end

@implementation PDPlanDetailViewController
@synthesize photoMapView,mapPlaceholderView;

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
	self.title = NSLocalizedString(@"plan", nil);
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"magic hour", nil)
                                                               action:@selector(showAndHiddenMagicHourView)]];
    [self setupTopView];
    [self initMapView];

    if (self.planEntity) {
        [self setPlan:self.planEntity];
    }
    [self initLocationService];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[self.photoMapView releaseMemory];
	self.photoMapView = nil;
}


#pragma mark - override

- (NSString *)pageName
{
    return @"Plan Detail";
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

#pragma mark - private

- (void)setupTopView
{
    [self setShawdowStyle:self.topView];
    [self setShawdowStyle:self.readmoreButton];
    self.readmoreButton.hidden = YES;
    [self.readmoreButton setTitle:NSLocalizedString(@"read more", nil) forState:UIControlStateNormal];
  
    CGFloat fontSize = 14;
    NSDictionary *lightGrayColorAttribute = @{NSForegroundColorAttributeName: [UIColor lightGrayColor]};
	[self.timeImageView setFontAwesomeIconForImage:[FAKFontAwesome clockOIconWithSize:fontSize] withAttributes:lightGrayColorAttribute];
	[self.mapMakerImageView setFontAwesomeIconForImage:[FAKFontAwesome mapMarkerIconWithSize:fontSize] withAttributes:lightGrayColorAttribute];
	[self.readmoreButton setFontAwesomeIconForImage:[FAKFontAwesome alignJustifyIconWithSize:15] forState:UIControlStateNormal attributes:lightGrayColorAttribute];
  
    CAShapeLayer *maskLayerOverView = [CAShapeLayer layer];
	maskLayerOverView.frame = self.planImageView.bounds;
	UIBezierPath *roundedPathOverView =
	[UIBezierPath bezierPathWithRoundedRect:maskLayerOverView.bounds
						  byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(4, 4)];
    
    
	maskLayerOverView.path = [roundedPathOverView CGPath];
	
	self.planImageView.layer.mask = maskLayerOverView;
}

- (void)initMapView
{
	photoMapView = [[PDPhotosMapView alloc] initWithFrame:CGRectMakeWithSize(0, 0, mapPlaceholderView.frame.size)];
	[mapPlaceholderView addSubview:photoMapView];
	mapPlaceholderView.layer.cornerRadius = 4;
    mapPlaceholderView.layer.masksToBounds = YES;
    [self setShawdowStyle:self.backgroundMapView];
    self.backgroundMapView.layer.cornerRadius = 4;
	photoMapView.changeMapModeButton.hidden = YES;
    photoMapView.mapView.zoomEnabled = NO;
    photoMapView.mapView.scrollEnabled = NO;
    photoMapView.mapView.userInteractionEnabled = NO;
    
    self.routeButton.layer.cornerRadius = 4;
    self.routeButton.backgroundColor = kPDGlobalRedColor;
    [self.routeButton setTitle:NSLocalizedString(@"route", nil) forState:UIControlStateNormal];
}

- (void)initMagicHourView
{
    self.moonLabel.text = NSLocalizedString(@"moon", nil);
    self.magicHourView.frame = CGRectMake(320, 0, self.magicHourView.width, self.magicHourView.height);
    [self.view addSubview:self.magicHourView];
    NSDate *timePlan = [self localTimeFromUTC:self.planEntity.time];
    CLLocation *planLocation = [[CLLocation alloc]initWithLatitude:self.planEntity.latitude longitude:self.planEntity.longitude];
    [self setupContentMagicHourView:timePlan andLocation:planLocation];
    
}

- (void)receivedLocation
{
	if (!self.view.window) return;
    
    self.routeButton.enabled = YES;
    self.lat = [[PDLocationHelper sharedInstance] latitudes];
    self.lng = [[PDLocationHelper sharedInstance] longitudes];
}

- (void)setupContentMagicHourView:(NSDate *)date andLocation:(CLLocation *)location
{
    _magicHourLabel.text = NSLocalizedString(@"magic hour", nil);
    _blueHourFirstLabel.text = NSLocalizedString(@"blue hour", nil);
    _blueHourSecondLabel.text = NSLocalizedString(@"blue hour", nil);
    _sunriseLabel.text = NSLocalizedString(@"sunrise", nil);
    _sunsetLabel.text = NSLocalizedString(@"sunset", nil);
    _goldenHourFirstLabel.text = NSLocalizedString(@"golden hour", nil);
    _goldenHourSecondLabel.text = NSLocalizedString(@"golden hour", nil);
    _startLabel.text = NSLocalizedString(@"start", nil);
    _endLabel.text = NSLocalizedString(@"end", nil);
    
	CGFloat fontSize = 22;
	NSDictionary *whiteColorAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    float lat = location.coordinate.latitude;
    float lng = location.coordinate.longitude;

    self.sunMoonCalc = [[SunMoonCalcGobal alloc] init];
    [self.sunMoonCalc computeMoonriseAndMoonSet:date withLatitude:lat withLongitude:lng];
    [self.sunMoonCalc computeSunriseAndSunSet:date withLatitude:lat withLongitude:lng];
    
    BOOL moonRiseBeforeMoonSet = (self.sunMoonCalc.timeRiseMoon.timeIntervalSince1970 < self.sunMoonCalc.timeSetMoon.timeIntervalSince1970);
  
	if (moonRiseBeforeMoonSet) {
		[self.moonRiseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		[self.moonSetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		
	} else {
		[self.moonRiseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:whiteColorAttribute];
		[self.moonSetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:whiteColorAttribute];
	}

  
    if (moonRiseBeforeMoonSet) {
        if (self.sunMoonCalc.MoonRise) {
            self.moonRiseLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        }
        if (self.sunMoonCalc.MoonSet)
        {
            self.moonSetLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
        }
    } else {
        if (self.sunMoonCalc.MoonSet == YES ) {
            self.moonRiseLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
        }
        if (self.sunMoonCalc.MoonRise == YES)
        {
            self.moonSetLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        }
    }
    
    if (_sunMoonCalc.todayHaveMoon == YES) {
        if (self.sunMoonCalc.MoonRise == YES ) {
            [self drawMoonPhaseWithLat:lat withDate:self.sunMoonCalc.timeRiseMoon];
        }
        else if (self.sunMoonCalc.MoonSet == YES)
        {
            [self drawMoonPhaseWithLat:lat withDate:self.sunMoonCalc.timeSetMoon];
        }
        else{
            [self drawMoonPhaseWithLat:lat withDate:date];
        }
    }
    
    NSDictionary *sunTimes = [_sunMoonCalc getSunTimesWithDate:date andLatitude:lat andLogitude:lng];

    NSDate *goldenHour =  (NSDate *)[sunTimes objectForKey:@"goldenHour"];
    NSDate *sunriseTime = (NSDate *)[sunTimes objectForKey:@"sunrise"];
    NSDate *sunsetStartTime = (NSDate *)[sunTimes objectForKey:@"sunsetStart"];
    NSDate *sunsetTime = (NSDate *)[sunTimes objectForKey:@"sunset"];
    NSDate *goldenHourEnd = (NSDate *)[sunTimes objectForKey:@"goldenHourEnd"];
    NSDate *sunRiseEndTime = (NSDate *)[sunTimes objectForKey:@"sunriseEnd"];
    NSDate *dawn = (NSDate *)[sunTimes objectForKey:@"dawn"];
    NSDate *dusk = (NSDate *)[sunTimes objectForKey:@"dusk"];

    _bluehourFirstStartLabel.text = [NSString stringWithFormat:@"%@:%@",[dawn stringValueFormattedBy:@"HH"],
                                     [dawn stringValueFormattedBy:@"mm"]];
    _bluehourFirstEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunriseTime stringValueFormattedBy:@"HH"],
                                   [sunriseTime stringValueFormattedBy:@"mm"]];
    _sunriseStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunriseTime stringValueFormattedBy:@"HH"],
                               [sunriseTime stringValueFormattedBy:@"mm"]];
    _sunriseEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunRiseEndTime stringValueFormattedBy:@"HH"],
                             [sunRiseEndTime stringValueFormattedBy:@"mm"]];
    _goldenHourStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunRiseEndTime stringValueFormattedBy:@"HH"],
                                  [sunRiseEndTime stringValueFormattedBy:@"mm"]];
    _goldenHourEndLabel.text = [NSString stringWithFormat:@"%@:%@",[goldenHourEnd stringValueFormattedBy:@"HH"],
                                [goldenHourEnd stringValueFormattedBy:@"mm"]];
    _goldenhourSecondStartLabel.text = [NSString stringWithFormat:@"%@:%@",[goldenHour stringValueFormattedBy:@"HH"],
                                        [goldenHour stringValueFormattedBy:@"mm"]];
    _goldenhourSecondEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetStartTime stringValueFormattedBy:@"HH"],
                                      [sunsetStartTime stringValueFormattedBy:@"mm"]];
    _sunsetStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetStartTime stringValueFormattedBy:@"HH"],
                              [sunsetStartTime stringValueFormattedBy:@"mm"]];
    _sunsetEndLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetTime stringValueFormattedBy:@"HH"],
                            [sunsetTime stringValueFormattedBy:@"mm"]];
    _bluehourSecondStartLabel.text = [NSString stringWithFormat:@"%@:%@",[sunsetTime stringValueFormattedBy:@"HH"],
                                      [sunsetTime stringValueFormattedBy:@"mm"]];
    _bluehourSecondEndLabel.text = [NSString stringWithFormat:@"%@:%@",[dusk stringValueFormattedBy:@"HH"],
                                    [dusk stringValueFormattedBy:@"mm"]];
}

- (void)drawMoonPhaseWithLat:(float)lat withDate:(NSDate *)dateC
{
    NSDate *dateC2 = [NSDate dateWithTimeInterval:1 sinceDate:dateC];
    
    double fraction = [_sunMoonCalc getMoonFraction:dateC];
    double fraction2 = [_sunMoonCalc getMoonFraction:dateC2];
    double moonFraction = fraction2 - fraction;
    
    float op = fraction;
    
    self.drawMoon =[[PDDrawMoon alloc]initWithFrame:self.moonImage.frame  andRadius:self.moonImage.width/2.0 option:op];
    _drawMoon.backgroundColor = [UIColor clearColor];
    [self.magicHourView addSubview:_drawMoon];
    
    if (moonFraction > 0) {
        _PDMoonPhase = FirstQuarter;
    }
    else{
        _PDMoonPhase = Lastquarter;
    }
    if (((lat > 0 ) && (_PDMoonPhase == FirstQuarter)) || ((lat < 0) && (_PDMoonPhase = Lastquarter))) {
        _drawMoon.transform = CGAffineTransformMakeRotation(M_PI);
        
    }
}

#pragma mark - action
- (IBAction)readmoreButton:(id)sender {
    self.descriptionLabel.hidden = YES;
    self.descriptionTextView.hidden = NO;
    self.readmoreButton.hidden = YES;
}

- (IBAction)routePlan:(id)sender {
    [self trackEvent:@"Route to photo"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",
									   self.planEntity.latitude, self.planEntity.longitude,
									   self.lat,
									   self.lng]];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)showAndHiddenMagicHourView
{
    if (self.magicHourView.x == 320) {
        [self showOverlayView];
        [UIView animateWithDuration:0.4 animations:^{
            self.magicHourView.x = 160;
        }];
    }
    else{
        self.overlayView.hidden = YES;
        [UIView animateWithDuration:0.4 animations:^{
            self.magicHourView.x = 320;
        }];
    }
}

- (void)showOverlayView
{
    if (!self.overlayView) {
        self.overlayView = [[PDOverlayView alloc] initWithFrame:CGRectMake(0, 0, 160,self.view.height)];
        self.overlayView.backgroundColor = [UIColor clearColor];
        self.overlayView.delegate = self;
        [self.view addSubview:self.overlayView];
    }
    self.overlayView.hidden = NO;
}

#pragma mark - overlay view delegate

- (void)didTouchesToOverlayView
{
    [self showAndHiddenMagicHourView];
    self.overlayView.hidden = YES;
}

#pragma mark - setup

- (void)setPlan:(PDPlan *)plan
{
    self.planEntity = plan;

    if ([self isViewLoaded]) {
        [self.planImageView sd_setImageWithURL:plan.photo.thumbnailURL placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
        self.nameLabel.text = plan.name;
        self.locationLabel.text = plan.address;
        CGSize locationLabelSize = [self.locationLabel.text sizeWithFont:self.locationLabel.font
                                                    constrainedToSize:CGSizeMake(self.locationLabel.width, 1000)
                                                    lineBreakMode:NSLineBreakByCharWrapping];
        self.locationLabel.height = MIN(locationLabelSize.height , MaxHeightLocationLabel);
        
        [self.descriptionTextView newInterface];
        self.descriptionTextView.layer.cornerRadius = 0;
        self.descriptionTextView.text = plan.description;
        self.descriptionTextView.hidden = YES;
        self.descriptionTextView.editable = NO;

        self.descriptionLabel.text = plan.description;
        CGSize descriptionLabelSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font
                                                    constrainedToSize:CGSizeMake(self.descriptionLabel.width, 1000)
                                                        lineBreakMode:NSLineBreakByCharWrapping];
        self.descriptionLabel.height = MIN(descriptionLabelSize.height, MaxHeightDescriptionLabel);

        if (descriptionLabelSize.height > MaxHeightDescriptionLabel) {
            self.readmoreButton.hidden = NO;
        }
        else {
            self.readmoreButton.hidden = YES;
        }
        NSDate *timePlan = [self localTimeFromUTC:plan.time];
        NSString *montString = [timePlan stringValueFormattedBy:@"MMM"];
        NSString *dayString = [timePlan stringValueFormattedBy:@"dd"];
        NSString *yearString = [timePlan stringValueFormattedBy:@"yyyy"];
        NSString *timeString = [timePlan stringValueFormattedBy:@"HH:mm"];
        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@, %@ %@",montString,dayString,yearString,timeString];
        [photoMapView addAnnotationPlanWithLatitude:plan.latitude withLongitude:plan.longitude withImage:self.planImageView.image];
        [self initMagicHourView];
    }
}

- (void)setShawdowStyle:(UIView *)view
{
    view.layer.cornerRadius = 4;
	view.layer.shadowOffset = CGSizeMake(1, 1);
	view.layer.shadowOpacity = 0.5;
	view.layer.shadowRadius = 3;
	view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
	view.layer.borderColor = [UIColor lightGrayColor].CGColor;
	view.layer.borderWidth = 0.5;
}

- (NSDate *)localTimeFromUTC:(NSString *)utcTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter dateFromString:utcTimeString];
}

#pragma mark - Override

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    [self receivedLocation];
}

- (void)updateLocation
{
    [super updateLocation];
    [[PDLocationHelper sharedInstance] updateLocation:^(NSError *error, CLLocation *location){
        if (error) {
            self.routeButton.enabled = NO;
            [self updateLocationDidFailWithError:error];
            return;
        }
        isLocationReceived = YES;
        [self receivedLocation];
    }];
}

@end
