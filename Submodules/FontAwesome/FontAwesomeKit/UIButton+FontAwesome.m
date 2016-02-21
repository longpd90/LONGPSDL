//
//  UIButton+FontAwesome.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 26.02.14.
//
//

#import "UIButton+FontAwesome.h"

@implementation UIButton (FontAwesome)

- (void)setFontAwesomeIconForImage:(FAKIcon *)icon forState:(UIControlState)state attributes:(NSDictionary *)attributes
{
	icon.attributes = attributes;
	self.imageView.contentMode = UIViewContentModeCenter;
	NSUInteger size = MIN(self.frame.size.height, self.frame.size.width);
	[self setImage:[icon imageWithSize:CGSizeMake(size, size)] forState:state];
	
	if (state == UIControlStateSelected) {
		[self setFontAwesomeIconForImage:icon forState:UIControlStateSelected|UIControlStateHighlighted attributes:attributes];
	}
}

- (void)setFontAwesomeIconForBackgroundImage:(FAKIcon *)icon forState:(UIControlState)state attributes:(NSDictionary *)attributes
{
	icon.attributes = attributes;
	[self setBackgroundImage:[icon imageWithSize:self.frame.size] forState:state];
	
	if (state == UIControlStateSelected) {
		[self setFontAwesomeIconForBackgroundImage:icon forState:UIControlStateSelected|UIControlStateHighlighted attributes:attributes];
	}
}

- (void)setFontAwesomeIconForTitle:(FAKIcon *)icon forState:(UIControlState)state
{
	self.titleLabel.font = [UIFont fontWithName:icon.iconFont.fontName size:self.titleLabel.font.pointSize];
	[self setTitle:icon.characterCode forState:state];
	
	if (state == UIControlStateSelected) {
		[self setFontAwesomeIconForTitle:icon forState:UIControlStateSelected|UIControlStateHighlighted];
	}
}

@end
