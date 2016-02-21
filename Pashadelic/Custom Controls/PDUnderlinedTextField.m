//
//  PDUnderlinedTextField.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 24.02.14.
//
//

#import "PDUnderlinedTextField.h"

@interface PDUnderlinedTextField ()

- (void)applyFontColorToPlaceholder;

@end

@implementation PDUnderlinedTextField

- (void)awakeFromNib
{
  [self applyFontColorToPlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder
{
  [super setPlaceholder:placeholder];
  [self applyFontColorToPlaceholder];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self applyFontColorToPlaceholder];
  }
  return self;
}

- (void)applyFontColorToPlaceholder
{
  NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: self.textColor}];
  self.attributedPlaceholder = placeholder;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, self.textColor.CGColor);
  CGContextSetLineWidth(context, 1.0f);
  CGContextBeginPath(context);
  CGRect frame = [self textRectForBounds:self.bounds];
  NSUInteger y = self.height - 1;
  CGContextMoveToPoint(context, frame.origin.x, y);
  CGContextAddLineToPoint(context, frame.origin.x + frame.size.width, y);
  CGContextClosePath(context);
  CGContextStrokePath(context);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
  CGRect rect = [super textRectForBounds:bounds];
  rect.size.width -= 8;
  rect.origin.x += 8;
  return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
  return [self textRectForBounds:bounds];
}

@end
