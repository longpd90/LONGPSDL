//
//  NHADrawMoon.h
//  drawMoon
//
//  Created by Nguyễn Hữu Anh on 8/28/13.
//  Copyright (c) 2013 anhnh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDDrawMoon : UIView

@property (nonatomic) float radius;
@property (nonatomic) float option;
@property (strong, nonatomic) UIColor *drawColor;

- (id)initWithFrame:(CGRect)frame andRadius: (float)radius option: (float)option;
- (void)drawMoon:(float)radius andOption:(float)option color:(UIColor *)color;
@end
