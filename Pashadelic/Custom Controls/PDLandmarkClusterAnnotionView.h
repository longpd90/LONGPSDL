//
//  PDLandmarkClusterAnnotionView.h
//  Pashadelic
//
//  Created by LongPD on 6/27/14.
//
//

#import <MapKit/MapKit.h>
#import "PDPhotoLandMarkItem.h"
#import "PDDynamicFontLabel.h"

@interface PDLandmarkClusterAnnotionView : MKAnnotationView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) PDDynamicFontLabel *numberPhotosLabel;
@property (nonatomic, strong) PDPhotoLandMarkItem *landmark;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UILabel *photoCountLabel;
@property (nonatomic, strong) UILabel *userCountLabel;

@end
