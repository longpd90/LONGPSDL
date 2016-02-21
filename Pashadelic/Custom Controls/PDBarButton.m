//
//  PDBarButton.m
//  Pashadelic
//
//  Created by LongPD on 10/14/13.
//
//

#import "PDBarButton.h"

@implementation PDBarButton

- (id)initWithImage:(UIImage *)image withSide:(kPDSideBarButton)theSide
{
    self = [super init];
    if (self) {
        self.sideBarButton = theSide;
        self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (UIEdgeInsets)alignmentRectInsets {
    UIEdgeInsets insets;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        insets = UIEdgeInsetsMake(4, 0, 0, 0);
    } else {
        if (self.sideBarButton == kPDSideLeftBarButton) {
            insets = UIEdgeInsetsMake(0, 10, 0, 0);
        } else if (self.sideBarButton == kPDSideLeftGrayAngleBarButton) {
            insets = UIEdgeInsetsMake(5, 20, 0, 0);
        } else {
            insets = UIEdgeInsetsMake(-7.5, 0, -10, 15);
        }
    }
    
    return insets;
}

- (void)setImageForSelectedState:(UIImage *)image
{
	[self setImage:image forState:UIControlStateSelected];
	[self setImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
}

@end
