//
//  PDRatingView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 16.06.13.
//
//

#import "PDRatingView.h"

@implementation PDRatingView

- (void)awakeFromNib
{
	int width = self.height, padding = (self.width - width * 5) / 4, x = 0;
	for (int i = 0; i < 5; i++) {
		UIImageView *star = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, width)];
		star.image = [UIImage imageNamed:@"icon_star.png"];
		star.highlightedImage = [UIImage imageNamed:@"icon_star_yellow.png"];
		star.tag = i + 1;
		[self addSubview:star];
		x += width + padding;
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setRating:(NSInteger)rating
{
	for (NSInteger i = 1; i <= 5; i++) {
		UIImageView *imageView = (UIImageView *) [self viewWithTag:i];
		imageView.highlighted = (i <= rating);
	}

}
@end
