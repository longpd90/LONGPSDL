//
//  PDLandmarkViewController.m
//  Pashadelic
//
//  Created by TungNT2 on 6/16/14.
//
//

#import "PDLocationViewController.h"
#import "PDPOIItem.h"
#import "PDLocationInfoViewController.h"
#import "PDUserViewController.h"
#import "PDLandmarkPhotospotsViewController.h"
#import "PDLandmarkPhotographersViewController.h"
#import "PDLocationPhotosMapViewController.h"
#import "PDLandmarkMapViewController.h"
#import "PDListLandmarkViewController.h"
#import "NSString+Date.h"
#import "TWRChartView.h"
#import "TWRDataSet.h"
#import "TWRBarChart.h"
#import "PDWeatherLoader.h"
#import "PDLandmarkForecastViewController.h"
#import "PDLocationInfoLoader.h"

#define kPDHeightForViewNoItem 30

@interface PDLocationViewController ()
@property(strong, nonatomic) TWRChartView *chartView;
@property (nonatomic, strong) PDWeatherLoader *weatherLoader;
@property (strong, nonatomic) PDLocationInfoLoader *locationInfoLoader;
@property (strong, nonatomic) SunMoonCalcGobal *sunMoonCalc;
@property (strong, nonatomic) NSMutableArray * percentagePerMonth;
@property (strong, nonatomic) NSMutableArray * percentagePerTime;
@property (strong, nonatomic) CLLocation *locationCoordinate;
@property (nonatomic) float locationViewHeight;
- (void)initInterface;

@end

@implementation PDLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    _percentagePerMonth = [[NSMutableArray alloc] init];
    _percentagePerTime = [[NSMutableArray alloc] init];

    if (self.location) {
        self.location = self.location;
    }
    [self initLocationTable];
    [self initInterface];
    [self layoutSubViews];
    [self refetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.customNavigationBar.titleButton.hidden = YES;
    [self layoutSubViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.locationView.height = self.locationViewHeight;
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
    return PDNavigationBarStyleWhite;
}

- (void)setLocation:(PDLocation *)location
{
    _location = location;
    if (self.isViewLoaded) {
        self.title = location.name;
        [self loadDataWithSetLocation];
    }
}

- (void)loadDataWithSetLocation
{
    if (self.location.locationType != PDLocationTypeLandmark) {
        [self searchAddress:self.location.name];
    }
    if (self.location.locationType == PDLocationTypeLandmark) {
        CLLocation *locationLandmark = [[CLLocation alloc] initWithLatitude:self.location.latitude longitude:self.location.longitude];
        [self setRegionCoordinates:locationLandmark.coordinate andRadius:0];
        self.locationCoordinate = locationLandmark;
        [self getMoonSunTimeWithLat:locationLandmark.coordinate.latitude Lng:locationLandmark.coordinate.longitude];
        [self fetchWeatherInfoWithCoordinate:locationLandmark.coordinate];
    }

}

- (NSString *)pageName
{
    switch (self.location.locationType) {
        case PDLocationTypeCountry:
            return @"Country";
            break;
        case PDLocationTypeState:
            return @"State";
            break;
        case PDLocationTypeCity:
            return @"City";
            break;
        case PDLocationTypeLandmark:
            return @"Landmark";
        default:
            return nil;
            break;
    }
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

- (void)showLocationInfoView
{
    PDLocationInfoViewController *locationInfoViewcontroller = [[PDLocationInfoViewController alloc] initWithNibName:@"PDLocationInfoViewController" bundle:nil];
    locationInfoViewcontroller.location = self.location;
    [self.navigationController pushViewController:locationInfoViewcontroller animated:YES];
}

#pragma Init interface

- (void)initPhotosTable
{
    [super initPhotosTable];
}

- (void)initLocationTable
{
    self.locationTableView = [[PDLocationInfoTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.locationTableView.itemsTableDelegate = self;
    self.itemsTableView.tableHeaderView = self.locationView;
	[self.tablePlaceholderView addSubview:self.locationTableView];
    self.itemsTableView = self.locationTableView;
}

- (void)initInterface
{
    [self initPopularPhotospotsScrollView];
    if (self.location.locationType == PDLocationTypeLandmark) {
        self.viewOnMapView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.viewOnMapView.layer.masksToBounds = YES;
        self.viewOnMapView.layer.borderWidth = 2.0;
    }
    
    NSMutableAttributedString *seeAllString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"see all", nil)];
    
    [seeAllString addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                         range:NSMakeRange(0, [seeAllString length])];
    
    [self.seeAllLandmarksButton setAttributedTitle:seeAllString forState:UIControlStateNormal];
    [self.seeAllPhotospotsButton setAttributedTitle:seeAllString forState:UIControlStateNormal];
    [self.seeAllPhotographersButton setAttributedTitle:seeAllString forState:UIControlStateNormal];
    
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalGrayColor};
	CGFloat fontSize = 16;
    [self.iconPhotospotsImageView setFontAwesomeIconForImage:[FAKFontAwesome pictureOIconWithSize:fontSize]
                                              withAttributes:grayColorAttribute];
    
    [self.iconPhotographersImageView setFontAwesomeIconForImage:[FAKFontAwesome usersIconWithSize:fontSize]
                                                 withAttributes:grayColorAttribute];
    
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:3];
    for (int i = 1; i <= 3; i++) {
        [array1 addObject:[self.locationView viewWithTag:i]];
    }
    self.landmarkImages = array1;
    
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:3];
    for (int i = 4; i <= 6; i++) {
        [array2 addObject:[self.locationView viewWithTag:i]];
    }
    self.photospotImages = array2;
    
    NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:3];
    for (int i = 7; i <= 9; i++) {
        [array3 addObject:[self.locationView viewWithTag:i]];
    }
    self.photographerImages = array3;
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

- (void)initPopularPhotospotsScrollView
{
    self.popularPhotospotsScrollView.photoViewDelegate = self;
    self.popularPhotospotsScrollView.scrollViewDelegate = self;
    self.ownerAvatarButton.clipsToBounds = YES;
}

#pragma Private

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
				 [self setRegionCoordinates:placemark.location.coordinate andRadius:placemark.region.radius];
                 self.locationCoordinate = placemark.location;
                 [self getMoonSunTimeWithLat:placemark.location.coordinate.latitude Lng:placemark.location.coordinate.longitude];
                 [self fetchWeatherInfoWithCoordinate:placemark.location.coordinate];
			 }
		 }
	 }];
}

- (void)setRegionCoordinates:(CLLocationCoordinate2D)coordinates andRadius:(CLLocationDistance)radius
{
    MKCoordinateRegion mapRegion;
    if (radius != 0) {
        mapRegion = MKCoordinateRegionMakeWithDistance(coordinates, radius, radius);
    } else
        mapRegion = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.05, 0.05));
	self.locationMapView.region = mapRegion;
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
    if (((lat > 0 ) && (moonFraction >= 0)) || ((lat < 0) && (moonFraction < 0)))
        _drawMoon.transform = CGAffineTransformMakeRotation(M_PI);
    else
        _drawMoon.transform = CGAffineTransformMakeRotation(0);
}

#pragma Override
- (void)fetchData
{
		self.title = self.location.name;
    [super fetchData];
    self.loading = YES;
    if (self.locationLoader) {
        [self.locationLoader cancel];
        self.locationLoader = nil;
    }
    self.locationLoader = [[PDServerLocationLoader alloc] initWithDelegate:self];
    self.locationInfoLoader = [[PDLocationInfoLoader alloc] initWithDelegate:self];
    switch (self.location.locationType) {
        case PDLocationTypeCountry:
            [self.locationLoader loadLocationWithName:@"countries" locationID:self.location.identifier page:self.currentPage];
            [self.locationInfoLoader loadLocationInfoWithName:@"countries" locationID:self.location.identifier];
            break;
        case PDLocationTypeState:
            [self.locationInfoLoader loadLocationInfoWithName:@"states" locationID:self.location.identifier];
            [self.locationLoader loadLocationWithName:@"states" locationID:self.location.identifier page:self.currentPage];
            break;
        case PDLocationTypeCity:
            [self.locationInfoLoader loadLocationInfoWithName:@"cities" locationID:self.location.identifier];
            [self.locationLoader loadLocationWithName:@"cities" locationID:self.location.identifier page:self.currentPage];
            break;
        case PDLocationTypeLandmark:
            [self.locationInfoLoader loadlandmarkWithId:self.location.identifier];
            [self.locationLoader loadlandmarkWithId:self.location.identifier];
        default:
            break;
    }
    
}

- (void)layoutSubViews
{
    self.locationInfoView.y = self.previewMapView.y = self.landmarksView.y = self.popularPhotospotsScrollView.bottomYPoint + 10;
    if (self.location.locationType == PDLocationTypeCountry || self.location.locationType == PDLocationTypeState) {
        self.locationInfoView.height = self.graphicView.height + 5;
        self.weatherView.hidden = YES;
    }

    if (self.location.locationType == PDLocationTypeLandmark) {
        self.landmarksView.hidden = YES;
        self.locationInfoView.y = self.previewMapView.bottomYPoint + 10;
        self.photospotsView.y = self.locationInfoView.bottomYPoint + 10;
    } else {
        if (self.location.landmarksCount == 0)
            self.landmarksView.height = kPDHeightForViewNoItem;
        else
            self.landmarksView.height = 128;
        if (self.weatherView.hidden)
            self.landmarksView.y = self.locationInfoView.bottomYPoint + 5;
        else
            self.landmarksView.y = self.locationInfoView.bottomYPoint + 10;
        
        self.photospotsView.y = self.landmarksView.bottomYPoint + 10;
        
        if (self.location.photosCount == 0) {
            self.photospotsSubview.height = kPDHeightForViewNoItem;
        } else self.photospotsSubview.height = 128;
        
        if (self.location.photographersCount == 0) {
            self.photographersView.height = kPDHeightForViewNoItem;
        } else self.photographersView.height = 62;
        
        self.photographersView.y = self.photospotsSubview.bottomYPoint + 10;
        self.photospotsView.height = self.photographersView.bottomYPoint;
    }
    
    self.locationView.height = self.photospotsView.bottomYPoint + 5;
    self.locationViewHeight = self.locationView.height;
    self.itemsTableView.tableHeaderView = self.locationView;
    [self.photosTableView reloadData];

}

- (void)refreshView
{
    [super refreshView];
		self.title = self.location.name;
    [self refreshPhotospotsScrollView];
    [self refreshPreviewMapView];
    [self refreshLandmarksView];
    [self refreshPhotospotsView];
    [self refreshPhotographerView];
    [self layoutSubViews];
}

- (void)refreshPhotospotsScrollView
{
    self.popularPhotospotsScrollView.photos = self.location.photos;
    [self.popularPhotospotsScrollView refreshScrollView];
}

- (void)refreshOwnerUserForPhoto:(PDPhoto *)photo
{
    [self.ownerAvatarButton sd_setImageWithURL:photo.user.thumbnailURL
                                   forState:UIControlStateNormal
                           placeholderImage:[UIImage imageNamed:@"profile_image_holder_thumb.png"]];
    self.dateTimeTakenOnLabel.text = [NSString stringSuffixDateWithUTCDateString:photo.date];
}

- (void)refreshPreviewMapView
{
    if (self.location.locationType != PDLocationTypeLandmark)
        self.previewMapView.hidden = YES;
    else {
        self.previewMapView.hidden = NO;
        [self.viewOnMapButton sd_setImageWithURL:[NSURL URLWithString:self.location.mapImageURLString] forState:UIControlStateNormal];
    }
}

- (void)refreshLandmarksView
{
    if (self.location.landmarksCount == 0)
        self.seeAllLandmarksButton.hidden = YES;
    else
        self.seeAllLandmarksButton.hidden = NO;
    if (self.location.locationType != PDLocationTypeLandmark) {
        self.landmarksView.hidden = NO;
        if (self.location.landmarksCount > 1)
            self.numberLandmarksLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d landmarks", nil), self.location.landmarksCount];
        else
            self.numberLandmarksLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d landmark", nil), self.location.landmarksCount];
        [self loadLandmarkPhotos];
    } else
        self.landmarksView.hidden = YES;
}

- (void)refreshPhotospotsView
{
    if (self.location.photosCount == 0)
        self.seeAllPhotospotsButton.hidden = YES;
    else
        self.seeAllPhotospotsButton.hidden = NO;
    if (self.location.photosCount > 1)
        self.numberPhotospotsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photospots", nil), self.location.photosCount];
    else
        self.numberPhotospotsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photospot", nil), self.location.photosCount];
    [self loadPhotospotsPhotos];
}

- (void)refreshPhotographerView
{
    if (self.location.photographersCount == 0)
        self.seeAllPhotographersButton.hidden = YES;
    else
        self.seeAllPhotographersButton.hidden = NO;
    if (self.location.photographersCount > 1)
        self.numberPhotographersLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photographers", nil), self.location.photographersCount];
    else
        self.numberPhotographersLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photographer", nil), self.location.photographersCount];
    [self loadUserPhotos];
}

- (void)loadLandmarkPhotos
{
    for (int i = 0; i < self.location.landmarks.count; i++) {
		UIImageView *photoImageView = self.landmarkImages[i];
        PDPOIItem *poiItem = (PDPOIItem *)self.location.landmarks[i];
		if (i < self.location.landmarks.count) {
			[photoImageView sd_setImageWithURL:[NSURL URLWithString:poiItem.avatarTileURL] placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
		} else {
			photoImageView.image = nil;
		}
	}
}

- (void)loadPhotospotsPhotos
{
    for (int i = 0; i < self.photospotImages.count; i++) {
		UIImageView *photoImageView = self.photospotImages[i];
		if (i < self.location.photos.count) {
            PDPhoto *photo = (PDPhoto *)self.location.photos[i];
			[photoImageView sd_setImageWithURL:photo.thumbnailURL placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
		} else {
			photoImageView.image = nil;
		}
	}
}

- (void)loadUserPhotos
{
    for (int i = 0; i < self.photospotImages.count; i++) {
		UIImageView *photoImageView = self.photographerImages[i];
		if (i < self.location.photographers.count) {
            PDUser *user = (PDUser *)self.location.photographers[i];
			[photoImageView sd_setImageWithURL:user.thumbnailURL placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
		} else {
			photoImageView.image = nil;
		}
	}
}

#pragma Action

- (void)rightBarButtonDidClicked:(id)sender
{}

- (IBAction)ownerAvatarButtonDidClicked:(id)sender {
//    PDUserViewController *userViewController = [[PDUserViewController alloc] initForUniversalDevice];
}

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

- (IBAction)goToMap:(id)sender {
    PDLandmarkMapViewController *landmarkMapViewController = [[PDLandmarkMapViewController alloc] initForUniversalDevice];
    landmarkMapViewController.location = self.location;
    [self.navigationController pushViewController:landmarkMapViewController animated:YES];
}


- (IBAction)seeAllLandmarksButtonClicked:(id)sender {
    if (self.location.landmarksCount == 0) return;
    PDListLandmarkViewController *listLandmarkViewController = [[PDListLandmarkViewController alloc] initForUniversalDevice];
    listLandmarkViewController.location = self.location;
    [self.navigationController pushViewController:listLandmarkViewController animated:YES];
}

- (IBAction)seeAllPhotospotsButtonClicked:(id)sender {
    if (self.location.photosCount == 0) return;
    PDLandmarkPhotospotsViewController *photospotsViewController = [[PDLandmarkPhotospotsViewController alloc] initWithNibName:@"PDLandmarkPhotospotsViewController" location:self.location];
    [self.navigationController pushViewController:photospotsViewController animated:YES];
}

- (IBAction)seeAllPhotographersButtonClicked:(id)sender {
    if (self.location.photographersCount == 0) return;
    PDLandmarkPhotographersViewController *photographersViewController = [[PDLandmarkPhotographersViewController alloc] initForUniversalDevice];
    photographersViewController.location = self.location;
    [self.navigationController pushViewController:photographersViewController animated:YES];
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

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.popularPhotospotsScrollView.width;
    int page = floor((self.popularPhotospotsScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.popularPhotospotsScrollView changePage:page];
}

- (void)itemsTableDidScroll:(PDItemsTableView *)itemsTableView
{
    [super itemsTableDidScroll:itemsTableView];
    self.locationView.height = self.locationViewHeight;
}

#pragma mark - Server Exchange delegate

- (void)serverExchange:(id)serverExchange didParseResult:(id)result
{
    [super serverExchange:serverExchange didParseResult:result];
    if ([serverExchange isEqual:self.locationLoader]) {
        [self.location loadFullDataFromDictionary:result];
        [self loadDataWithSetLocation];
    }
    if ([serverExchange isEqual:self.weatherLoader]) {
        PDWeather *currentWeather = (PDWeather *)[self.weatherLoader loadCurrentWeatherFromResult];
        self.weatherImageView.image = currentWeather.iconImage;
		return;
    } else if ([serverExchange isEqual:self.locationInfoLoader]){
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
        } else {
            self.weatherView.hidden = YES;
        }
        
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
    }
    [self refreshView];
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error
{
    [super serverExchange:serverExchange didFailWithError:error];
}

@end
