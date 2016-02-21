//
//  PDPlanAnnotaion.m
//  Pashadelic
//
//  Created by LongPD on 11/15/13.
//
//

#import "PDPlanAnnotaion.h"

@implementation PDPlanAnnotaion
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate {
	if (self) {
        self.title = title;
		self.coordinate = coordinate;
	}
	return self;
}
@end
