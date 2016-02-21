//
//  PDLinedButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.06.13.
//
//

#import "PDLinedButton.h"

@implementation PDLinedButton

- (void)awakeFromNib
{
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	int width = self.width - 5;
	double lineY = round(self.height / 2 + self.titleLabel.font.pointSize / 2) + 1.5;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [self titleColorForState:UIControlStateNormal].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 5, lineY);
    CGContextAddLineToPoint(context, width, lineY);
	CGContextStrokePath(context);
}

@end
