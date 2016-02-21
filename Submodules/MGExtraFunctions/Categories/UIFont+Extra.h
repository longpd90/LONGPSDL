//
//  UIFont+Extra.h
//  FacebookCover
//
//  Created by Vitaliy Gozhenko on 10/20/14.
//  Copyright (c) 2014 Logiexcel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Extra)

- (BOOL)isBold;
- (BOOL)isItalic;

- (UIFont *)boldFont;
- (UIFont *)italicFont;
- (UIFont *)normalFont;

@end
