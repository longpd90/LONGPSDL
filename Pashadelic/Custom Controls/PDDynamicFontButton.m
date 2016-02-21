//
//  PDDynamicFontButton.m
//  Pashadelic
//
//  Created by TungNT2 on 5/29/14.
//
//

#import "PDDynamicFontButton.h"

@implementation PDDynamicFontButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    _defaultSize = - 1.0;
    [self applyGlobalFont];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _defaultSize = - 1.0;
        [self applyGlobalFont];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (_defaultSize > 0) {
        self.titleLabel.font = [self.titleLabel.font fontWithSize:_defaultSize];
    }
    [self adjustFontSizeToFit];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    if (_defaultSize > 0) {
        self.titleLabel.font = [self.titleLabel.font fontWithSize:_defaultSize];
    }
    [self adjustFontSizeToFit];
}

- (void)adjustFontSizeToFit {
    UIFont *font = self.titleLabel.font;
    CGSize size = CGSizeMake(self.titleLabel.width, self.titleLabel.height);
    for (CGFloat maxSize = self.titleLabel.font.pointSize; maxSize >= self.titleLabel.minimumScaleFactor * self.titleLabel.font.pointSize; maxSize -= 1.f) {
        font = [font fontWithSize:maxSize];
        CGSize constraintSize = CGSizeMake(size.width, MAXFLOAT);
        CGSize labelSize = [self.titleLabel.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        if(labelSize.height <= size.height) {
            self.titleLabel.font = font;
            [self setNeedsLayout];
            break;
        }
    }
    // set the font to the minimum size anyway
    self.titleLabel.font = font;
    [self setNeedsLayout];
}

@end
