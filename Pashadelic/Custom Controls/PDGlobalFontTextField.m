//
//  PDGlobalFontTextField.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 26.02.14.
//
//

#import "PDGlobalFontTextField.h"

@implementation PDGlobalFontTextField

- (void)awakeFromNib
{
  [self applyGlobalFont];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self applyGlobalFont];
  }
  return self;
}

@end
