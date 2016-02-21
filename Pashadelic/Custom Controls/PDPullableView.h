//
//  PDPullableView.h
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMapToolBarView.h"
enum
{
    PDPhotoToolsViewModeSpots = 1,
    PDPhotoToolsViewModeSunMoon,
    PDPhotoToolsViewModeDateTime
};

@class PDPullableView;
/**
 Protocol for objects that wish to be notified when the state of a
 PullableView changes
 */
@protocol PDPullableViewDelegate <NSObject>

/**
 Notifies of a changed state
 @param pView PullableView whose state was changed
 @param opened The new state of the view
 */
@optional
- (void)pullableView:(PDPullableView *)pullableView didChangeState:(BOOL)opened;
@end

@interface PDPullableView : UIView {
    CGPoint closedCenter;
    CGPoint openedCenter;
    
    PDMapToolBarView *mapToolBarView;
    UIPanGestureRecognizer *dragRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
    
    BOOL opened;
    BOOL verticalAxis;
    
    BOOL toggleOnTap;
    
    BOOL animate;
    float animationDuration;
}

@property (nonatomic, readonly) PDMapToolBarView *mapToolBarView;
@property (nonatomic, strong) UIView *contentView;
@property (readwrite, assign) CGPoint closedCenter;
@property (readwrite, assign) CGPoint openedCenter;
@property (nonatomic, readonly) UIPanGestureRecognizer *dragRecognizer;
@property (nonatomic, readonly) UITapGestureRecognizer *tapRecognizer;
@property (readwrite, assign) BOOL toggleOnTap;
@property (readwrite, assign) BOOL animate;
@property (readwrite, assign) float animationDuration;
@property (nonatomic, weak) id <PDPullableViewDelegate> delegate;
- (void)setOpened:(BOOL)isOpen animated:(BOOL)isAnimated;
- (void)changeContentSize;
- (void)finish;
- (BOOL)isOpened;
@end
