//
//  PDLogoProgressView.m
//
//  Created by LTT on 7/18/14.
//  Copyright (c) 2014 LTT. All rights reserved.
//

#import "PDLogoProgressView.h"

@implementation PDLogoProgressView
- (void)awakeFromNib
{
    [self initProgressView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProgressView];
    }
    return self;
}

- (void)initProgressView
{
    self.activitiesIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.activitiesIndicatorView];
    self.arrayImage = @[@"pashadelic_progress1",
                        @"pashadelic_progress2",
                        @"pashadelic_progress3",
                        @"pashadelic_progress4",
                        @"pashadelic_progress5",
                        @"pashadelic_progress6"];
}

- (void)setProgress:(CGFloat)progress
{
    int number = ceil(progress * _arrayImage.count);
    NSString *baseString = @"pashadelic_progress";
    NSString *imageName = [NSString stringWithFormat:@"%@%d", baseString, number];
    self.activitiesIndicatorView.image = [UIImage imageNamed:imageName];
}

- (void)setTypeActivityIndicator
{
    self.activitiesIndicatorView.image = [UIImage imageNamed:@"icon_loading_background"];
    self.indicatorImageView = [[UIImageView alloc] initWithFrame:self.activitiesIndicatorView.frame];
    self.indicatorImageView.image = [UIImage imageNamed:@"icon_loading_indicator"];
    [self addSubview: self.indicatorImageView];
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotatingIndicator) userInfo:nil repeats:YES];
}

- (void)rotatingIndicator
{
    CGAffineTransform transform = self.indicatorImageView.transform;
    self.indicatorImageView.transform = CGAffineTransformMakeRotation(atan2(transform.b, transform.a) + 0.1);
}
@end
