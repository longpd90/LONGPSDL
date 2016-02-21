//
//  PDButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 9/11/12.
//
//

#import "PDGlobalFontButton.h"

@implementation PDGlobalFontButton

- (void)awakeFromNib
{
	[super awakeFromNib];
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
