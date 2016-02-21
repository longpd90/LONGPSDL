//
//  PDLinedLabel.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 19.04.13.
//
//

#import "PDLinedLabel.h"

@implementation PDLinedLabel

- (void)awakeFromNib
{
    [super awakeFromNib];
	self.textAlignment = NSTextAlignmentCenter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	if (self.textAlignment != NSTextAlignmentCenter) return;
	
	int textWidth = [self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)].width,
	width = self.width, lineWidth = (width - textWidth - 8) / 2;
	double lineY = round(self.height / 2 + self.font.pointSize * 0.12) - 0.5;
	
	if (textWidth > width - 26) return;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.textColor.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, 0, lineY);
    CGContextAddLineToPoint(context, lineWidth, lineY);
	CGContextStrokePath(context);
	CGContextMoveToPoint(context, width - lineWidth, lineY);
    CGContextAddLineToPoint(context, width, lineY);
	CGContextStrokePath(context);

	if (self.shadowOffset.height != 0 && self.shadowColor) {
		CGContextSetStrokeColorWithColor(context, self.shadowColor.CGColor);
		CGContextMoveToPoint(context, 0, lineY + self.shadowOffset.height);
		CGContextAddLineToPoint(context, lineWidth, lineY + self.shadowOffset.height);
		CGContextStrokePath(context);
		CGContextMoveToPoint(context, width - lineWidth, lineY + self.shadowOffset.height);
		CGContextAddLineToPoint(context, width, lineY + self.shadowOffset.height);
		CGContextStrokePath(context);
	}
}


@end
