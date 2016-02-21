//
//  PDClusterMapViewController.h
//  Pashadelic
//
//  Created by TungNT2 on 3/10/14.
//
//

#import "PDPhotoTableViewController.h"
#import "KPTreeController.h"

enum PDClusterMapViewSource {
	PDClusterMapViewSourcePhotos = 0,
	PDClusterMapViewSourceLankmarks
};

@class PDPhotoClustersMapView;
@class PDOverlayView;
@class PDPhotosClusterTableView;

@interface PDClusterMapViewController : PDPhotoTableViewController
<MKMapViewDelegate, MGServerExchangeDelegate, KPTreeControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView  *mapPlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *numberPhotosLabel;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet PDOverlayView *overlayView;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *closeButton;
@property (strong, nonatomic) PDPhotoClustersMapView *photoClustersMapView;
@property (strong, nonatomic) PDPhotosClusterTableView *photosClusterTableView;
@property (nonatomic, strong) KPTreeController *treeController;

@property (strong, nonatomic) NSArray *photos;
@property (strong, nonatomic) NSArray *landmarks;
@property (assign, nonatomic) double zoomLevel;
@property (assign, nonatomic) int sourceType;

- (void)initInterface;
- (IBAction)photoButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;
- (void)refreshMapViewAndChangeRegion:(BOOL)isChange;
@end
