//
//  PDForegroundWaitingSpinner.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 22/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MGRotatingWaitingSpinner.h"
#import "AdditionalFunctions.h"
#import <QuartzCore/QuartzCore.h>

#define kHeightCenterAutoresizeMask UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin

#define kWidthCenterAutoresizeMask UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

#define kFullAutoresizeMask UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin

@implementation MGRotatingWaitingSpinner
@synthesize spinner = _spinner, foreground;

- (id)initWithStyle:(UIActivityIndicatorViewStyle)style
{
	self = [super initWithStyle:style];
	if (self) {
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
		self.autoresizingMask = kFullAutoresizeMask;
		foreground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		foreground.layer.cornerRadius = 20;
		foreground.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
		[self addSubview:foreground];
		[foreground addSubview:self.spinner];
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)show
{
	if (self.hidden) {
		self.hidden = NO;
		[self resetForeground];
	}
	self.frame = CGRectMakeWithSize(0, 0, self.superview.frame.size);
	[self.spinner startAnimating];
	if (self.superview) {
		[self.superview bringSubviewToFront:self];
	}
	self.foreground.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	self.spinner.center = CGPointMake(foreground.frame.size.width / 2, foreground.frame.size.height / 2);
		
	CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 0.5];
    rotationAnimation.duration = 1;
    rotationAnimation.repeatCount = 9999;
	rotationAnimation.cumulative = YES;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:1 :0 :0 :0];
	
    [self.foreground.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

- (void)resetForeground
{
	self.foreground.transform = CGAffineTransformIdentity;
	[self.foreground.layer removeAnimationForKey:@"rotationAnimation"];
}

- (void)hide
{
	[UIView animateWithDuration:0.15 animations:^{
		foreground.transform = CGAffineTransformMakeScale(0.01, 0.01);
		self.alpha = 0;
		
	} completion:^(BOOL finished) {
		self.hidden = YES;
		self.alpha = 1;
		[self resetForeground];
		[self.spinner stopAnimating];
		if (self.superview) {
			[self.superview sendSubviewToBack:self];
		}
	}];

}

@end
