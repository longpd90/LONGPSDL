//
//  PDPhotoAnnotationView.h
//  Pashadelic
//
//  Created by LongPD on 12/23/13.
//
//

#import <MapKit/MapKit.h>
#import "PDPhoto.h"

@interface PDPhotoAnnotationView : MKAnnotationView
@property (nonatomic, weak) PDPhoto *photo;
@property (nonatomic, strong) UIImageView *photoImageView;
@end
