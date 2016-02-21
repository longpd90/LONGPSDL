//
//  UIColor+Extra.m
//  Starlunch
//
//  Created by Vitaliy Gozhenko on 15.09.13.
//  Copyright (c) 2013 Appstructors. All rights reserved.
//

#import "UIColor+Extra.h"

@implementation UIColor (Extra)

+ (UIColor *)colorWithInteger:(NSInteger)integer
{
	CGFloat red = integer % 256;
	integer = integer / 256;
	CGFloat green = integer % 256;
	integer = integer / 256;
	CGFloat blue = integer % 256;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *) colorWithIntRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha
{
	CGFloat floatRed = red / 255.0;
	CGFloat floatGreen = green / 255.0;
	CGFloat floatBlue = blue / 255.0;
	CGFloat floatAlpha = alpha / 255.0;
	return [UIColor colorWithRed:floatRed green:floatGreen blue:floatBlue alpha:floatAlpha];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
	if (hexString.length == 0) return nil;
	unsigned red, green, blue, alpha = 255;
	if (hexString.length < 8) {
		sscanf([hexString UTF8String], "#%2X%2X%2X", &red, &green, &blue);
	} else {
		sscanf([hexString UTF8String], "#%2X%2X%2X%2X", &alpha, &red, &green, &blue);
	}
	
	return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha / 255.0];
}

- (UIColor *)grayscaleColor
{
	CGFloat red = 0;
    CGFloat blue = 0;
    CGFloat green = 0;
    CGFloat alpha = 0;
    if ([self getRed:&red green:&green blue:&blue alpha:&alpha]) {
        return [UIColor colorWithWhite:(0.299*red + 0.587*green + 0.114*blue) alpha:alpha];
    } else {
        return self;
    }
}

@end
