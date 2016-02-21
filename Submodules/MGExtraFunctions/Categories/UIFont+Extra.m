//
//  UIFont+Extra.m
//  FacebookCover
//
//  Created by Vitaliy Gozhenko on 10/20/14.
//  Copyright (c) 2014 Logiexcel. All rights reserved.
//

#import "UIFont+Extra.h"

@implementation UIFont (Extra)

- (BOOL)isBold
{
	UIFontDescriptor *fontDescriptor = self.fontDescriptor;
	UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
	return (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
}

- (BOOL)isItalic
{
	UIFontDescriptor *fontDescriptor = self.fontDescriptor;
	UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
	return (fontDescriptorSymbolicTraits & UIFontDescriptorTraitItalic);
}

- (UIFont *)normalFont
{
	return [UIFont fontWithName:self.familyName size:self.pointSize];
}

- (UIFont *)boldFont
{
	BOOL isItalic = self.isItalic;
	NSString *familyName = [self familyName];
	NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
	UIFont *boldFont;
	
	for (NSString *fontName in fontNames)
	{
		UIFont *font = [UIFont fontWithName:fontName size:self.pointSize];

		if (isItalic) {
			if (font.isItalic && font.isBold) {
				return font;
			}
			
		} else {
			if (font.isBold) {
				if (font.isItalic) {
					continue;
				} else {
					boldFont = font;
				}
			}
		}
	}
	
	if (!boldFont) {
		boldFont = self;
	}
	
	return boldFont;
}

- (UIFont *)italicFont
{
	BOOL isBold = self.isBold;
	NSString *familyName = [self familyName];
	NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
	UIFont *italicFont;
	
	for (NSString *fontName in fontNames)
	{
		UIFont *font = [UIFont fontWithName:fontName size:self.pointSize];
		
		if (isBold) {
			if (font.isItalic && font.isBold) {
				return font;
			}
			
		} else {
			if (font.isItalic) {
				if (font.isBold) {
					continue;
				} else {
					italicFont = font;
				}
			}
		}
	}
	
	if (!italicFont) {
		italicFont = self;
	}
	
	return italicFont;
}

@end
