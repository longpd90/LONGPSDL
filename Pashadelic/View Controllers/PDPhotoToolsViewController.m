//
//  PDMapToolsViewController.m
//  Pashadelic
//
//  Created by TungNT2 on 4/23/13.
//
//

#import "PDPhotoToolsViewController.h"
#import "PDServerPhotoToolsNearbyLoader.h"
#import "PDGooglePlaceAutocomplete.h"
#import "PDGooglePlaceDetails.h"
#import "PDGoogleGeocoding.h"

@interface PDPhotoToolsViewController (Private)
- (void)initSearchBar;
- (void)initPhotoMapToolsView;
- (void)initilazieMapView;
- (void)loadMapForPlace:(PDPlace *)place;
@end

@implementation PDPhotoToolsViewController
@synthesize photoMapToolsView;
@synthesize titleLocationView;
@synthesize titleLocationLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"map tool", nil);
    
    [self initSearchBar];
    [self initilazieMapView];
    [self initPhotoMapToolsView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(buttonLocationClicked:)
                                                 name:kPDButtonLocationToolsClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(buttonPhotoSpotsClicked:)
                                                 name:kPDButtonSpotToolsClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(buttonSunMoonClicked:)
                                                 name:kPDButtonSunMoonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPhotoSpots)
                                                 name:kPDPhotoSpotsFilterDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadPhotoSpots)
                                                 name:kPDMapViewRegionDidChangeNotification
                                               object:nil];    
}

- (void)viewDidUnload
{
    self.toolbarView = nil;
    self.photoMapToolsView = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.customNavigationBar.titleButton.hidden = NO;
}

- (NSString *)pageName
{
    return @"Map Tools";
}

- (void)loadPhotoSpotsForCoordinate:(CLLocationCoordinate2D)coordinate
{
    [kPDAppDelegate showWaitingSpinner];
    PDServerPhotoToolsNearbyLoader *nearbyLoader = [[PDServerPhotoToolsNearbyLoader alloc] initWithDelegate:self];
    [nearbyLoader loadNearbySorting:kPDPhotoToolsNearbySort
                              range:kPDPhotoToolsNearbyRange
                          longitude:coordinate.longitude
                           latitude:coordinate.latitude];
}

#pragma mark - Private

- (void)initSearchBar
{
    self.searchBarController.searchBar.frame = self.searchBar.frame;
    [self.searchBar.superview addSubview:self.searchBarController.searchBar];
    [self.searchBar removeFromSuperview];
    self.searchBarController.delegate = self;
    self.searchBar = self.searchBarController.searchBar;
    [self.searchBar setPlaceHolder:NSLocalizedString(@"enter landmark, city, state name", nil)];
}

- (void)initilazieMapView
{
    [super initialize];
    self.titleLocationView.hidden = YES;
    [self refreshView];
}

- (void)initPhotoMapToolsView
{
    photoMapToolsView = [[PDPhotoMapToolsView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, PDPhotoSpotsViewHeight)];
    photoMapToolsView.delegate = self;
    [self.view addSubview:photoMapToolsView];
}

- (void)refreshView
{
    [super refreshView];    
}

#pragma mark - Public

- (void)toggleToolbarView:(id)sender
{
	if (!self.searchView) return;
	
	if (self.searchView.hidden) {
		[self showToolbarAnimated:YES];
	} else {
		[self hideToolbarAnimated:YES];
	}
}

- (void)hideToolbarAnimated:(BOOL)animated
{
	if (self.searchView.hidden) return;
	
	self.customNavigationBar.titleButton.selected = YES;
    self.searchBarController.active = NO;
    if (animated) {
		[UIView animateWithDuration:0.2 animations:^{
			self.searchView.y = -self.searchView.height;
		} completion:^(BOOL finished) {
			self.searchView.hidden = YES;
		}];
	} else {
		self.searchView.y = -self.searchView.height;
		self.searchView.hidden = YES;
	}
}

- (void)showToolbarAnimated:(BOOL)animated
{
	if (!self.searchView.hidden) return;
	self.customNavigationBar.titleButton.selected = NO;

	self.searchView.hidden = NO;

	if (animated) {
		[UIView animateWithDuration:0.2 animations:^{
			self.searchView.y = 0;
		} completion:^(BOOL finished) {
		}];
	} else {
		self.searchView.y = 0;
	}
}

- (void)search
{
    
	if (self.searchBar.textField.text.length == 0) return;
	searchText = self.searchBar.textField.text;
    [self trackEvent:@"Search place"];
	[self refetchDataWithoutResetViewMode];
}

- (void)cancelSearch
{
	self.title = NSLocalizedString(@"Tools", nil);
    self.titleLocationView.hidden = YES;
}

- (void)refetchDataWithoutResetViewMode
{
	if (searchText) {
        titleLocationView.hidden = searchText==nil ? YES : NO;
        titleLocationLabel.text = searchText;
    }
}

- (void)loadMapForPlace:(PDPlace *)place
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(place.latitude, place.longitude);
    self.searchLocation = location;
    [self search];
}

#pragma mark - Map Tools Notification

- (void)buttonLocationClicked:(NSNotification *)notification
{
    PDButtonMapTools *btnLocation = notification.object;
    if (btnLocation.currentState == PDButtonMapToolsStateOff){
        if (!isLocationReceived) {
            [self updateLocation];
            return;
        } else {
            self.state = PDMapToolStateLocationUser;
            self.currentLocation = [[PDLocationHelper sharedInstance] coordinates];
        }
    } else if (btnLocation.currentState == PDButtonMapToolsStateActive) {
        self.state = PDMapToolStateNormal;
    }
    [self changeUserTrackingMode];
}

- (void)buttonPhotoSpotsClicked:(NSNotification *)notification
{
    PDButtonMapTools *btnPhotoSpots = (PDButtonMapTools *)notification.object;
    if (btnPhotoSpots.currentState == PDButtonMapToolsStateOff) {
        self.isHiddenPhotoSpot = YES;
    }
    else {
        self.isHiddenPhotoSpot = NO;
        [self reloadPhotoSpots];
    }
}

- (void)buttonSunMoonClicked:(NSNotification *)notification
{
    PDButtonMapTools *btnSunMoon = (PDButtonMapTools *)notification.object;
    if (btnSunMoon.currentState == PDButtonMapToolsStateOff) {
        self.isHiddenSunMoon = YES;
    } else {
        self.isHiddenSunMoon = NO;
    }
}

- (void)reloadPhotoSpots
{
    if (!self.isHiddenPhotoSpot) {
        if (self.state == PDMapToolStateLocationUser) {
            [self loadPhotoSpotsForCoordinate:self.currentLocation];
        } else {
            [self loadPhotoSpotsForCoordinate:[self.photosMapView centerMapViewCoordinate]];
        }
    }
}

#pragma mark - SearchBar delegate

- (void)searchBar:(PDSearchBarController *)searchBarController didSelectedPlace:(PDPlace *)place
{
    [self loadMapForPlace:place];
}

- (void)searchBarDidCancel
{
    [self cancelSearch];
}

#pragma  mark - ServerExchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    [super serverExchange:serverExchange didParseResult:result];

    if ([serverExchange isKindOfClass:[PDServerPhotoToolsNearbyLoader class]]) {
        self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
    }
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error
{
    [super serverExchange:serverExchange didFailWithError:error];
}

@end
