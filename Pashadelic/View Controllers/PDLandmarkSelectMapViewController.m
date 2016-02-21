//
//  PDLandmarkSelectMapViewController.m
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/7/14.
//
//

#import "PDLandmarkSelectMapViewController.h"
#import "PDServerCreateLandmark.h"
#import "PDUploadPhotoViewController.h"

#define kPDMinCoordinatesSpan 0.1

@interface PDLandmarkSelectMapViewController ()
@end

@implementation PDLandmarkSelectMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    self.searchBarController = [[PDSearchBarController alloc] init];
    [super viewDidLoad];
    [self.searchBar setPlaceHolder:NSLocalizedString(@"enter address to move the map", nil)];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.title = NSLocalizedString(@"Create landmark", nil);
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"add", nil)
                                                         action:@selector(createLandmark)]];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    if (self.photo) {
        [self setPhoto:self.photo];
    }
}

- (NSString *)pageName
{
	return @"Create landmark";
}

- (void)setPhoto:(PDPhoto *)photo
{
    _photo = photo;
    if ([self isViewLoaded]) {
        self.nameLandmark.text = _photo.poiItem.name;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(photo.latitude, photo.longitude);
        self.locationMapView.region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(1.0, 1.0));
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    self.locationMapView.region = MKCoordinateRegionMake([[PDLocationHelper sharedInstance] coordinates], MKCoordinateSpanMake(0.01, 0.01));
}

- (void)createLandmark
{
    if (self.photoLocation.coordinate.latitude == 0 && self.photoLocation.coordinate.longitude == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please select landmark location!", nil)];
		return;
		
	} else {
        _photo.poiItem.latitude = self.photoLocation.coordinate.latitude;
        _photo.poiItem.longitude = self.photoLocation.coordinate.longitude;
        [kPDAppDelegate showWaitingSpinner];
        self.serverExchange = [[PDServerCreateLandmark alloc] initWithDelegate:self];
        [self.serverExchange createLandmark:_photo.poiItem];
	}
}

- (void)finish
{
    if ([[self previousViewController] isKindOfClass:[PDPhotoLandmarkViewController class]]) {
        PDUploadPhotoViewController *uploadPhotoViewController = [[PDUploadPhotoViewController alloc] initWithNibName:@"PDUploadPhotoViewController" bundle:nil];
        uploadPhotoViewController.photo = self.photo;
        [self.navigationController pushViewController:uploadPhotoViewController animated:YES];
        [uploadPhotoViewController fetchData];
    } else if ([[self previousViewController] isKindOfClass:[PDUploadPhotoViewController class]]) {
        PDUploadPhotoViewController *backViewController = (PDUploadPhotoViewController *)[self previousViewController];
        backViewController.photo.poiItem = self.photo.poiItem;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma serverExchange delegate

- (void)serverExchange:(id)serverExchange didParseResult:(id)result
{
    if (![self.serverExchange isEqual:serverExchange]) return;
    [kPDAppDelegate hideWaitingSpinner];
    self.loading = NO;
    _photo.poiItem.identifier = [result intForKey:@"id"];
    [self finish];
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error
{
    [kPDAppDelegate hideWaitingSpinner];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Can not create new landmark!", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Skip", nil)
                                              otherButtonTitles:NSLocalizedString(@"Retry", nil), nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self finish];
    }
}


@end
