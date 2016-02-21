//
//  PDToolbarButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 14.11.13.
//
//

#import "PDToolbarButton.h"
#import "UIImage+Extra.h"

@implementation PDToolbarButton

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self clearBackgroundColor];
	UIImage *blackImage = [[[UIImage alloc] init] imageWithColor:[UIColor blackColor]];
	UIImage *whiteImage = [[[UIImage alloc] init] imageWithColor:[UIColor whiteColor]];
	[self setBackgroundImage:whiteImage forState:UIControlStateNormal];
	[self setBackgroundImage:blackImage forState:UIControlStateSelected];
	[self setBackgroundImage:blackImage forState:UIControlStateSelected|UIControlStateHighlighted];
	self.titleLabel.shadowOffset = CGSizeZero;
	[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title forState:UIControlStateNormal];
    [self adjustFontSizeToFit];
}

- (void)adjustFontSizeToFit
{
    UIFont *font = self.titleLabel.font;
    CGSize size = self.titleLabel.frame.size;
    for (CGFloat maxSize = self.titleLabel.font.pointSize; maxSize >= self.titleLabel.minimumScaleFactor * self.titleLabel.font.pointSize; maxSize -= 1.f) {
        font = [font fontWithSize:maxSize];
        CGSize constraintSize = CGSizeMake(size.width, MAXFLOAT);
        CGSize labelSize = [self.title sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        
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
