//
// TECustomRoundRectButton.m
//
// Created by Tuấn Nguyễn Anh on 6/3/13.
// Copyright (c) 2013 Tuấn Nguyễn Anh. All rights reserved.
//

#import "TECustomRoundRectButton.h"

@implementation TECustomRoundRectButton
@synthesize cornerRadius, strokeWidth, defaultFont, rectColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        cornerRadius = 10;
        strokeWidth = 0.5;
        rectColor = [UIColor whiteColor];
        self.layer.cornerRadius = cornerRadius;
        defaultFont = [UIFont fontWithName:@"Helvetica" size:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = defaultFont;
        
    }
    return self;
}

- (void) setDefaultFont:(UIFont *)newFont
{
    defaultFont = newFont;
    self.titleLabel.font = defaultFont;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetFillColorWithColor(context, rectColor.CGColor);
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerRadius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerRadius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerRadius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerRadius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end