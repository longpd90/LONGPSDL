//
//  PDListLandmarkMapViewController.m
//  Pashadelic
//
//  Created by LongPD on 6/27/14.
//
//

#import "PDListLandmarkMapViewController.h"
#import "KPAnnotation.h"
#import "PDPhotoAnnotation.h"
#import "PDPhotoAnnotationView.h"
#import "PDPhotoClusterAnnotationView.h"
#import "PDServerPhotospotsLoader.h"
#import "PDLandmarkAnnotation.h"
#import "PDLandmarkAnnotationCalloutView.h"
#import "PDPhotoLandMarkItem.h"

@interface PDListLandmarkMapViewController ()

@end

@implementation PDListLandmarkMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if (self.landmarks) {
        self.landmarks = self.landmarks;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
- (void)setLandmarks:(NSArray *)landmarks
{
    [super setLandmarks:landmarks];
    if (self.isViewLoaded)
        [self refreshMapViewAndChangeRegion:YES];
}

#pragma mark - KPTreeController delegate

- (IBAction)backToPhotos:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
