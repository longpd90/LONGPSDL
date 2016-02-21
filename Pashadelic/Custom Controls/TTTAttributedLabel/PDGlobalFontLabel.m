//
//  PDGlobalFontLabel.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 24.02.14.
//
//

#import "PDGlobalFontLabel.h"

@implementation PDGlobalFontLabel

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self applyGlobalFont];
  }
  return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
  [self applyGlobalFont];
}

@end
