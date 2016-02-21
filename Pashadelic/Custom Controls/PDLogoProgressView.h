//
//  PDLogoProgressView.h
//
//  Created by LTT on 7/18/14.
//  Copyright (c) 2014 LTT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLogoProgressView : UIView

@property (strong, nonatomic) UIImageView *activitiesIndicatorView;
@property (strong, nonatomic) NSArray *arrayImage;
@property (strong, nonatomic) UIImageView *indicatorImageView;
@property (nonatomic) CGFloat progress;
- (void)setTypeActivityIndicator;
@end
