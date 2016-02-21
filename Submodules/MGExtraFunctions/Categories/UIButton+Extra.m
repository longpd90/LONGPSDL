//
//  UIButton+Extra.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIButton+Extra.h"

@implementation UIButton (Extra)

- (NSString *)title
{
	return [self titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
	[self setTitle:title forState:UIControlStateNormal];
}

- (void)setBackgroundImageForSelectedState:(UIImage *)image
{
	[self setBackgroundImage:image forState:UIControlStateSelected];
	[self setBackgroundImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void)setImageForSelectedState:(UIImage *)image
{
	[self setImage:image forState:UIControlStateSelected];
	[self setImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (void)setTitleForSelectedState:(NSString *)title
{
	[self setTitle:title forState:UIControlStateSelected];
	[self setTitle:title forState:UIControlStateSelected|UIControlStateHighlighted];
}
- (void)setTitleColorForSelectedState:(UIColor *)color
{
	[self setTitleColor:color forState:UIControlStateSelected];
	[self setTitleColor:color forState:UIControlStateSelected|UIControlStateHighlighted];
}

+ (UIButton *)buttonWithImage:(UIImage *)image
{
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
	[button setImage:image forState:UIControlStateNormal];
	return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title font :(UIFont *)font height:(int)height
{
	int width = [title sizeWithAttributes:@{NSFontAttributeName: font}].width + 14;
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	button.titleLabel.font = font;
	[button setTitle:title forState:UIControlStateNormal];
	return button;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state animated:(BOOL)animated
{
	if ([image isEqual:[self imageForState:state]]) return;
	
	if (animated) {
		self.alpha = 0;
		[self setImage:image forState:state];
		[UIView animateWithDuration:0.5 animations:^{
			self.alpha = 1;
		}];
	} else {
		[self setImage:image forState:state];
	}
}

@end
