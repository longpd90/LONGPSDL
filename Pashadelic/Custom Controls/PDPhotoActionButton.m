//
//  PDPhotoActionButton.m
//  ;
//
//  Created by Vitaliy Gozhenko on 14.02.13.
//
//

#import "PDPhotoActionButton.h"

@implementation PDPhotoActionButton

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
	self.showsTouchWhenHighlighted = YES;
	self.layer.cornerRadius = 3;
	self.layer.masksToBounds = YES;
	self.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 10, 0);
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
	self.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:14];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[_subtitleLabel clearBackgroundColor];
	_subtitleLabel.font = self.titleLabel.font;
	_subtitleLabel.textAlignment = NSTextAlignmentCenter;
	_subtitleLabel.textColor = [self titleColorForState:UIControlStateNormal];
	[self addSubview:_subtitleLabel];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	_subtitleLabel.frame = CGRectMake(0, self.height / 1.6, self.width, 20);
}

@end
