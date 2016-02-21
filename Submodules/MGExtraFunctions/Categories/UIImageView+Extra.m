//
//  UIImageView+Extra.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+Extra.h"

@implementation UIImageView (Extra)

- (void)setImage:(UIImage *)image animated:(BOOL)animated
{
	if ([image isEqual:self.image]) return;
	
	if (animated) {
		self.alpha = 0;
		self.image = image;
		[UIView animateWithDuration:0.5 animations:^{
			self.alpha = 1;
		}];
	} else {
		self.image = image;
	}
}

- (void)resizeToFitWithImageSize:(CGSize)imageSize maxViewSize:(CGSize)maxSize
{
	CGSize size = [UIImageView sizeThatFitImageSize:imageSize maxViewSize:maxSize];
	
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}


+ (CGSize)sizeThatFitImageSize:(CGSize)imageSize maxViewSize:(CGSize)maxSize
{
	if (imageSize.width <= maxSize.width && imageSize.height <= imageSize.height) return imageSize;
	double widthProportion = imageSize.width / maxSize.width;
	double heightProportion = imageSize.height / maxSize.height;
	double proportion;
	if (widthProportion <= heightProportion) {
		proportion = imageSize.height / maxSize.height;
	} else {
		proportion = imageSize.width / maxSize.width;
	}
	double width = round(imageSize.width / proportion);
	double height = round(imageSize.height / proportion);
	
	return CGSizeMake(width, height);
}

@end
