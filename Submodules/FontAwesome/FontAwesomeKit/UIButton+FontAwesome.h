//
//  UIButton+FontAwesome.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 26.02.14.
//
//

#import <UIKit/UIKit.h>
#import "FAKFontAwesome.h"

@interface UIButton (FontAwesome)

- (void)setFontAwesomeIconForImage:(FAKIcon *)icon forState:(UIControlState)state attributes:(NSDictionary *)attributes;
- (void)setFontAwesomeIconForBackgroundImage:(FAKIcon *)icon forState:(UIControlState)state attributes:(NSDictionary *)attributes;
- (void)setFontAwesomeIconForTitle:(FAKIcon *)icon forState:(UIControlState)state;

@end
