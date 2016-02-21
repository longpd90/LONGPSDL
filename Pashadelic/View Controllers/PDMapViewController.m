//
//  PDMapViewController.m
//  Pashadelic
//
//  Created by TungNT2 on 4/25/13.
//
//

#import "PDMapViewController.h"

@interface PDMapViewController (Private)
- (void)centerMapViewCoordinate:(CLLocationCoordinate2D)coordinate isReloadPhotoSpots:(BOOL)isReload;
@end

@implementation PDMapViewController
@synthesize photosMapView;
@synthesize centerMapView;
@synthesize items;

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
    [self setLeftButtonToMainMenu];
    photosMapView = [[PDPhotosMapView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.view.frame.size)];
    photosMapView.itemSelectDelegate = self;
    photosMapView.photoViewDelegate = self;
    photosMapView.bottomYMapButton = 40;
    [self.view addSubview:photosMapView];
    [self.view sendSubviewToBack:photosMapView];
    _isHiddenPhotoSpot = YES;
    _isHiddenSunMoon = YES;
    self.state = PDMapToolStateNormal;
    self.iconCompass = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_map_compass.png"]];
    [self.view addSubview:_iconCompass];
    _iconCompass.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateCompassRad:)
                                                 name:kPDDidUpdateHeading
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mapToolStateChanged:)
                                                 name:kPDUserTrackingModeChangedNotification object:nil];
    [photosMapView addNotification];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDDidUpdateHeading object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPDUserTrackingModeChangedNotification object:nil];
    [photosMapView removeNotification];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    float bottomYPoint = self.view.bottomYPoint - (self.iconCompass.height + PDToolBarViewHeight + 5);
    self.iconCompass.frame = CGRectMake(5, bottomYPoint, self.iconCompass.width, self.iconCompass.height);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self centerMapViewCoordinate:[photosMapView centerMapViewCoordinate] isReloadPhotoSpots:NO];
}

- (void)initialize
{
    [self initLocationService];
}

- (void)refreshView
{
    self.needRefreshView = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelSearch:(id)sender
{}

#pragma mark - Public

- (void)resignCurrentResponder
{
    for (UIView *view in self.view.subviews) {
        if ([view isFirstResponder]) {
            [view resignFirstResponder];
        }
    }
}

#pragma mark - Actions

- (void)setState:(PDMapToolState)state
{
    switch (state) {
        case PDMapToolStateNormal:
            _currentLocation = EmptyLocationCoordinate;
            _searchLocation = EmptyLocationCoordinate;
            break;
        case PDMapToolStateLocationUser:
            _searchLocation = EmptyLocationCoordinate;
            [self cancelSearch:nil];
            break;
        case PDMapToolStateLocationSearch:
            _currentLocation = EmptyLocationCoordinate;
            break;
        default:
            break;
    }
    _state = state;
}

- (void)mapToolStateChanged:(NSNotification *)notification
{
    NSInteger state = [notification.object integerValue];
    if (state == MKUserTrackingModeNone) {
        self.state = PDMapToolStateNormal;
    }
    if (state == MKUserTrackingModeFollowWithHeading) {
        self.iconCompass.hidden = NO;
    } else {
        self.iconCompass.hidden = YES;
    }
}

- (void)setIsHiddenPhotoSpot:(BOOL)newHiddenPhotoSpot
{
    _isHiddenPhotoSpot = newHiddenPhotoSpot;
    [self.photosMapView removePhotoLocationAnnotation];
}

- (void)setIsHiddenSunMoon:(BOOL)isHiddenSunMoon
{
    _isHiddenSunMoon = isHiddenSunMoon;
    if (!_isHiddenSunMoon) {
        if ([self.photosMapView isCoordinate2DValid:[photosMapView sunMoonCoord]]) {
            [photosMapView addAnnotationSunMoonWithCoordinate:[photosMapView sunMoonCoord]];
        } else {
            [photosMapView addAnnotationSunMoonWithCoordinate:[photosMapView centerMapViewCoordinate]];
        }
    } else
        [self.photosMapView resetSunYouCoordinate];
}

- (void)setCurrentLocation:(CLLocationCoordinate2D)newLocation
{
    _currentLocation = newLocation;
    [self centerMapViewCoordinate:newLocation isReloadPhotoSpots:YES];
    [photosMapView resetSunYouCoordinate];
}

- (void)setSearchLocation:(CLLocationCoordinate2D)newLocation
{
    _searchLocation = newLocation;
    self.state = PDMapToolStateLocationSearch;
    [self showMapViewForLocation:_searchLocation andLocation:_searchLocation];
}

- (void)centerMapViewCoordinate:(CLLocationCoordinate2D)coordinate isReloadPhotoSpots:(BOOL)isReload
{
    if ([photosMapView centerMapViewCoordinate].latitude != coordinate.latitude &&
        [photosMapView centerMapViewCoordinate].longitude != coordinate.longitude) {
        if (!_isHiddenPhotoSpot && isReload) {
            [self loadPhotoSpotsForCoordinate:coordinate];
        }
    }
}

- (void)setItems:(NSArray *)newItems
{
    items = newItems;
    self.photosMapView.items = items;
    [self.photosMapView reloadMapWithoutReloadRegion];
}

- (void)showMapViewForLocation:(CLLocationCoordinate2D)firstLocation andLocation:(CLLocationCoordinate2D)secondLocation
{
    CLLocationCoordinate2D maxPosition = CLLocationCoordinate2DMake(-90, -180);
	CLLocationCoordinate2D minPosition = CLLocationCoordinate2DMake(90, 180);
    maxPosition.longitude = MAX(firstLocation.longitude, secondLocation.longitude);
    maxPosition.latitude = MAX(firstLocation.latitude, secondLocation.latitude);
    minPosition.longitude = MIN(firstLocation.longitude, secondLocation.longitude);
    minPosition.latitude = MIN(firstLocation.latitude, secondLocation.latitude);

    MKCoordinateRegion  region = [[PDLocationHelper sharedInstance] regionForMax:maxPosition
                                                                  andMinPosition:minPosition];
    [self centerMapViewCoordinate:region.center isReloadPhotoSpots:YES];
    [self.photosMapView zoomToRegion:region];
}

- (void)loadPhotoSpotsForCoordinate:(CLLocationCoordinate2D)coordinate
{
}


- (void)changeUserTrackingMode
{
    [self.photosMapView changeUserTrackingMode];
    if ([self.photosMapView userTrackingMode] == MKUserTrackingModeFollowWithHeading) {
        _iconCompass.hidden = NO;
    } else
        _iconCompass.hidden = YES;
}

- (void)updateCompassRad:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    float oldRad = [userInfo floatForKey:@"oldRad"];
    float newRad = [userInfo floatForKey:@"newRad"];
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    theAnimation.toValue = [NSNumber numberWithFloat:newRad];
    theAnimation.duration = 0.5f;
    [_iconCompass.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    _iconCompass.transform = CGAffineTransformMakeRotation(newRad);

}

#pragma mark - Item Select Delegate

- (void)itemDidSelect:(PDItem *)item
{
    if ([item isKindOfClass:[PDPhoto class]]) {
        [self showPhoto:(PDPhoto *)item];
    }
}

#pragma mark - Override

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    [self fetchData];
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
        [self fetchData];
    }];
}

#pragma mark - Server Exchange Delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    [super serverExchange:serverExchange didParseResult:result];
    [self.photosMapView setHiddenPhotoAnnotations:_isHiddenPhotoSpot];
}

@end
