//
//  PDPlanAnnotaion.h
//  Pashadelic
//
//  Created by LongPD on 11/15/13.
//
//

#import <Foundation/Foundation.h>

@interface PDPlanAnnotaion : NSObject<MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readwrite) CLLocationCoordinate2D coordinate;
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate;
@end
