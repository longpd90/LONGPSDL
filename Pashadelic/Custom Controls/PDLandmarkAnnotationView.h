//
//  PDLandmarkAnnotationView.h
//  Pashadelic
//
//  Created by LongPD on 6/27/14.
//
//

#import <MapKit/MapKit.h>
#import "PDPhotoLandMarkItem.h"

@interface PDLandmarkAnnotationView : MKAnnotationView

@property (nonatomic, strong) PDPhotoLandMarkItem *landmark;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *photoCountLabel;
@property (nonatomic, strong) UILabel *userCountLabel;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

@end
