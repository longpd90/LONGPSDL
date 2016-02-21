//
//  PDButtonMapTools.h
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/17/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPDButtonMapToolActivedNotification  @"kPDButtonMapToolsActivedNotification"
enum
{
    PDButtonMapToolsStateOff = 0,
    PDButtonMapToolsStateOn,
    PDButtonMapToolsStateActive
};

typedef NSInteger PDButtonMapToolsStyle;
    
@interface PDButtonMapTools : UIButton
@property (nonatomic, assign) NSInteger currentState;

- (void)swicthState;
- (void)swicthState:(NSInteger)state;
- (void)layoutForImage:(UIImage *)image inView:(UIView *)view;
@end
