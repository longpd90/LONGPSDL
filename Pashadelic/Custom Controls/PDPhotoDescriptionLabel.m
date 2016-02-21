//
//  PDPhotoDesctiptionLabel.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 15.02.13.
//
//

#import "PDPhotoDescriptionLabel.h"

@implementation PDPhotoDescriptionLabel

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	return [super textRectForBounds:CGRectInset(bounds, 4, 4) limitedToNumberOfLines:numberOfLines];
}

- (void)drawTextInRect:(CGRect)rect
{
	[super drawTextInRect:CGRectInset(rect, 4, 4)];
}

@end
