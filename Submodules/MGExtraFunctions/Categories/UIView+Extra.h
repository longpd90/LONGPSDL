//
//  UIView+Extra.h
//  Pet Calendar
//
//  Created by Vitaliy Gozhenko on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kFullAutoresizingMask UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

#define kActivityViewTag		2983

@interface UIView (Extra)

@property (nonatomic, getter=width, setter = setWidth:) CGFloat width;
@property (nonatomic, getter=height, setter = setHeight:) CGFloat height;
@property (nonatomic, getter=y, setter = setY:) CGFloat y;
@property (nonatomic, getter=x, setter = setX:) CGFloat x;

- (CGFloat) width;
- (void)setWidth:(CGFloat)width;
- (CGFloat) height;
- (void)setHeight:(CGFloat)height;
- (CGFloat) x;
- (void)setX:(CGFloat)x;
- (CGFloat) y;
- (void)setY:(CGFloat)y;

- (CGPoint) centerOfView;
- (CGFloat) bottomYPoint;
- (CGFloat) rightXPoint;
- (CGRect) zeroPositionFrame;

- (UIViewController *)firstViewController;
- (void)clearBackgroundColor;
- (void)setFullAutoresizingMask;
+ (id)loadFromNibNamed:(NSString *)nibName;
- (void)showActivityWithStyle:(UIActivityIndicatorViewStyle)style;
- (void)showActivityWithStyle:(UIActivityIndicatorViewStyle)style color:(UIColor *)color;
- (void)hideActivity;
- (void)rasterizeLayer;
- (UIView *)viewWithTagWithoutSubviews:(NSUInteger)tag;
- (void)setAllSubviewsHidden:(BOOL)hidden;
- (UIImage *)captureViewToUIImage;

@end
