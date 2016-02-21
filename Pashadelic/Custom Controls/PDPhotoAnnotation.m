//
//  PDPhotoAnnotation.m
//  Pashadelic
//
//  Created by LongPD on 12/23/13.
//
//

#import "PDPhotoAnnotation.h"

@implementation PDPhotoAnnotation
- (id)initWithTitle:(NSString *)title coordinate:(CLLocationCoordinate2D)coordinate {
	if (self) {
        self.title = title;
		self.coordinate = coordinate;
	}
	return self;
}
@end
