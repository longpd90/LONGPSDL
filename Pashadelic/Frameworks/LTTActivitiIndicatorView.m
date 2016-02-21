//
//  LTTActivitiIndicatorView.m
//
//  Created by Nguyễn Hữu Anh on 5/16/14.
//  Copyright (c) 2014 Pashadelic. All rights reserved.
//

#import "LTTActivitiIndicatorView.h"

@implementation LTTActivitiIndicatorView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *statusImage = [UIImage imageNamed:@"indicator_status1.png"];
        _activityImageView = [[UIImageView alloc]
                              initWithImage:statusImage];
        _activityImageView.animationImages = [NSArray arrayWithObjects:
                                              [UIImage imageNamed:@"indicator_status1.png"],
                                              [UIImage imageNamed:@"indicator_status2.png"],
                                              [UIImage imageNamed:@"indicator_status3.png"],
                                              [UIImage imageNamed:@"indicator_status4.png"],
                                              [UIImage imageNamed:@"indicator_status5.png"],
                                              [UIImage imageNamed:@"indicator_status6.png"],
                                              [UIImage imageNamed:@"indicator_status7.png"],
                                              [UIImage imageNamed:@"indicator_status8.png"],
                                              nil];
        _activityImageView.animationDuration = 1;
        _activityImageView.frame = CGRectMake( 0, 0, self.frame.size.width, self.frame.size.height);
        _activityImageView.center = self.center;
        [_activityImageView startAnimating];
        [self addSubview:_activityImageView];
    }
    return self;
}

@end
