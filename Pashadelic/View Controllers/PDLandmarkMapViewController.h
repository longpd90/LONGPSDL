//
//  PDLandmarkMapViewController.h
//  Pashadelic
//
//  Created by TungNT2 on 6/21/14.
//
//
#import "PDViewController.h"
#import "PDLocation.h"
#import "PDLandmarkMapView.h"

@interface PDLandmarkMapViewController : PDViewController

@property (strong, nonatomic) PDLocation *location;
@property (strong, nonatomic) PDLandmarkMapView *mapView;

- (void)routeToLandmark;

@end
