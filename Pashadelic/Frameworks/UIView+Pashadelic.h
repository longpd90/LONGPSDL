//
//  UIView+Pashadelic.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 28.09.13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Pashadelic)

- (void)setRoundedCornersWithShadowStyle;
- (void)applyGlobalFont;
- (void)applyGlobalStyleToAllSubviews;

@end

@interface UIButton (Pashadelic)

- (void)applyRedStyleToButton;
- (void)applyBlueStyleToButton;

@end