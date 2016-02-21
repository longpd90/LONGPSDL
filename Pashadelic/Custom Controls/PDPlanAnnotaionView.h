//
//  PDPlanAnnotaionView.h
//  Pashadelic
//
//  Created by LongPD on 11/15/13.
//
//

#import <MapKit/MapKit.h>

@interface PDPlanAnnotaionView : MKAnnotationView

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withImage:(UIImage *)image;

@end
