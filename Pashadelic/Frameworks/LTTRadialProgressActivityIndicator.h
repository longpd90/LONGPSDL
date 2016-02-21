//
//  LTTRadialProgressActivityIndicator.h
//
//  Created by Nguyễn Hữu Anh on 5/16/14.
//  Copyright (c) 2014 Pashadelic. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^actionHandler)(void);
typedef NS_ENUM(NSUInteger, LTTPullToRefreshState) {
    LTTPullToRefreshStateNone =0,
    LTTPullToRefreshStateStopped,
    LTTPullToRefreshStateTriggering,
    LTTPullToRefreshStateTriggered,
    LTTPullToRefreshStateLoading,
    
};

@interface LTTRadialProgressActivityIndicator : UIView
@property (nonatomic,assign) BOOL isObserving;
@property (nonatomic,assign) CGFloat originalTopInset;
@property (nonatomic,assign) LTTPullToRefreshState state;
@property (nonatomic,weak) UIScrollView *scrollView;
@property (nonatomic,copy) actionHandler pullToRefreshHandler;
@property (nonatomic, assign) double progress;
@property (nonatomic,strong) UIImage *imageIcon;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,assign) CGFloat borderWidth;

- (id)initWithImage:(UIImage *)image;
- (void)setSize:(CGSize) size;
@end
