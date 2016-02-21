//
//  PDGradientButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.01.13.
//
//

#import "PDGradientButton.h"

#define kPDBlueButtonFirstColor				[UIColor colorWithRed:0/255.0 green:112/255.0 blue:158/255.0 alpha:1]
#define kPDBlueButtonSecondColor			[UIColor colorWithRed:7/255.0 green:85/255.0 blue:125/255.0 alpha:1]
#define kPDBlueButtonBorderColor			[UIColor colorWithRed:0/255.0 green:112/255.0 blue:158/255.0 alpha:1]
#define kPDBlueButtonFontColor				[UIColor colorWithWhite:1 alpha:1]

#define kPDBlueLightButtonFirstColor		[UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1]
#define kPDBlueLightButtonBorderColor		[UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1]
#define kPDBlueLightButtonFontColor			[UIColor whiteColor]

#define kPDBlueDarkButtonFirstColor         [UIColor colorWithRed:43/255.0 green:118/255.0 blue:194/255.0 alpha:1]
#define kPDBlueDarkButtonBorderColor		[UIColor colorWithRed:43/255.0 green:118/255.0 blue:194/255.0 alpha:1]
#define kPDBlueDarkButtonFontColor			[UIColor whiteColor]

#define kPDOrangeButtonFirstColor			[UIColor colorWithRed:222/255.0 green:88/255.0 blue:1/255.0 alpha:1]
#define kPDOrangeButtonSecondColor			[UIColor colorWithRed:255/255.0 green:102/255.0 blue:0/255.0 alpha:1]
#define kPDOrangeButtonBorderColor			[UIColor colorWithRed:222/255.0 green:88/255.0 blue:1/255.0 alpha:1]
#define kPDOrangeButtonFontColor			[UIColor colorWithWhite:1 alpha:1]

#define kPDGrayButtonFirstColor				[UIColor colorWithWhite:255/255.0 alpha:1]
#define kPDGrayButtonSecondColor			[UIColor colorWithWhite:250/255.0 alpha:1]
#define kPDGrayButtonBorderColor			[UIColor colorWithWhite:238/255.0 alpha:1]
#define kPDGrayButtonFontColor				[UIColor colorWithRed:105/255.0 green:105/255.0 blue:105/255.0 alpha:1]

#define kPDLightGrayButtonFirstColor        [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define kPDLightGrayButtonBorderColor       [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define kPDLightGrayButtonFontColor		    [UIColor whiteColor]

#define kPDWhiteSmokeButtonFirstColor       [UIColor colorWithRed:236/255.0 green:242/255.0 blue:245/255.0 alpha:1]
#define kPDWhiteSmokeButtonFontColor        [UIColor colorWithRed:99/255.0 green:122/255.0 blue:130/255.0 alpha:1]
#define kPDWhiteSmokeButtonBorderColor      [UIColor colorWithRed:207/255.0 green:215/255.0 blue:219/255.0 alpha:1]

@interface PDGradientButton	(Private)
@end


@implementation PDGradientButton

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self initialize];
    
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize
{
	
}

- (UIEdgeInsets)alignmentRectInsets {
    UIEdgeInsets insets;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        insets = UIEdgeInsetsMake(-7.5, 0, 0, 0);
    } else {
        if (self.theSideBarButton == kPDSideLeftBarButton) {
            insets = UIEdgeInsetsMake(-7.5, 0, 0, 10);
        } else {
            insets = UIEdgeInsetsMake(-7.5, 10, 0, 0);
        }
    }
    
    return insets;
}

- (void)setRedGradientButtonStyle
{
	[self clearBackgroundColor];
	[self setGradientFirstColor:kPDGlobalRedColor
                    secondColor:kPDGlobalRedColor
					   forState:UIControlStateNormal];

    self.layer.borderColor = [UIColor clearColor].CGColor;
	[self setTitleColor:kPDBlueLightButtonFontColor forState:UIControlStateNormal];
	[self setTitleColor:kPDBlueLightButtonFontColor forState:UIControlStateHighlighted];
	[self setTitleColor:kPDBlueLightButtonFontColor forState:UIControlStateSelected];
	[self setTitleColor:kPDBlueLightButtonFontColor forState:UIControlStateHighlighted|UIControlStateSelected];
    [self setTitleColor:kPDLightGrayButtonFontColor forState:UIControlStateDisabled];
    [self setRoundedCornerStyle];
    self.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:12];
}

- (void)setBlueDarkGradientButtonStyle
{
    [self clearBackgroundColor];
	[self setGradientFirstColor:kPDBlueDarkButtonFirstColor
                    secondColor:kPDBlueDarkButtonFirstColor
					   forState:UIControlStateNormal];
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
	[self setTitleColor:kPDBlueDarkButtonFontColor forState:UIControlStateNormal];
	[self setTitleColor:kPDBlueDarkButtonFontColor forState:UIControlStateHighlighted];
	[self setTitleColor:kPDBlueDarkButtonFontColor forState:UIControlStateSelected];
	[self setTitleColor:kPDBlueDarkButtonFontColor forState:UIControlStateHighlighted|UIControlStateSelected];
    [self setRoundedCornerStyle];
}

- (void)setOrangeGradientButtonStyle
{
	[self clearBackgroundColor];
	[self setGradientFirstColor:kPDOrangeButtonFirstColor
                    secondColor:kPDOrangeButtonSecondColor
					   forState:UIControlStateNormal];
    self.layer.borderColor = [UIColor clearColor].CGColor;
	[self setTitleColor:kPDOrangeButtonFontColor forState:UIControlStateNormal];
	[self setTitleColor:kPDOrangeButtonFontColor forState:UIControlStateHighlighted];
	[self setTitleColor:kPDOrangeButtonFontColor forState:UIControlStateSelected];
	[self setTitleColor:kPDOrangeButtonFontColor forState:UIControlStateHighlighted|UIControlStateSelected];
    [self setRoundedCornerStyle];
}

- (void)setGrayGradientButtonStyle
{
	[self clearBackgroundColor];
	[self setGradientFirstColor:kPDGrayButtonFirstColor
					secondColor:kPDGrayButtonSecondColor
					   forState:UIControlStateNormal];
	self.layer.borderColor = kPDGrayButtonBorderColor.CGColor;
	[self setTitleColor:kPDGrayButtonFontColor forState:UIControlStateNormal];
	[self setTitleColor:kPDGrayButtonFontColor forState:UIControlStateHighlighted];
	[self setTitleColor:kPDGrayButtonFontColor forState:UIControlStateSelected];
	[self setTitleColor:kPDGrayButtonFontColor forState:UIControlStateHighlighted|UIControlStateSelected];
	[self setRoundedCornerStyle];
	
	if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ja"]) {
		self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName
											   size:round(self.titleLabel.font.pointSize * 0.9)];
	}
}

- (void)setGrayLightGradientButtonStyle
{
	[self clearBackgroundColor];
	[self setGradientFirstColor:kPDLightGrayButtonFirstColor
					secondColor:kPDLightGrayButtonFirstColor
					   forState:UIControlStateNormal];
	self.layer.borderColor = kPDLightGrayButtonFirstColor.CGColor;
	[self setTitleColor:kPDLightGrayButtonFontColor forState:UIControlStateNormal];
	[self setTitleColor:kPDLightGrayButtonFontColor forState:UIControlStateHighlighted];
	[self setTitleColor:kPDLightGrayButtonFontColor forState:UIControlStateSelected];
	[self setTitleColor:kPDLightGrayButtonFontColor forState:UIControlStateHighlighted|UIControlStateSelected];
	[self setRoundedCornerStyle];
	
	if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ja"]) {
		self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName
											   size:round(self.titleLabel.font.pointSize * 0.9)];
	}
}

- (void)setWhiteSmokeGradientButtonStyle
{
	[self clearBackgroundColor];
	[self setGradientFirstColor:kPDWhiteSmokeButtonFirstColor
					secondColor:kPDWhiteSmokeButtonFirstColor
					   forState:UIControlStateNormal];
	self.layer.borderColor = [UIColor clearColor].CGColor;
	[self setTitleColor:kPDWhiteSmokeButtonFontColor forState:UIControlStateNormal];
	[self setTitleColor:kPDWhiteSmokeButtonFontColor forState:UIControlStateHighlighted];
	[self setTitleColor:kPDWhiteSmokeButtonFontColor forState:UIControlStateSelected];
	[self setTitleColor:kPDWhiteSmokeButtonFontColor forState:UIControlStateHighlighted|UIControlStateSelected];
	[self setRoundedCornerStyle];
    
	self.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:12];
	if ([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"ja"]) {
		self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName
											   size:round(self.titleLabel.font.pointSize * 0.9)];
	}
}

- (void)setRoundedCornerStyle
{
	self.clipsToBounds = YES;
	self.layer.cornerRadius = 3;
	self.gradientLayer.cornerRadius = 3;
	self.layer.borderWidth = 1;
}

@end
