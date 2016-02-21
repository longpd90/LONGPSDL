//
//  PDLocationSelectViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 23/10/12.
//
//

#import "PDLocationSelectViewController.h"

#define kPDMinCoordinatesSpan 0.1

@interface PDLocationSelectViewController ()
- (void)initSearchBar;
- (void)addTapGestureToMapView;
- (void)showSearchActivity;
- (void)initMapView;
- (void)toggleMapViewMode:(id)sender;
@end

@implementation PDLocationSelectViewController

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
    [self initSearchBar];
	_searchAddressTextField.clearsOnBeginEditing = NO;
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"next", nil)
                                                               action:@selector(finish)]];

    [_searchButton setRedGradientButtonStyle];
	[_searchButton setTitle:NSLocalizedString(@"Search", nil) forState:UIControlStateNormal];
    _searchButton.titleLabel.font = kPDNewNavigationBarButtonFont;
	_searchButton.layer.cornerRadius = 4;
	_searchButton.gradientLayer.cornerRadius = 4;

	_searchAddressTextField.placeholder = NSLocalizedString(@"Search for city, etc...", nil);
    [_searchAddressTextField uploadPhotoStyle];

	self.title = NSLocalizedString(@"Location", nil);
    [self initMapView];
    [self initLocationService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (self.photoLocation && ![self.locationMapView.annotations containsObject:self.photoLocation]) {
		[self.locationMapView addAnnotation:self.photoLocation];
	}
	if (self.photoLocation) {
		self.locationMapView.region = MKCoordinateRegionMake(self.photoLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
		
	}
	self.searchAddressTextField.text = @"";
}

- (void)dealloc
{
	self.locationMapView.showsUserLocation = NO;
	self.locationMapView.delegate = nil;
	[self.locationMapView removeFromSuperview];
	self.locationMapView = nil;
}

- (void)initSearchBar
{
    self.searchBarController.searchBar.frame = self.searchBar.frame;
    [self.searchBar.superview addSubview:self.searchBarController.searchBar];
    [self.searchBar removeFromSuperview];
    self.searchBarController.delegate = self;
    self.searchBar = self.searchBarController.searchBar;
    [self.searchBar setPlaceHolder:NSLocalizedString(@"Search for city, etc...", nil)];
}

- (void)setCoordinates:(CLLocationCoordinate2D)coordinates
{
	if (!self.photoLocation) {
		self.photoLocation = [[PDLocationAnnotation alloc] initWithCoordinates:coordinates];
		
	} else {
		self.photoLocation.coordinate = coordinates;
	}
	
	mapRegion = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(kPDMinCoordinatesSpan / 1.5, kPDMinCoordinatesSpan / 1.5));
    
	self.locationMapView.region = mapRegion;
	NSInteger index = [self.locationMapView.annotations indexOfObject:self.photoLocation];
	if (index == NSNotFound) {
		[self.locationMapView addAnnotation:self.photoLocation];
	}
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)setRegionCoordinates:(CLLocationCoordinate2D)coordinates
{
	mapRegion = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(kPDMinCoordinatesSpan / 1.5, kPDMinCoordinatesSpan / 1.5));
	self.locationMapView.region = mapRegion;
}

- (void)dropPin:(UITapGestureRecognizer *)gesture
{
	if (gesture.state != UIGestureRecognizerStateEnded) return;
	
    CGPoint touchPoint = [gesture locationInView:self.locationMapView];
    if (!self.photoLocation) {
        self.photoLocation = [[PDLocationAnnotation alloc] initWithCoordinates:[self.locationMapView convertPoint:touchPoint toCoordinateFromView:self.locationMapView]];
        [self.locationMapView addAnnotation:self.photoLocation];
    }
    else {
        self.photoLocation.coordinate = [self.locationMapView convertPoint:touchPoint toCoordinateFromView:self.locationMapView];
    }

	mapRegion = self.locationMapView.region;
}

- (void)goBack:(id)sender
{
	if (self.delegate && [self.delegate respondsToSelector:@selector(locationSelectDidCancel:)]) {
        [self.delegate locationSelectDidCancel:self];
    }
}

- (void)finish
{
	if (self.photoLocation.coordinate.latitude == 0 && self.photoLocation.coordinate.longitude == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please select photo location!", nil)];
		return;
		
	} else {
		if (mapRegion.span.latitudeDelta > kPDMinCoordinatesSpan ||
			mapRegion.span.longitudeDelta > kPDMinCoordinatesSpan) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																message:NSLocalizedString(@"You pin location with big zoom.\nAre you sure in correct photo location?", nil)
															   delegate:self
													  cancelButtonTitle:NSLocalizedString(@"Yes", nil)
													  otherButtonTitles:NSLocalizedString(@"No", nil), nil];
			[alertView show];
		} else {
			if (self.delegate && [self.delegate respondsToSelector:@selector(locationDidSelect:viewController:)]) {
                [self.delegate locationDidSelect:self.photoLocation.coordinate viewController:self];
            }
		}
	}
}

- (IBAction)searchAddress:(id)sender
{
	[_searchAddressTextField resignFirstResponder];
	if (_searchAddressTextField.text.length == 0) return;
	
	[self showSearchActivity];
	CLGeocoder *geocoder = [[CLGeocoder alloc] init];
	
	[geocoder geocodeAddressString:_searchAddressTextField.text
						  inRegion:[[PDLocationHelper sharedInstance] convertMapRegion:mapRegion]
				 completionHandler:^(NSArray *placemarks, NSError *error)
	 {
		 _searchAddressTextField.leftView = nil;
		 
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
                 if (self.photoLocation) {
                     [self.locationMapView removeAnnotation:self.photoLocation];
                     self.photoLocation = nil;
                 }
                 self.photoLocation = [[PDLocationAnnotation alloc] initWithCoordinates:placemark.location.coordinate];
                 [self.locationMapView addAnnotation:self.photoLocation];

			 }
		 }
	 }];
}

- (void)resetView
{
	if (self.photoLocation) {
		[self.locationMapView removeAnnotation:self.photoLocation];
        self.photoLocation = nil;
	}
	[self addTapGestureToMapView];
}

- (void)toggleMapViewMode:(id)sender
{
	UIButton *button = (UIButton *)sender;

	if (_locationMapView.mapType == MKMapTypeStandard) {
		_locationMapView.mapType = MKMapTypeSatellite;
		[button setTitle:NSLocalizedString(@"hybrid", nil) forState:UIControlStateNormal];
		
	} else if (_locationMapView.mapType == MKMapTypeSatellite) {
		_locationMapView.mapType = MKMapTypeHybrid;
		[button setTitle:NSLocalizedString(@"map", nil) forState:UIControlStateNormal];
		
	} else if (_locationMapView.mapType == MKMapTypeHybrid) {
		_locationMapView.mapType = MKMapTypeStandard;
		[button setTitle:NSLocalizedString(@"satellite", nil) forState:UIControlStateNormal];
	}
	
}

- (NSString *)pageName
{
	return @"Photo Location Select";
}

- (void)changeTitleRightBarButton
{
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"done", nil)
                                                            action:@selector(finish)]];
}


#pragma mark - Private

- (void)initMapView
{
	self.locationMapView = [[MKMapView alloc] initWithFrame:self.view.zeroPositionFrame];
	self.locationMapView.autoresizingMask = kFullAutoresizingMask;
	self.locationMapView.delegate = self;
	[self.view addSubview:self.locationMapView];
	[self.view sendSubviewToBack:self.locationMapView];
	int width = 60;
	int height = 26;
	float heightScreen = [[UIScreen mainScreen]applicationFrame].size.height;
	_mapViewModeButton = [[PDGradientButton alloc] initWithFrame:
								CGRectMake(self.view.width - width - 10,
										   heightScreen - height - 10 - 44,
										   width, height)];
	[_mapViewModeButton setTitle:NSLocalizedString(@"satellite", nil) forState:UIControlStateNormal];
	_mapViewModeButton.titleLabel.font = kPDNavigationBarButtonFont;
	_mapViewModeButton.layer.cornerRadius = 5;
	_mapViewModeButton.gradientLayer.cornerRadius = 5;
	_mapViewModeButton.layer.borderWidth = 1;
	[_mapViewModeButton addTarget:self action:@selector(toggleMapViewMode:) forControlEvents:UIControlEventTouchUpInside];
	[_mapViewModeButton setGrayGradientButtonStyle];
	[self.view addSubview:_mapViewModeButton];
	
	self.locationMapView.showsUserLocation = YES;
	self.locationMapView.delegate = self;
	[self addTapGestureToMapView];
}

- (void)showSearchActivity
{
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator startAnimating];
	_searchAddressTextField.leftView = activityIndicator;
	_searchAddressTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addTapGestureToMapView
{
	_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dropPin:)];
	_tapGesture.cancelsTouchesInView = NO;
	_tapGesture.numberOfTapsRequired = 1;
	[self.locationMapView addGestureRecognizer:_tapGesture];
}


#pragma mark - Map delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
	if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = view.annotation.coordinate;
		self.photoLocation.coordinate = droppedAt;
		mapRegion = self.locationMapView.region;
    }	
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
	
	MKPinAnnotationView *view = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
	if (!view) {
		view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
		view.draggable = YES;
        view.animatesDrop = YES;
        
        
	} else {
		view.annotation = annotation;
	}

	view.selected = YES;
	
	return view;
}


#pragma mark - Alert View delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(locationDidSelect:viewController:)]) {
            [self.delegate locationDidSelect:self.photoLocation.coordinate viewController:self];
        }
	}
}


#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self searchAddress:nil];
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	[textField performSelector:@selector(resignFirstResponder) withObject:textField afterDelay:0.2];
	return YES;
}

#pragma mark - SearchBar delegate

- (void)searchBar:(PDSearchBarController *)searchBarController didSelectedPlace:(PDPlace *)place
{
    [self setRegionCoordinates:place.coordinate];
    if (self.photoLocation) {
        [self.locationMapView removeAnnotation:self.photoLocation];
    }
    self.photoLocation = [[PDLocationAnnotation alloc] initWithCoordinates:place.coordinate];
    [self.locationMapView addAnnotation:self.photoLocation];
}

#pragma mark - Override

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    self.locationMapView.region = MKCoordinateRegionMake([[PDLocationHelper sharedInstance] coordinates], MKCoordinateSpanMake(0.01, 0.01));
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
        self.locationMapView.region = MKCoordinateRegionMake([[PDLocationHelper sharedInstance] coordinates], MKCoordinateSpanMake(0.01, 0.01));
    }];
}

@end
