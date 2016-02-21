//
//  PDLocationInfoViewController.m
//  Pashadelic
//
//  Created by LongPD on 6/18/14.
//
//

#import "PDLocationInfoViewController.h"
#import "TWRChartView.h"
#import "TWRDataSet.h"
#import "TWRBarChart.h"
#import "PDWeatherLoader.h"
#import "PDLocationViewController.h"
#import "PDLandmarkForecastViewController.h"

@interface PDLocationInfoViewController ()

@property(strong, nonatomic) TWRChartView *chartView;
@property (nonatomic, strong) PDWeatherLoader *weatherLoader;
@property (strong, nonatomic) SunMoonCalcGobal *sunMoonCalc;
@property (strong, nonatomic) NSMutableArray * percentagePerMonth;
@property (strong, nonatomic) NSMutableArray * percentagePerTime;
@property (strong, nonatomic) CLLocation *locationCoordinate;
@end

@implementation PDLocationInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self initLocationTable];
    [self initInterface];
    [self fetchData];
    self.title = NSLocalizedString(@"info", nil);
    _percentagePerMonth = [[NSMutableArray alloc] init];
    _percentagePerTime = [[NSMutableArray alloc] init];
    if (self.location) {
        [self setLocation:self.location];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
    return PDNavigationBarStyleWhite;
}
- (NSString *)pageName
{
    return @"Location Info";
}

- (void)fetchData
{
    [super fetchData];
    self.locationInfoLoader = [[PDLocationInfoLoader alloc] initWithDelegate:self];
    switch (self.location.locationType) {
        case PDLocationTypeCountry:
            [self.locationInfoLoader loadLocationInfoWithName:@"countries" locationID:self.location.identifier];
            break;
        case PDLocationTypeState:
            [self.locationInfoLoader loadLocationInfoWithName:@"states" locationID:self.location.identifier];
            break;
        case PDLocationTypeCity:
            [self.locationInfoLoader loadLocationInfoWithName:@"cities" locationID:self.location.identifier];
            break;
        case PDLocationTypeLandmark:
            [self.locationInfoLoader loadlandmarkWithId:self.location.identifier];
        default:
            break;
    }
}

- (void)dealloc
{
	self.locationMapView.showsUserLocation = NO;
	self.locationMapView.delegate = nil;
	[self.locationMapView removeFromSuperview];
	self.locationMapView = nil;
}

- (void)initInterface
{
    NSMutableAttributedString *forecastString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"forecast 10 day", nil)];
    [forecastString addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                           range:NSMakeRange(0, [forecastString length])];
    self.forecastLabel.attributedText = forecastString;
    _forecastLabel.textColor = kPDGlobalGrayColor;

    _chartView = [[TWRChartView alloc] initWithFrame:_locationMapView.frame];
    _chartView.backgroundColor = [UIColor clearColor];

    NSString *jsFilePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"js"];
    [_chartView setChartJsFilePath:jsFilePath];
    [self.graphicView addSubview:_chartView];
    [self loadBarChartWithMonth:@[@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0]];

    
    [_angleRightImageView setFontAwesomeIconForImage:[FAKFontAwesome angleRightIconWithSize:22] withAttributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
    
    [self.monthButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.monthButton setTitleColor:kPDGlobalGrayColor forState:UIControlStateSelected];

    [self.timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.timeButton setTitleColor:kPDGlobalGrayColor forState:UIControlStateSelected];
    
}

- (void)loadBarChartWithMonth:(NSArray *)photos {
    
    TWRDataSet *dataSet = [[TWRDataSet alloc] initWithDataPoints:photos
                                                        fillColor:[[UIColor colorWithRed:151/255.0 green:187/255.0 blue:205/255.0 alpha:1] colorWithAlphaComponent:0.5]
                                                     strokeColor:[UIColor colorWithRed:151/255.0 green:187/255.0 blue:205/255.0 alpha:1]];
    NSArray *labels = @[@" Jan", @" Feb", @" Mar", @" Apr", @" May",@"Jun", @"Jul", @"Aug", @"Sep", @"Otc", @"Nov", @"Dec"];

    TWRBarChart *bar = [[TWRBarChart alloc] initWithLabels:labels
                                                  dataSets:@[dataSet]
                                                  animated:YES];
    [_chartView loadBarChart:bar];
}

- (void)loadBarChartWithTime:(NSArray *)photos {
    TWRDataSet *dataSet = [[TWRDataSet alloc] initWithDataPoints:photos
                                                       fillColor:[[UIColor orangeColor] colorWithAlphaComponent:0.5]
                                                     strokeColor:[UIColor orangeColor]];
    NSArray *labels = @[@"12am", @"1am", @"2am", @"3am", @"4am",@"5am", @"6am", @"7am", @"8am", @"9am", @"10am", @"11am",@"12pm", @"1pm", @"1pm", @"3pm", @"4pm",@"5pm", @"6pm", @"7pm", @"8pm", @"9pm", @"10pm", @"11pm"];
    
    TWRBarChart *bar = [[TWRBarChart alloc] initWithLabels:labels
                                                  dataSets:@[dataSet]
                                                  animated:YES];
    [_chartView loadBarChart:bar];
}


- (void)refreshView
{
	[super refreshView];
}

- (void)initLocationTable
{
    self.locationTableView = [[PDLocationInfoTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.locationTableView.itemsTableDelegate = self;
	self.itemsTableView = self.locationTableView;
    self.itemsTableView.tableHeaderView = self.headerView;
	[self.tablePlaceholderView addSubview:self.itemsTableView];
}

- (void)setLocation:(PDLocation *)location
{
    _location = location;
    if (self.isViewLoaded) {
        if (self.location.locationType == PDLocationTypeCity) {
            [self searchAddress:self.location.name];
        }
        if (self.location.locationType == PDLocationTypeLandmark) {
            CLLocation *locationLandmark = [[CLLocation alloc] initWithLatitude:self.location.latitude longitude:self.location.longitude];
            [self setRegionCoordinates:locationLandmark.coordinate];
            self.locationCoordinate = locationLandmark;
            [self getMoonSunTimeWithLat:locationLandmark.coordinate.latitude Lng:locationLandmark.coordinate.longitude];
            [self fetchWeatherInfoWithCoordinate:locationLandmark.coordinate];
        }
    }


}

#pragma mark - action

- (IBAction)showGraphicsByMonth:(id)sender {
    if (self.monthButton.selected)
        return;
    self.monthButton.selected =! self.monthButton.selected;
    self.timeButton.selected =! self.timeButton.selected;
    [self loadBarChartWithMonth:self.percentagePerMonth];
}

- (IBAction)showGraphicsByTime:(id)sender {
    if (self.timeButton.selected)
        return;
    self.monthButton.selected =! self.monthButton.selected;
    self.timeButton.selected =! self.timeButton.selected;
    [self loadBarChartWithTime:self.percentagePerTime];
}
    
- (IBAction)forecastWeatherDidClicked:(id)sender {
    PDLandmarkForecastViewController *landmarkForecastViewController = [[PDLandmarkForecastViewController alloc] initForUniversalDevice];
    if (_location.locationType == PDLocationTypeLandmark) {
        _locationCoordinate = [[CLLocation alloc] initWithLatitude:_location.latitude longitude:_location.longitude];
    }
    landmarkForecastViewController.userLocation = _locationCoordinate;
    landmarkForecastViewController.currentDate = [NSDate date];
    [self.navigationController pushViewController:landmarkForecastViewController animated:YES];
    [landmarkForecastViewController fetchData];
}

- (void)searchAddress:(NSString *)searchText
{
	if (searchText.length == 0) return;
	
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	
	[geocoder geocodeAddressString:searchText
						  inRegion:[[PDLocationHelper sharedInstance] convertMapRegion:_locationMapView.region]
				 completionHandler:^(NSArray *placemarks, NSError *error)
	 {
		 if (error) {
			 
			 if (error.code == kCLErrorGeocodeFoundNoResult) {
				 [UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"There was no match.", nil)];
				 
			 } else {
				 [UIAlertView showAlertWithTitle:nil message:error.localizedDescription];
			 }
			 
		 } else {
			 if (placemarks.count > 0) {
				 CLPlacemark *placemark = [placemarks objectAtIndex:0];
				 [self setRegionCoordinates:placemark.location.coordinate];
                 self.locationCoordinate = placemark.location;
                 [self getMoonSunTimeWithLat:placemark.location.coordinate.latitude Lng:placemark.location.coordinate.longitude];
                 [self fetchWeatherInfoWithCoordinate:placemark.location.coordinate];
			 }
		 }
	 }];
}

- (void)getMoonSunTimeWithLat:(float)latitude Lng:(float )longitude
{
    
    if (!_sunMoonCalc) {
        self.sunMoonCalc = [[SunMoonCalcGobal alloc] init];
    }
    [self.sunMoonCalc computeMoonriseAndMoonSet:[self currentDate] withLatitude:latitude withLongitude:longitude];
    [self.sunMoonCalc computeSunriseAndSunSet:[self currentDate] withLatitude:latitude withLongitude:longitude];
    
    BOOL moonRiseBeforeMoonSet = (self.sunMoonCalc.timeRiseMoon.timeIntervalSince1970 < self.sunMoonCalc.timeSetMoon.timeIntervalSince1970);
    
    CGFloat fontSize = 15;
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalComfortColor};
	NSDictionary *yellowColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalYellowColor};
    
	[self.sunRiseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:yellowColorAttribute];
	[self.sunSetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:yellowColorAttribute];
    
	if (moonRiseBeforeMoonSet) {
		[self.moonRiseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:grayColorAttribute];
		[self.moonSetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:grayColorAttribute];
		
	} else {
		[self.moonRiseImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowDownIconWithSize:fontSize] withAttributes:grayColorAttribute];
		[self.moonSetImageView setFontAwesomeIconForImage:[FAKFontAwesome longArrowUpIconWithSize:fontSize] withAttributes:grayColorAttribute];
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

        self.sunRiseLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeRiseSun stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeRiseMoon stringValueFormattedBy:@"mm"]];
        self.sunsetLabel.text = [NSString stringWithFormat:@"%@:%@",[self.sunMoonCalc.timeSetSun stringValueFormattedBy:@"HH"],[self.sunMoonCalc.timeSetMoon stringValueFormattedBy:@"mm"]];
    [self drawMoonPhaseWithLat:latitude withDate:[self currentDate]];

}

- (void)drawMoonPhaseWithLat:(float)lat withDate:(NSDate *)dateC
{
    NSDate *dateC2 = [NSDate dateWithTimeInterval:1 sinceDate:dateC];
    
    double fraction = [_sunMoonCalc getMoonFraction:dateC];
    double fraction2 = [_sunMoonCalc getMoonFraction:dateC2];
    double moonFraction = fraction2 - fraction;
    
    float op = fraction;
    
    [self.drawMoon drawMoon:self.drawMoon.width/2 andOption:op color:kPDGlobalComfortColor];
    [self.drawMoon clearBackgroundColor];
    if (moonFraction > 0)
        _PDMoonPhase = FirstQuarter;
    else
        _PDMoonPhase = Lastquarter;
    
    if (((lat > 0 ) && (_PDMoonPhase == FirstQuarter)) || ((lat < 0) && (_PDMoonPhase == Lastquarter)))
        _drawMoon.transform = CGAffineTransformMakeRotation(M_PI);
    else
        _drawMoon.transform = CGAffineTransformMakeRotation(0);
}

- (void)setRegionCoordinates:(CLLocationCoordinate2D)coordinates
{
	MKCoordinateRegion mapRegion = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(2, 2));
	self.locationMapView.region = mapRegion;
}

- (void)fetchWeatherInfoWithCoordinate:(CLLocationCoordinate2D )coordinate
{
    if (self.weatherLoader) {
        self.weatherLoader.delegate = nil;
        self.weatherLoader = nil;
    }
    self.weatherLoader = [[PDWeatherLoader alloc] initWithDelegate:self];
    [self.weatherLoader loadCurrentWeatherWithLatitude:coordinate.latitude
                                             longitude:coordinate.longitude];
}

# pragma mark - show Location

- (void)itemDidSelect:(PDItem *)item
{
    if ([item isKindOfClass:[PDLocation class]]) {
        PDLocationViewController *locationViewController = [[PDLocationViewController alloc] initWithNibName:@"PDLocationViewController" bundle:nil];
        PDLocation *locationItem = (PDLocation *)item;
        locationViewController.location = locationItem;
        [self.navigationController pushViewController:locationViewController animated:YES];
    }

}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
    
    if ([serverExchange isEqual:self.weatherLoader]) {
        PDWeather *currentWeather = (PDWeather *)[self.weatherLoader loadCurrentWeatherFromResult];
        self.weatherImageView.image = currentWeather.iconImage;
		return;
    } else {
        NSMutableArray *locationItems = [[NSMutableArray alloc] init];
        if ([result objectForKey:@"country"]) {
            PDLocation *countryLocation = [[PDLocation alloc] init];
            [countryLocation loadShortDataFromDictionary:[result objectForKey:@"country"]];
            countryLocation.locationType = PDLocationTypeCountry;
            [locationItems addObject:countryLocation];
        }
        if ([result objectForKey:@"state"]) {
            PDLocation *stateLocation = [[PDLocation alloc] init];
            [stateLocation loadShortDataFromDictionary:[result objectForKey:@"state"]];
            stateLocation.locationType = PDLocationTypeState;
            [locationItems addObject:stateLocation];
        }
        if ([result objectForKey:@"city"]) {
            PDLocation *cityLocation = [[PDLocation alloc] init];
            [cityLocation loadShortDataFromDictionary:[result objectForKey:@"city"]];
            cityLocation.locationType = PDLocationTypeCity;
            [locationItems addObject:cityLocation];
            self.weatherView.hidden = NO;
            self.headerView.height = self.weatherView.bottomYPoint + 5;

        } else {
            self.headerView.height = self.graphicView.bottomYPoint + 5;
            self.weatherView.hidden = YES;
        }
        self.itemsTableView.tableHeaderView = self.headerView;
        
        NSArray *photosEachMonth = [result objectForKey:@"photos_count_each_month"];
        
        int count = 0 ;
        for (int i = 0; i < photosEachMonth.count; i ++) {
            NSNumber *photoOfMonth = [photosEachMonth objectAtIndex:i];
            count = count + photoOfMonth.intValue ;
        }
        
        for (int i = 0; i < photosEachMonth.count; i ++) {
            NSNumber *photoOfMonth = [photosEachMonth objectAtIndex:i];
            float percentageOfMonth = (photoOfMonth.floatValue / count ) * 100;
            [_percentagePerMonth addObject:[NSNumber numberWithFloat:percentageOfMonth]];
        }
        [self loadBarChartWithMonth:_percentagePerMonth];
        
        
        NSArray *photosEachTime = [result objectForKey:@"photos_count_each_time"];
        
        for (int i = 0; i < photosEachTime.count; i ++) {
            NSNumber *photoOfTime = [photosEachTime objectAtIndex:i];
            float percentageOfTime = (photoOfTime.floatValue / count ) * 100;
            [_percentagePerTime addObject:[NSNumber numberWithFloat:percentageOfTime]];
        }
        
        self.items = [NSArray arrayWithArray:locationItems];
        [self refreshView];
    }

}

@end
