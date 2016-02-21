//
//  PDPOILocationView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 16.06.13.
//
//

#import "PDPOILocationView.h"

@implementation PDPOILocationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self) {
		self.canShowCallout = NO;
		self.image = [UIImage imageNamed:@"icon-poi-pin.png"];
		self.centerOffset = CGPointMake(0, -round(self.image.size.height / 2));
	}
	return self;
}

@end
