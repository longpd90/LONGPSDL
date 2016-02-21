//
//  PDToolbarGradientButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 11.04.13.
//
//

#import "PDToolbarGradientButton.h"

@implementation PDToolbarGradientButton

- (void)initialize
{
	[self setGradientFirstColor:PDToolbarGradientFirstColor
					secondColor:PDToolbarGradientSecondColor
					   forState:UIControlStateNormal];
	
	[self setGradientFirstColor:[UIColor colorWithWhite:0.85 alpha:1]
					secondColor:[UIColor colorWithWhite:0.9 alpha:1]
					   forState:UIControlStateSelected];
	
	[self setGradientFirstColor:[UIColor colorWithWhite:0.85 alpha:1]
					secondColor:[UIColor colorWithWhite:0.9 alpha:1]
					   forState:UIControlStateSelected|UIControlStateHighlighted];
	
	[self setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateSelected];
	[self setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateSelected|UIControlStateHighlighted];
	
	[self setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	self.titleLabel.shadowOffset = CGSizeMake(0, 0.5);

	self.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:15];
	
	self.layer.borderColor = [UIColor colorWithWhite:0.92 alpha:0.1].CGColor;
	self.layer.borderWidth = 0.3;
	
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
