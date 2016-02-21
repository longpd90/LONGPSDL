//
//  UIView+Pashadelic.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 28.09.13.
//
//

#import "UIImage+Extra.h"
#import <CoreText/CoreText.h>

@implementation UIView (Pashadelic)

- (void)setRoundedCornersWithShadowStyle
{
	self.backgroundColor = [UIColor clearColor];
	self.layer.backgroundColor = [UIColor whiteColor].CGColor;
	self.layer.cornerRadius = 4;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowRadius = 3;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowOpacity = 0.33;
	self.layer.shadowPath =
	[UIBezierPath bezierPathWithRoundedRect:self.zeroPositionFrame
                             cornerRadius:self.layer.cornerRadius].CGPath;
}

- (void)applyGlobalFont
{
  if ([self isKindOfClass:[UIButton class]]) {
    UIButton *button = (UIButton *) self;
    button.titleLabel.font = [self getCustomFontForStandatdFont:button.titleLabel.font];
    
  } else if ([self isKindOfClass:[UILabel class]]) {
    UILabel *label = (UILabel *) self;
    label.font = [self getCustomFontForStandatdFont:label.font];
		
  } else if ([self isKindOfClass:[UITextField class]]) {
		UITextField *textField = (UITextField *) self;
		textField.font = [self getCustomFontForStandatdFont:textField.font];
		
	} else if ([self isKindOfClass:[UITextView class]]) {
		UITextView *textView = (UITextView *) self;
		textView.font = [self getCustomFontForStandatdFont:textView.font];
	}
}

- (UIFont *)getCustomFontForStandatdFont:(UIFont *)font
{
	if (SYSTEM_VERSION_LESS_THAN(@"7.0")) return font;
	
  UIFontDescriptor *fontDescriptor = font.fontDescriptor;
  UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
  BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
  BOOL isItalic = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitItalic);
  BOOL isLight = [font.fontName rangeOfString:@"light" options:NSCaseInsensitiveSearch].location != NSNotFound;
  if (isBold) {
    if (isItalic) {
      return [UIFont fontWithName:PDGlobalBoldItalicFontName size:font.pointSize];
    } else {
      return [UIFont fontWithName:PDGlobalBoldFontName size:font.pointSize];
    }
    
  } else if (isLight) {
    if (isItalic) {
      return [UIFont fontWithName:PDGlobalLightItalicFontName size:font.pointSize];
    } else {
      return [UIFont fontWithName:PDGlobalLightFontName size:font.pointSize];
    }
    
  } else if (isItalic) {
    return [UIFont fontWithName:PDGlobalNormalItalicFontName size:font.pointSize];
    
  } else {
    return [UIFont fontWithName:PDGlobalNormalFontName size:font.pointSize];
  }
}

- (void)applyGlobalStyleToAllSubviews
{
  for (UIView *subview in self.subviews) {
    [subview applyGlobalFont];
    if (subview.subviews.count > 0) {
      [subview applyGlobalStyleToAllSubviews];
    }
  }
}


@end

@implementation UIButton (Pashadelic)

- (void)applyRedStyleToButton
{
  UIImage *solidColorImage = [[[UIImage alloc] init] imageWithColor:kPDGlobalRedColor];
  [self setBackgroundImage:solidColorImage forState:UIControlStateNormal];
  self.layer.cornerRadius = 5;
  self.clipsToBounds = YES;
  [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self applyGlobalFont];
}

- (void)applyBlueStyleToButton
{
  UIImage *solidColorImage = [[[UIImage alloc] init] imageWithColor:kPDGlobalBlueColor];
  [self setBackgroundImage:solidColorImage forState:UIControlStateNormal];
  self.layer.cornerRadius = 5;
  self.clipsToBounds = YES;
  [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self applyGlobalFont];
}

@end