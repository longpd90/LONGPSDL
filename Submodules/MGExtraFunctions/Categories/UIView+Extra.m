//
//  UIView+Extra.m
//  Pet Calendar
//
//  Created by Vitaliy Gozhenko on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+Extra.h"
#import "AdditionalFunctions.h"

@implementation UIView (Extra)

- (void)rasterizeLayer
{
	self.layer.shouldRasterize = YES;
	self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (CGPoint)centerOfView
{
	return CGPointMake(roundf(self.width / 2), roundf(self.height / 2));
}

- (CGFloat) width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
	self.frame = CGRectWithWidth(self.frame, width);
}

- (CGFloat) height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
	self.frame = CGRectWithHeight(self.frame, height);
}

- (CGFloat) x
{
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
	self.frame = CGRectWithX(self.frame, x);
}

- (CGFloat) y
{
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
	self.frame = CGRectWithY(self.frame, y);
}

- (CGFloat)bottomYPoint
{
	return self.y + self.height;
}

- (CGRect)zeroPositionFrame
{
	return CGRectMakeWithSize(0, 0, self.frame.size);
}

- (void)clearBackgroundColor
{
	self.backgroundColor = [UIColor clearColor];
}

- (CGFloat)rightXPoint
{
	return self.x + self.width;
}

- (void)setFullAutoresizingMask
{
	self.autoresizingMask = kFullAutoresizingMask;
}

- (UIViewController *)firstViewController 
{
    return (UIViewController *) [self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController
{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

+ (id)loadFromNibNamed:(NSString *)nibName
{
	if (![[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {
		if (isPhone()) {
			nibName = [nibName stringByAppendingString:@"_iPhone"];
		} else {
			nibName = [nibName stringByAppendingString:@"_iPad"];
		}
	}
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
	return [nib objectAtIndex:0];
}

- (void)showActivityWithStyle:(UIActivityIndicatorViewStyle)style color:(UIColor *)color
{
	self.userInteractionEnabled = NO;
	UIActivityIndicatorView *activityView = (UIActivityIndicatorView *) [self viewWithTagWithoutSubviews:kActivityViewTag];
	if (!activityView) {
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
		activityView.tag = kActivityViewTag;
    activityView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
		[activityView startAnimating];
		[self addSubview:activityView];
	}
	if (color) {
		activityView.color = color;
	}
	activityView.center = self.centerOfView;
}

- (void)showActivityWithStyle:(UIActivityIndicatorViewStyle)style
{
	[self showActivityWithStyle:style color:nil];
}

- (void)setAllSubviewsHidden:(BOOL)hidden
{
	for (UIView *view in self.subviews) {
    [view setHidden:hidden];
	}
}

- (void)hideActivity
{
	self.userInteractionEnabled = YES;
	UIView *activityView = [self viewWithTagWithoutSubviews:kActivityViewTag];
	if (!activityView) return;
	[activityView removeFromSuperview];
}

- (UIImage *)captureViewToUIImage
{
	UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return viewImage;
}

- (UIView *)viewWithTagWithoutSubviews:(NSUInteger)tag
{
	for (UIView *view in self.subviews) {
    if (view.tag == tag) return view;
	}
	
	return nil;
}

@end
