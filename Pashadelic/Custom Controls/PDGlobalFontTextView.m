//
//  PDGlobalFontTextView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 26.02.14.
//
//

#import "PDGlobalFontTextView.h"

@implementation PDGlobalFontTextView

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
