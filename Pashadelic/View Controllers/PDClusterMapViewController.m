//
//  PDClusterMapViewController.m
//  Pashadelic
//
//  Created by TungNT2 on 3/10/14.
//
//

#import "PDClusterMapViewController.h"
#import "PDPhotoClustersMapView.h"
#import "PDPhotosClusterTableView.h"
#import "KPAnnotation.h"
#import "PDPhotoAnnotationView.h"
#import "PDPhotoClusterAnnotationView.h"
#import "PDLandmarkAnnotationView.h"
#import "PDLandmarkClusterAnnotionView.h"
#import "PDOverlayView.h"
#import "PDLocationViewController.h"

@interface PDClusterMapViewController () <KPTreeControllerDelegate, PDOverlayViewDelegate>
- (void)initPhotoClusterMapView;
@end

@implementation PDClusterMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initInterface];
    [self initPhotoClusterMapView];
    [self initTreeController];
}

- (void)dealloc
{
	[self.photoClustersMapView releaseMemory];
	self.photoClustersMapView = nil;
}

- (void)initInterface
{
    self.overlayView.delegate = self;
    self.overlayView.hidden = YES;
    CGFloat fontSize = 22;
	NSDictionary *blackColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalDarkGrayColor};
    [self.closeButton applyRedStyleToButton];
	[self.photoButton setFontAwesomeIconForImage:[FAKFontAwesome caretLeftIconWithSize:fontSize]
                                        forState:UIControlStateNormal
                                      attributes:blackColorAttribute];
}

- (void)initPhotoClusterMapView
{
    self.photoClustersMapView = [[PDPhotoClustersMapView alloc] initWithFrame:CGRectMakeWithSize(0, 0, _mapPlaceholderView.frame.size)];
    self.photoClustersMapView.mapView.delegate = self;
    self.photoClustersMapView.mapView.showsUserLocation = YES;
    [_mapPlaceholderView addSubview:_photoClustersMapView];
    _mapPlaceholderView.layer.cornerRadius = 4;
    _mapPlaceholderView.layer.masksToBounds = YES;
}

- (void)initTreeController
{
    if (!self.photoClustersMapView) return;
    self.treeController = [[KPTreeController alloc] initWithMapView:self.photoClustersMapView.mapView];
    self.treeController.delegate = self;
    self.treeController.animationOptions = UIViewAnimationCurveEaseOut;
}

- (void)initPhotosTable
{
    self.photosClusterTableView = [[PDPhotosClusterTableView alloc] initWithFrame:self.overlayView.frame];
    self.photosClusterTableView.photoViewDelegate = self;
    self.photosClusterTableView.itemsTableDelegate = self;
    self.photosClusterTableView.hidden = YES;
    [self.view addSubview:self.photosClusterTableView];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
}

- (void)setLandmarks:(NSArray *)landmarks
{
    _landmarks = landmarks;
}

- (void)refreshMapViewAndChangeRegion:(BOOL)isChange
{
    [self.photoClustersMapView.mapView removeAnnotations:self.photoClustersMapView.mapView.annotations];
    
    CLLocationCoordinate2D maxPosition = CLLocationCoordinate2DMake(-90, -180);
	CLLocationCoordinate2D minPosition = CLLocationCoordinate2DMake(90, 180);
    
    CLLocationDegrees totalLat = 0;
    CLLocationDegrees totalLng = 0;
    
    NSMutableArray *annotations = [NSMutableArray array];

    if (self.sourceType == PDClusterMapViewSourcePhotos) {
        for (int i = 0; i < self.photos.count; i++) {
            PDPhoto *photo = (PDPhoto *)[self.photos objectAtIndex:i];
            photo.itemDelegate = self.photoClustersMapView.itemSelectDelegate;
            KPAnnotation *photoAnnotation = [[KPAnnotation alloc] init];
            photoAnnotation.coordinate = CLLocationCoordinate2DMake(photo.latitude, photo.longitude);
            photoAnnotation.photo = photo;
            [annotations addObject:photoAnnotation];
            
            maxPosition.latitude = MAX(maxPosition.latitude, photo.latitude);
            maxPosition.longitude = MAX(maxPosition.longitude, photo.longitude);
            minPosition.latitude = MIN(minPosition.latitude, photo.latitude);
            minPosition.longitude = MIN(minPosition.longitude, photo.longitude);
            
            totalLat += photo.latitude;
            totalLng += photo.longitude;
        }
        
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(totalLat / annotations.count,
                                                                             totalLng / annotations.count);
        float radius = [[[CLLocation alloc] initWithLatitude:minPosition.latitude
                                                   longitude:minPosition.longitude]
                        distanceFromLocation:[[CLLocation alloc] initWithLatitude:maxPosition.latitude
                                                                        longitude:maxPosition.longitude]] / 2.f;
        if (self.photos.count > 0 && isChange == YES) {
            [self.photoClustersMapView changeRegionWithCoordinate:centerCoordinate
                                                           radius:radius
                                                         animated:YES];
        }
    } else {
        for (int i = 0; i < self.landmarks.count; i++) {
            PDPhotoLandMarkItem *landmark = (PDPhotoLandMarkItem *)[self.landmarks objectAtIndex:i];
            KPAnnotation *photoAnnotation = [[KPAnnotation alloc] init];
            photoAnnotation.coordinate = CLLocationCoordinate2DMake(landmark.latitude, landmark.longitude);
            photoAnnotation.landmark = landmark;
            [annotations addObject:photoAnnotation];
            
            maxPosition.latitude = MAX(maxPosition.latitude, landmark.latitude);
            maxPosition.longitude = MAX(maxPosition.longitude, landmark.longitude);
            minPosition.latitude = MIN(minPosition.latitude, landmark.latitude);
            minPosition.longitude = MIN(minPosition.longitude, landmark.longitude);
            
            totalLat += landmark.latitude;
            totalLng += landmark.longitude;
        }
        
        CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(totalLat / annotations.count,
                                                                             totalLng / annotations.count);
        float radius = [[[CLLocation alloc] initWithLatitude:minPosition.latitude
                                                   longitude:minPosition.longitude]
                        distanceFromLocation:[[CLLocation alloc] initWithLatitude:maxPosition.latitude
                                                                        longitude:maxPosition.longitude]] / 2.f;
        
        if (self.landmarks.count > 0 && isChange == YES) {
            [self.photoClustersMapView changeRegionWithCoordinate:centerCoordinate
                                                           radius:radius
                                                         animated:YES];
        }
    }
    [self.treeController setAnnotations:annotations];
}

- (void)fetchData
{
    [kPDAppDelegate showWaitingSpinner];
}

- (void)refetchData
{
    [super refetchData];
}

#pragma mark - animations

- (void)fadeIn
{
    self.photosClusterTableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.overlayView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.photosClusterTableView.alpha = 0;
    self.overlayView.hidden = NO;
    self.photosClusterTableView.hidden = NO;
    [UIView animateWithDuration:.35 animations:^{
        self.photosClusterTableView.alpha = 1;
        self.overlayView.transform = CGAffineTransformMakeScale(1, 1);
        self.photosClusterTableView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.photosClusterTableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.overlayView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.photosClusterTableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            _overlayView.hidden = YES;
            self.photosClusterTableView.hidden = YES;
            self.photosClusterTableView.transform = CGAffineTransformMakeScale(1, 1);
            self.overlayView.transform = CGAffineTransformMakeScale(1, 1);
        }
    }];
}

# pragma mark - Action

- (IBAction)photoButtonClicked:(id)sender
{}

- (IBAction)closeButtonClicked:(id)sender
{
    [self fadeOut];
}

#pragma mark - overlayview delegate

- (void)didTouchesToOverlayView
{
    [self fadeOut];
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *kPDPhotoAnnotationViewIdentifier = @"kPDPhotoAnnotationView";
    NSString *kPDPhotoClusterAnnotationViewIdentifier = @"kPDPhotoClusterAnnotationView";
    NSString *kPDLandmarkAnnotationViewIdentifier = @"PDLandmarkAnnotationView";
    NSString *kPDLandmarkClusterAnnotationViewIdentifier = @"PDLandmarkClusterAnnotionView";
    
    PDPhotoAnnotationView *photoAnnotationView = nil;
    PDPhotoClusterAnnotationView *photoClusterAnnotationView = nil;
    PDLandmarkAnnotationView *landmarkAnnotationView = nil;
    PDLandmarkClusterAnnotionView *landmarkClusterAnnotationView = nil;
    
    if ([annotation isKindOfClass:[KPAnnotation class]]) {
        KPAnnotation *photoAnnotation = (KPAnnotation *)annotation;
        if ([photoAnnotation isCluster]) {
            if (self.sourceType == PDClusterMapViewSourcePhotos) {
                photoClusterAnnotationView = (PDPhotoClusterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPDPhotoClusterAnnotationViewIdentifier];
                if (!photoClusterAnnotationView) {
                    photoClusterAnnotationView = [[PDPhotoClusterAnnotationView alloc] initWithAnnotation:photoAnnotation
                                                                                          reuseIdentifier:kPDPhotoClusterAnnotationViewIdentifier];
                }
                photoClusterAnnotationView.photo = photoAnnotation.photo;
                photoClusterAnnotationView.count = photoAnnotation.annotations.count;
                return photoClusterAnnotationView;
            } else {
                landmarkClusterAnnotationView = (PDLandmarkClusterAnnotionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPDLandmarkClusterAnnotationViewIdentifier];
                if (!landmarkClusterAnnotationView) {
                    landmarkClusterAnnotationView = [[PDLandmarkClusterAnnotionView alloc] initWithAnnotation:photoAnnotation
                                                                                          reuseIdentifier:kPDLandmarkClusterAnnotationViewIdentifier];
                }
                landmarkClusterAnnotationView.landmark = photoAnnotation.landmark;
                landmarkClusterAnnotationView.count = photoAnnotation.annotations.count;
                return landmarkClusterAnnotationView;
            }

        } else {
            if (self.sourceType == PDClusterMapViewSourcePhotos) {
                photoAnnotationView = (PDPhotoAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPDPhotoAnnotationViewIdentifier];
                if (!photoAnnotationView) {
                    photoAnnotationView = [[PDPhotoAnnotationView alloc] initWithAnnotation:photoAnnotation
                                                                            reuseIdentifier:kPDPhotoAnnotationViewIdentifier];
                }
                photoAnnotationView.photo = photoAnnotation.photo;
                return photoAnnotationView;
            } else {
                landmarkAnnotationView = (PDLandmarkAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:kPDLandmarkAnnotationViewIdentifier];
                if (!landmarkAnnotationView) {
                    landmarkAnnotationView = [[PDLandmarkAnnotationView alloc] initWithAnnotation:photoAnnotation
                                                                            reuseIdentifier:kPDLandmarkAnnotationViewIdentifier];
                }
                landmarkAnnotationView.landmark = photoAnnotation.landmark;
                return landmarkAnnotationView;
            }
     
        }
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[KPAnnotation class]]) {
        KPAnnotation *cluster = (KPAnnotation *)view.annotation;
        if (cluster.annotations.count > 1) {
            if (self.sourceType == PDClusterMapViewSourcePhotos) {
                if (self.zoomLevel < 16) {
                    [self.photoClustersMapView changeRegionWithCoordinate:cluster.coordinate
                                                                   radius:cluster.radius
                                                                 animated:YES];
                } else {
                    NSMutableArray *items = [[NSMutableArray alloc] init];
                    for (int i = 0; i < cluster.annotations.count; i ++) {
                        PDPhoto *photo = [(KPAnnotation *)[[cluster.annotations allObjects] objectAtIndex:i] photo];
                        [items addObject:photo];
                    }
                    self.photosClusterTableView.items = items;
                    [self.photosClusterTableView reloadData];
                    if (cluster.annotations.count > 9) {
                        self.photosClusterTableView.scrollEnabled = YES;
                        self.photosClusterTableView.tableHeaderView = self.headerView;
                        self.numberPhotosLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%zd photos", nil), cluster.annotations.count];
                        self.photosClusterTableView.height = self.overlayView.height;
                    }
                    else {
                        self.photosClusterTableView.scrollEnabled = NO;
                        self.photosClusterTableView.tableHeaderView = nil;
                        NSInteger numberRows = [self.photosClusterTableView numberOfRowsInSection:0];
                        self.photosClusterTableView.height = numberRows * kPDPhotoTileCellHeight;
                    }
                    self.photosClusterTableView.center = self.overlayView.center;
                    [self fadeIn];
                    [mapView deselectAnnotation:view.annotation animated:NO];
                }
            } else {
                [self.photoClustersMapView changeRegionWithCoordinate:cluster.coordinate
                                                               radius:cluster.radius
                                                             animated:YES];
            }
            
        } else {
            if ([view isKindOfClass:[PDPhotoAnnotationView class]]) {
                self.photosClusterTableView.items = @[cluster.photo];
                PDPhotoAnnotationView *photoAnnotationView = (PDPhotoAnnotationView *)view;
                [self photo:photoAnnotationView.photo
            didSelectInView:photoAnnotationView.photoImageView
                      image:photoAnnotationView.photoImageView.image];
                [mapView deselectAnnotation:view.annotation animated:NO];
            }else if ([view isKindOfClass:[PDLandmarkAnnotationView class]]) {
                self.photosClusterTableView.items = @[cluster.landmark];
                PDLandmarkAnnotationView *landmarkAnnotationView = (PDLandmarkAnnotationView *)view;
                
                PDLocationViewController *locationViewController = [[PDLocationViewController alloc] initWithNibName:@"PDLocationViewController" bundle:nil];
                PDLocation *locationLandmark = [[PDLocation alloc] init];
                locationLandmark.locationType = PDLocationTypeLandmark;
                locationLandmark.name = landmarkAnnotationView.landmark.name;
                locationLandmark.identifier = landmarkAnnotationView.landmark.identifier;
                locationViewController.location = locationLandmark;
                [self.navigationController pushViewController:locationViewController animated:YES];
            }
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.zoomLevel = [self.photoClustersMapView getZoomLevelFromMapView:mapView];
    [self.treeController refresh:YES];
}

#pragma mark - KPTreeController delegate

- (void)treeController:(KPTreeController *)tree configureAnnotationForDisplay:(KPAnnotation *)annotation
{
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    [kPDAppDelegate hideWaitingSpinner];
    [super serverExchange:serverExchange didParseResult:result];
}

- (void)serverExchange:(id)serverExchange didFailWithError:(NSString *)error {
    [super serverExchange:serverExchange didFailWithError:error];
}

@end
