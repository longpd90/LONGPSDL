//
//  UIImage+FontAwesome.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 26.02.14.
//
//

#import "UIImage+FontAwesome.h"

@implementation UIImage (FontAwesome)

- (UIImage *)fontAwesomeImageForIcon:(FAKIcon *)icon imageSize:(CGSize)imageSize attributes:(NSDictionary *)attributes
{
	icon.attributes = attributes;
	return [icon imageWithSize:imageSize];
}

@end
