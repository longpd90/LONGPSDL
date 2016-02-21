//
//  PDLocationAnnotation.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 31/10/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PDLocationAnnotation : NSObject
<MKAnnotation>

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinates:(CLLocationCoordinate2D)coordinates;

@end
