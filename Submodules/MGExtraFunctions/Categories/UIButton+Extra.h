//
//  UIButton+Extra.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extra)

@property (nonatomic, setter = setTitle:, getter = title) NSString *title;
- (NSString *)title;
- (void)setTitle:(NSString *)title;

+ (UIButton *)buttonWithImage:(UIImage *)image;
+ (UIButton *)buttonWithTitle:(NSString *)title font:(UIFont *)font height:(int)height;
- (void)setImage:(UIImage *)image forState:(UIControlState)state animated:(BOOL)animated;
- (void)setBackgroundImageForSelectedState:(UIImage *)image;
- (void)setImageForSelectedState:(UIImage *)image;
- (void)setTitleForSelectedState:(NSString *)title;
- (void)setTitleColorForSelectedState:(UIColor *)color;

@end
