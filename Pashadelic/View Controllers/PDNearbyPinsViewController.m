//
//  PDNearbyPinsViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.07.13.
//
//

#import "PDNearbyPinsViewController.h"
#import "PDUserProfile.h"
#import "UIImage+Extra.h"

@interface PDNearbyPinsViewController ()

@property (strong, nonatomic) NSTimer *refreshIntervalTimer;
- (void)initButtons;
- (void)invalidateRefreshNearbyTimer;
- (void)reloadData;
@end

@implementation PDNearbyPinsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleWhite];
	[self initButtons];
    [self initLocationService];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.distanceSlider.value = kPDShowNearbyPinDistance;
	[self distanceSliderValueChanged:self.distanceSlider];
	[super viewWillAppear:animated];
	self.title = NSLocalizedString(@"Nearby collect", nil);
}

- (void)dealloc
{
	[self.mapView releaseMemory];
	self.mapView = nil;
}


#pragma mark - Private

- (void)initButtons
{
	UIImage *whiteImage = [[[UIImage alloc] init] imageWithColor:[UIColor whiteColor]];
	[self.mapButton setBackgroundImage:whiteImage forState:UIControlStateNormal];
	self.mapButton.layer.masksToBounds = YES;
	self.mapButton.layer.cornerRadius = 4;
	
	self.photosButton.layer.masksToBounds = YES;
	self.photosButton.layer.cornerRadius = 4;
	[self.photosButton setBackgroundImage:whiteImage forState:UIControlStateNormal];

}

- (void)reloadData
{
	NSMutableArray *nearbyPins = [NSMutableArray array];
	[kPDAppDelegate.userProfile.nearbyPins removeAllObjects];
	@synchronized(kPDAppDelegate.userProfile.pins) {
		for (PDPhoto *photo in kPDAppDelegate.userProfile.pins) {
			if (photo.distanceInMeters <= kPDShowNearbyPinDistance * 1000) {
				[nearbyPins addObject:photo];
			}
		}
	}
	[nearbyPins sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		if ([obj1 distanceInMeters] > [obj2 distanceInMeters]) return NSOrderedDescending;
		else if ([obj1 distanceInMeters] < [obj2 distanceInMeters]) return NSOrderedAscending;
		else return NSOrderedSame;
	}];

	self.items = nearbyPins;
	if (!self.mapPlaceholderView.isHidden) {
		self.mapView.items = self.items;
		[self.mapView reloadMap];
	}
	self.loading = NO;
	[super refreshView];
}

#pragma mark - Public

- (void)initPhotosTable
{
	[super initPhotosTable];
}

- (NSString *)pageName
{
	return @"Nearby collect";
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleBlack;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)invalidateRefreshNearbyTimer
{
	[self.refreshIntervalTimer invalidate];
	self.refreshIntervalTimer = nil;
}

- (void)refreshView
{
	if (self.refreshIntervalTimer) return;
	
	self.refreshIntervalTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(invalidateRefreshNearbyTimer) userInfo:nil repeats:NO];
	
	[self reloadData];
}

- (void)fetchData
{
	[self.refreshIntervalTimer invalidate];
	self.refreshIntervalTimer = nil;
	[self performSelector:@selector(refreshView) withObject:nil afterDelay:1];
}

- (IBAction)showPhotoTable:(id)sender
{
	self.tablePlaceholderView.x = -self.view.width;
	self.tablePlaceholderView.hidden = NO;
	[UIView animateWithDuration:0.2 animations:^{
		self.tablePlaceholderView.x = 0;
		self.mapPlaceholderView.x = self.view.width;
	} completion:^(BOOL finished) {
		self.mapPlaceholderView.hidden = YES;
	}];
}

- (IBAction)showMapView:(id)sender
{
	if (!self.mapView) {
		self.mapView = [[PDPhotosMapView alloc] initWithFrame:self.mapPlaceholderView.zeroPositionFrame];
		self.mapView.autoresizingMask = kFullAutoresizingMask;
		self.mapView.itemSelectDelegate = self;
		[self.mapPlaceholderView addSubview:self.mapView];
		[self.mapPlaceholderView sendSubviewToBack:self.mapView];
		self.mapPlaceholderView.frame = self.tablePlaceholderView.frame;
		[self.view addSubview:self.mapPlaceholderView];
	}
	
	self.mapPlaceholderView.x = self.view.width;
	self.mapPlaceholderView.hidden = NO;
	[self reloadData];
	
	[UIView animateWithDuration:0.2 animations:^{
		self.mapPlaceholderView.x = 0;
		self.tablePlaceholderView.x = -self.view.width;
	} completion:^(BOOL finished) {
		self.tablePlaceholderView.hidden = YES;
	}];
}

- (IBAction)distanceSliderValueChanged:(id)sender
{
	self.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Photo spots you wanna snap that are\nwithin %.1f km of where you are.", nil), self.distanceSlider.value];
	[kPDUserDefaults setFloat:self.distanceSlider.value forKey:kPDShowNearbyPinDistanceKey];
}

- (IBAction)distanceSliderTouchUpInside:(id)sender
{
	[self reloadData];
}

- (IBAction)distanceSliderTouchUpOutside:(id)sender
{
	[self reloadData];
}

#pragma mark - Override

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    [self refreshView];
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
        [self refreshView];
    }];
}

@end
