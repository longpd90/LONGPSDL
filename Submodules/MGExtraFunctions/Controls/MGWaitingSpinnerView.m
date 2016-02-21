//
//  WaitingSpinnerView.m
//  motd App
//
//  Created by Виталий Гоженко on 18/2/12.
//  Copyright (c) 2012 Bootstrap Apps. All rights reserved.
//

#import "MGWaitingSpinnerView.h"
#import "AdditionalFunctions.h"

#define kHeightCenterAutoresizeMask UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin

#define kWidthCenterAutoresizeMask UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin

#define kFullAutoresizeMask UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin


@implementation MGWaitingSpinnerView
@synthesize spinner = _spinner;

- (id)initWithStyle:(UIActivityIndicatorViewStyle)style
{
	self = [self initWithFrame:CGRectZero];
	if (self) {
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
		self.autoresizingMask = kFullAutoresizeMask;	
		self.hidden = YES;
		
		self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
		self.spinner.autoresizingMask = kHeightCenterAutoresizeMask | kWidthCenterAutoresizeMask;
		[self addSubview:self.spinner];
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
	self.hidden = NO;
	self.frame = CGRectMakeWithSize(0, 0, self.superview.frame.size);
	self.spinner.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	[self.spinner startAnimating];
	if (self.superview) {
		[self.superview bringSubviewToFront:self];
	}
}

- (void)hide
{
	self.hidden = YES;
	[self.spinner stopAnimating];
	if (self.superview) {
		[self.superview sendSubviewToBack:self];
	}
}


@end
