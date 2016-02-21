//
//  PDDynamicFontLabel.m
//  Pashadelic
//
//  Created by TungNT2 on 10/24/13.
//
//

#import "PDDynamicFontLabel.h"

@implementation PDDynamicFontLabel

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
        _defaultSize = - 1.0;
        [self applyGlobalFont];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    if (_defaultSize > 0) {
        self.font = [self.font fontWithSize:_defaultSize];
    }
    [self adjustFontSizeToFit];
}

- (void)adjustFontSizeToFit {
    UIFont *font = self.font;
    CGSize size = self.frame.size;
    for (CGFloat maxSize = self.font.pointSize; maxSize >= self.minimumScaleFactor * self.font.pointSize; maxSize -= 1.f) {
        font = [font fontWithSize:maxSize];
        CGSize constraintSize = CGSizeMake(size.width, MAXFLOAT);
        CGSize labelSize = [self.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
        if(labelSize.height <= size.height) {
            self.font = font;
            [self setNeedsLayout];
            break;
        }
    }
    self.font = font;
    [self setNeedsLayout];
}

@end
