//
//  MGPopupView.m
//  Order&Pay
//
//  Created by Vitaliy Gozhenko on 09.12.12.
//
//

#import "MGPopupView.h"
#import "UIView+Extra.h"

@implementation MGPopupView

- (id)initWithView:(UIView *)view
{
	_presentingView = view;
	window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	self = [super initWithFrame:window.frame];
 	if (self) {
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	_presentingView.center = self.centerOfView;
	if (![[UIApplication sharedApplication] isStatusBarHidden]) {
		_presentingView.y += [[UIApplication sharedApplication] statusBarFrame].size.height / 2;
	}
}

- (void)show
{
	[self setNeedsLayout];
	[window addSubview:self];
	[self addSubview:_presentingView];
	_presentingView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		_presentingView.transform = CGAffineTransformMakeScale(1.1, 1.1);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.1 animations:^{
			_presentingView.transform = CGAffineTransformIdentity;
		}];
	}];
}

- (void)hide
{
	[UIView animateWithDuration:0.2 animations:^{
		_presentingView.transform = CGAffineTransformMakeScale(0.01, 0.01);
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
		[_presentingView removeFromSuperview];
		_presentingView.transform = CGAffineTransformIdentity;
	}];
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

@end
