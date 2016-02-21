//
//  MGGradientButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.01.13.
//
//

#import "MGGradientButton.h"

@interface MGGradientButton (Private)
- (void)initButton;
- (void)setColorsFromState;
@end


@implementation MGGradientButton

- (void)awakeFromNib
{
	[self initButton];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initButton];
	}
	return self;
}

- (void)initButton
{
	self.layer.shadowOffset = CGSizeMake(0, 0);	
	_gradientLayer = [CAGradientLayer layer];
	_gradientLayer.frame = self.layer.bounds;
	_gradientColors = [NSMutableDictionary dictionary];
	[self.layer addSublayer:_gradientLayer];
	
	_highlightLayer = [CALayer layer];
	_highlightLayer.frame = self.layer.bounds;
	_highlightLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35].CGColor;
	_highlightLayer.hidden = YES;
	[self.layer addSublayer:_highlightLayer];
}

- (void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
	_gradientLayer.frame = self.layer.bounds;
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	[self setColorsFromState];
}

- (void)setHighlighted:(BOOL)highlighted
{
	_highlightLayer.hidden = !highlighted;
	[super setHighlighted:highlighted];
}

- (void)setColorsFromState
{
	NSArray *colors = [_gradientColors objectForKey:[NSNumber numberWithInt:self.state]];
	if (!colors) {
		colors = [_gradientColors objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
	}
	_gradientLayer.colors = colors;
}

- (void)setGradientFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor forState:(UIControlState)state
{
	NSArray *colors = @[(id) firstColor.CGColor, (id) secondColor.CGColor];
	[_gradientColors setObject:colors forKey:[NSNumber numberWithInt:state]];
	
	if (state == self.state) {
		_gradientLayer.colors = colors;
		_gradientLayer.locations = @[@0.0, @1.0];
	}
}

- (void)drawRect:(CGRect)rect
{
	if ([self.layer.sublayers indexOfObject:_gradientLayer] != 0) {
		[_gradientLayer removeFromSuperlayer];
		[self.layer insertSublayer:_gradientLayer atIndex:0];
		[_highlightLayer removeFromSuperlayer];
		[self.layer insertSublayer:_highlightLayer above:_gradientLayer];
	}
	[super drawRect:rect];
}

@end
