//
//  MGGradientView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 28.02.13.
//
//

#import "MGGradientView.h"

@interface MGGradientView (Private)
- (void)initView;
- (void)setColorsFromState;
@end


@implementation MGGradientView

- (void)awakeFromNib
{
	[self initView];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initView];
	}
	return self;
}

- (void)initView
{
	self.layer.shadowOffset = CGSizeMake(0, 0);
	_gradientLayer = [CAGradientLayer layer];
	_gradientLayer.frame = self.layer.bounds;
	[self.layer addSublayer:_gradientLayer];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_gradientLayer.frame = self.layer.bounds;
}

- (void)setGradientFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor
{
	NSArray *colors = @[(id) firstColor.CGColor, (id) secondColor.CGColor];
	_gradientLayer.colors = colors;
	_gradientLayer.locations = @[@0.0, @1.0];
}

- (void)drawRect:(CGRect)rect
{
	if ([self.layer.sublayers indexOfObject:_gradientLayer] != 0) {
		[_gradientLayer removeFromSuperlayer];
		[self.layer insertSublayer:_gradientLayer atIndex:0];
	}
	[super drawRect:rect];
}

@end
