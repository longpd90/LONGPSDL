//
//  PDPhotospotsMapsViewController.m
//  Pashadelic
//
//  Created by LTT on 6/18/14.
//
//

#import "PDLocationPhotosMapViewController.h"
#import "KPAnnotation.h"
#import "PDPhotoAnnotation.h"
#import "PDPhotoAnnotationView.h"
#import "PDPhotoClusterAnnotationView.h"
#import "PDServerPhotospotsLoader.h"
#import "PDLandmarkAnnotation.h"
#import "PDLandmarkAnnotationCalloutView.h"

@interface PDLocationPhotosMapViewController ()

@end

@implementation PDLocationPhotosMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.photos) {
        self.photos = self.photos;
    }
    if (self.location) {
        self.location = self.location;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setPhotos:(NSArray *)photos
{
    [super setPhotos:photos];
    if (self.isViewLoaded)
        [self refreshMapViewAndChangeRegion:YES];
}

- (void)setLocation:(PDLocation *)location
{
    _location = location;
    if (self.isViewLoaded) {
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        PDLandmarkAnnotation *landmarkAnnotation = [[PDLandmarkAnnotation alloc] initWithLocation:locationCoordinate];
        [self.photoClustersMapView.mapView addAnnotation:landmarkAnnotation];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[PDLandmarkAnnotation class]]) {
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"LandmarkAnnotation"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LandmarkAnnotation"];
            annotationView.image = [UIImage imageNamed:@"landmark-annotation.png"];
        } else
            annotationView.annotation = annotation;
        return annotationView;
    } else if ([annotation isKindOfClass:[KPAnnotation class]])
        return [super mapView:mapView viewForAnnotation:annotation];
    else
        return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    if([view.annotation isKindOfClass:[PDLandmarkAnnotation class]]) {
        PDLandmarkAnnotationCalloutView *calloutView = (PDLandmarkAnnotationCalloutView *)[[[NSBundle mainBundle] loadNibNamed:@"PDLandmarkAnnotationCalloutView"
                                                                                                                         owner:self options:nil] objectAtIndex:0];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 15, -calloutViewFrame.size.height);
        calloutView.frame = calloutViewFrame;
        calloutView.location = self.location;
        [view addSubview:calloutView];
        [view bringSubviewToFront:calloutView];
        [self showCallout:calloutView];
    } else
        [super mapView:mapView didSelectAnnotationView:view];
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[PDLandmarkAnnotation class]]) {
        for (UIView *subview in view.subviews ){
            [self hideCallout:subview];
        }
    }
}

#pragma Private

- (void)showCallout:(UIView *)callOutView
{
    callOutView.transform = CGAffineTransformMakeScale(1.3, 1.3);
    callOutView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        callOutView.alpha = 1;
        callOutView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)hideCallout:(UIView *)calloutView
{
    [UIView animateWithDuration:.35 animations:^{
        calloutView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        calloutView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [calloutView removeFromSuperview];
        }
    }];
}

#pragma mark - KPTreeController delegate

- (void)treeController:(KPTreeController *)tree configureAnnotationForDisplay:(KPAnnotation *)annotation
{
}

- (IBAction)backToPhotos:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
