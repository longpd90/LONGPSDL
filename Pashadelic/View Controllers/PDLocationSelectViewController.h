//
//  PDLocationSelectViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 23/10/12.
//
//

#import "PDViewController.h"
#import <MapKit/MapKit.h>
#import "PDLocationAnnotation.h"
#import "PDSearchBarController.h"

@class PDLocationSelectViewController;

@protocol PDLocationSelectDelegate <NSObject>
- (void)locationDidSelect:(CLLocationCoordinate2D) coordinates viewController:(PDLocationSelectViewController *)viewController;
- (void)locationSelectDidCancel:(PDLocationSelectViewController *)viewController;
@end

@interface PDLocationSelectViewController : PDViewController
<MKMapViewDelegate, UIAlertViewDelegate, PDSearchBarControllerDelegate>

{
	MKCoordinateRegion mapRegion;
}

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet PDTextField *searchAddressTextField;
@property (weak, nonatomic) IBOutlet PDGradientButton *searchButton;
@property (strong, nonatomic) MKMapView *locationMapView;
@property (strong, nonatomic) PDGradientButton *mapViewModeButton;
@property (strong, nonatomic) PDLocationAnnotation *photoLocation;
@property (weak, nonatomic) id <PDLocationSelectDelegate> delegate;

@property (nonatomic, strong) IBOutlet PDSearchBar *searchBar;
@property (nonatomic, strong) IBOutlet PDSearchBarController *searchBarController;

- (void)dropPin:(UITapGestureRecognizer *)gesture;
- (void)setCoordinates:(CLLocationCoordinate2D) coordinates;
- (void)setRegionCoordinates:(CLLocationCoordinate2D) coordinates;
- (void)resetView;
- (IBAction)searchAddress:(id)sender;
- (void)changeTitleRightBarButton;
- (void)finish;
@end
