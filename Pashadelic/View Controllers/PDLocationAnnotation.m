//
//  PDLocationAnnotation.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 31/10/12.
//
//

#import "PDLocationAnnotation.h"

@implementation PDLocationAnnotation

- (id)initWithCoordinates:(CLLocationCoordinate2D)coordinates
{
	self = [super init];
	if (self) {
		self.coordinate = coordinates;
	}
	return self;
}

- (NSString *)title
{
	return nil;
}

- (NSString *)subtitle
{
	return nil;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
	_coordinate = coordinate;
}

@end
