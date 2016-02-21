//
//  PDPhotoClustersMapView.h
//  Pashadelic
//
//  Created by TungNT2 on 12/26/13.
//
//

#import "PDItemMapView.h"

@interface PDPhotoClustersMapView : PDItemMapView

- (double)getZoomLevelFromMapView:(MKMapView *)mapView;
- (CLLocationCoordinate2D)centerCoordinate;
- (void)changeRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
                            radius:(double)radius
                          animated:(BOOL)animated;
@end
