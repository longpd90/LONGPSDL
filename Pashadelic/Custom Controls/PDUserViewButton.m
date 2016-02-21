//
//  PDUserViewButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 03.02.13.
//
//

#import "PDUserViewButton.h"

@interface PDUserViewButton ()
- (void)initialize;
@end

@implementation PDUserViewButton

- (void)awakeFromNib
{
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
	int height = 30;
	_subtitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height - height, self.width, height)];
	_subtitle.autoresizingMask = kFullAutoresizingMask;
	_subtitle.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
	_subtitle.textColor = [UIColor whiteColor];
	_subtitle.font = [UIFont fontWithName:PDGlobalBoldFontName size:19];
	_subtitle.textAlignment = NSTextAlignmentCenter;
	[self addSubview:_subtitle];
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
