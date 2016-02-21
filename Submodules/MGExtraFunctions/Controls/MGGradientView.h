//
//  MGGradientView.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 28.02.13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MGGradientView : UIView
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

- (void)setGradientFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor;

@end
