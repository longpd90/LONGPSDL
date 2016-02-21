//
//  PDLandmarkMapViewController.m
//  Pashadelic
//
//  Created by TungNT2 on 6/21/14.
//
//

#import "PDLandmarkMapViewController.h"

@interface PDLandmarkMapViewController ()

@end

@implementation PDLandmarkMapViewController
@synthesize location, mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"route", nil)
                                                         action:@selector(routeToLandmark)]];
    mapView = [[PDLandmarkMapView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.view.frame.size)];
    [self.view addSubview:mapView];
    self.title = NSLocalizedString(@"landmark map", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self refreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
    return PDNavigationBarStyleWhite;
}

- (NSString *)pageName
{
	return @"Landmark Map";
}

- (void)routeToLandmark
{
    [self trackEvent:@"Route to landmark"];
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",
									   location.latitude, location.longitude,
									   [[PDLocationHelper sharedInstance] latitudes],
									   [[PDLocationHelper sharedInstance] longitudes]]];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)setLocation:(PDLocation *)newLocation
{
	location = newLocation;
    if (!location) return;
	[self refreshView];
}

- (void)refreshView
{
    self.needRefreshView = NO;
    mapView.items = [NSArray arrayWithObject:self.location];
    [mapView reloadMap];
}

@end
