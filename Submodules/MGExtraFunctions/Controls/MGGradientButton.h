//
//  MGGradientButton.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.01.13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MGGradientButton : UIButton

@property (strong, nonatomic) NSMutableDictionary *gradientColors;
@property (strong, nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) CALayer *highlightLayer;

- (void)setGradientFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor forState:(UIControlState)state;

@end
