//
//  PDPhotoClusterAnnotationView.h
//  Pashadelic
//
//  Created by LongPD on 12/27/13.
//
//

#import <MapKit/MapKit.h>
#import "PDDynamicFontLabel.h"

@interface PDPhotoClusterAnnotationView : MKAnnotationView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) PDDynamicFontLabel *numberPhotosLabel;
@property (nonatomic, weak) PDPhoto *photo;
@property (nonatomic, assign) NSInteger count;
@end
