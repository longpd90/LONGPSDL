//
//  PDDynamicSizeButton.m
//  Pashadelic
//
//  Created by TungNT2 on 6/14/14.
//
//

#import "PDDynamicSizeButton.h"

@implementation PDDynamicSizeButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self applyGlobalFont];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self applyGlobalFont];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self adjustSizeToFit];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self adjustSizeToFitForState:state];
}

- (void)adjustSizeToFit
{
    NSString *title = self.title;
    CGSize size = [title sizeWithFont:self.titleLabel.font
                         constrainedToSize:CGSizeMake(1000, 1000)
                             lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = size.width + self.imageView.width + 10;
    CGFloat x = self.superview.width - width;
    self.frame = CGRectMake(x, self.y, width, self.height);
    [self setNeedsLayout];
}

- (void)adjustSizeToFitForState:(UIControlState)state
{
    NSString *title = [self titleForState:state];
    CGSize size = [title sizeWithFont:self.titleLabel.font
                         constrainedToSize:CGSizeMake(1000, 1000)
                             lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat width = size.width + self.imageView.width + 10;
    CGFloat x = self.superview.width - width;
    self.frame = CGRectMake(x, self.y, width, self.height);
    [self setNeedsLayout];
}

@end
