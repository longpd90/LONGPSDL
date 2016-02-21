//
//  UIColor+Extra.h
//  Starlunch
//
//  Created by Vitaliy Gozhenko on 15.09.13.
//  Copyright (c) 2013 Appstructors. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extra)
+ (UIColor *) colorWithInteger:(NSInteger) integer;
+ (UIColor *) colorWithIntRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;
+ (UIColor *) colorFromHexString:(NSString *)hexString;
- (UIColor *) grayscaleColor;
@end