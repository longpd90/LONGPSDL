//
//  UIImageView+FontAwesome.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 26.02.14.
//
//

#import "UIImageView+FontAwesome.h"

@implementation UIImageView (FontAwesome)

- (void)setFontAwesomeIconForImage:(FAKIcon *)icon withAttributes:(NSDictionary *)attributes;
{
	icon.attributes = attributes;
	self.contentMode = UIViewContentModeCenter;
	self.image = [icon imageWithSize:CGSizeMake(icon.iconFontSize + 5, icon.iconFontSize + 5)];
}

@end
