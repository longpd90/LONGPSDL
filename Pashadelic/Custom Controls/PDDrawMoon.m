//
//  NHADrawMoon.m
//  drawMoon
//
//  Created by Nguyễn Hữu Anh on 8/28/13.
//  Copyright (c) 2013 anhnh. All rights reserved.
//

#import "PDDrawMoon.h"

@implementation PDDrawMoon

- (id)initWithFrame:(CGRect)frame andRadius: (float)radius option: (float)option
{
    self = [super initWithFrame:frame];
    if (self) {
        self.radius = radius;
        self.option = option;
        self.drawColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawMoon:(float)radius andOption:(float)option color:(UIColor *)color
{
    self.drawColor = color;
    self.radius = radius;
    self.option = option;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (self.option != self.option) return;

    float xcenter=self.frame.size.width / 2.0;
    float ycenter=self.frame.size.height / 2.0;
    [super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    
    CGContextAddArc(context, xcenter, ycenter, self.radius, 0.5 * M_PI , 1.5 * M_PI, 0);

    CGContextSetFillColorWithColor(context, _drawColor.CGColor);
    float d = self.radius * (0.5 - self.option) * 2;
    float l = 4 * tan(M_PI / 8) /3 ;
    CGContextAddCurveToPoint(context, xcenter - d * l, ycenter - self.radius, xcenter - d, ycenter - self.radius * l, xcenter - d, ycenter);
    CGContextAddCurveToPoint(context, xcenter - d, ycenter + self.radius * l, xcenter - d * l, ycenter + self.radius, xcenter, ycenter + self.radius);
    CGContextFillPath(context);
    CGContextStrokePath(context);
}

@end
