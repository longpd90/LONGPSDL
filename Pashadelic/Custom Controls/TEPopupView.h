//
// TEPopupView.h
//
// Created by Tuấn Nguyễn Anh on 6/3/13.
// Copyright (c) 2013 Tuấn Nguyễn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class TouchView;
@class TEPopupView;

@protocol PopupMenuDelegate <NSObject>
- (void)miniSliderChange:(float)value;
@end

@interface TEPopupView : UIView
{
    float originalValue;
    float midValue;
    id<PopupMenuDelegate> delegate;
    UISlider *miniSlider;
    UIImageView *triangular;
    CGRect contentRect;
    CGFloat strokeWidth;
    CGFloat cornerRadius;
    id target;
    SEL action;
}
@property (assign) float originalValue;
@property (assign) float midValue;
@property (readwrite, nonatomic) UISlider *miniSlider;
@property (strong, nonatomic) id<PopupMenuDelegate> delegate;
@property (strong, nonatomic) TouchView *touchView;
@property (assign, nonatomic) float spaceToMinislider;
@property (assign, nonatomic) CGRect triangularFrame;
- (IBAction)valueChanged:(UISlider *)sender;
- (void)addSlider;
- (void)setFrameforTriangular:(float) coorX;
- (void)showPopup;
- (void)showPopupView;
- (BOOL)shouldBeDismissedFor:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)dismissModal;
- (void)addTarget:(id)newTarget action:(SEL)newAction;
@end