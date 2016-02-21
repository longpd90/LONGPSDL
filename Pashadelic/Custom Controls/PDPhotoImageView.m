//
//  PDPhotoFullScreenView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 21/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoImageView.h"

@interface PDPhotoImageView ()

@end

@implementation PDPhotoImageView

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
	[self layoutIfNeeded];
	self.clipsToBounds = YES;
	self.layer.masksToBounds = YES;
}

- (void)setPhoto:(PDPhoto *)photo
{
	_photo = photo;
	[self resizeToFitWithImageSize:CGSizeMake(photo.photoWidth, photo.photoHeight)
					   maxViewSize:CGSizeMake(self.superview.width - self.x * 2, MAXFLOAT)];
	[self setNeedsLayout];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchedImageView)]) {
        [self.delegate didTouchedImageView];
    }
}

@end
