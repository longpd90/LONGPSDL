//
// PDPhotoMapViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 16/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoMapViewController.h"

@interface PDPhotoMapViewController ()
@end

@implementation PDPhotoMapViewController
@synthesize mapView, photo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"route", nil)
                                                          action:@selector(routeToThePhoto)]];
	mapView = [[PDPhotosMapView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.view.frame.size)];
	[self.view addSubview:mapView];
	self.title = NSLocalizedString(@"Photo-map", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self refreshView];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[self.mapView releaseMemory];
	self.mapView = nil;
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Photo Map";
}

- (void)routeToThePhoto
{

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Do you want to open in map?", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Yes", nil)
                                              otherButtonTitles:NSLocalizedString(@"No", nil), nil];
    [alertView show];
}

- (void)setPhoto:(PDPhoto *)newPhoto
{
	photo = nil;
	photo = newPhoto;
	if (!photo) return;
	[self refreshView];
}

- (void)refreshView
{
	self.needRefreshView = NO;
	if (self.photo) {
		mapView.items = [NSArray arrayWithObject:photo];
	}
	[mapView reloadMap];
}

#pragma mark - Alert View delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) {
        [self trackEvent:@"Route to photo"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%f,%f&daddr=%f,%f",
                                           photo.latitude, photo.longitude,
                                           [[PDLocationHelper sharedInstance] latitudes],
                                           [[PDLocationHelper sharedInstance] longitudes]]];
        [[UIApplication sharedApplication] openURL:url];
	}
}


@end
