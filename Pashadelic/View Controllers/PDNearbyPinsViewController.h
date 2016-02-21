//
//  PDNearbyPinsViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.07.13.
//
//

#import "PDPhotoTableViewController.h"

@interface PDNearbyPinsViewController : PDPhotoTableViewController

@property (weak, nonatomic) IBOutlet MGLocalizedLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (strong, nonatomic) IBOutlet UIView *mapPlaceholderView;
@property (strong, nonatomic) PDPhotosMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *photosButton;

- (IBAction)showPhotoTable:(id)sender;
- (IBAction)showMapView:(id)sender;
- (IBAction)distanceSliderValueChanged:(id)sender;
- (IBAction)distanceSliderTouchUpInside:(id)sender;
- (IBAction)distanceSliderTouchUpOutside:(id)sender;

@end
