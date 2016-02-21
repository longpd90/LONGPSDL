//
//  PDLandmarkAnnotation.h
//  Pashadelic
//
//  Created by LTT on 6/19/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PDLocation.h"

@interface PDLandmarkAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) PDLocation *location;
- (id)initWithLocation:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;
@end
