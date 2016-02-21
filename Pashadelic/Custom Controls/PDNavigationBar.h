//
//  PDNavigationBar.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 29.09.13.
//
//

#import <UIKit/UIKit.h>
#import "PDDynamicFontLabel.h"


typedef enum {
	PDNavigationBarStyleWhite = 0,
	PDNavigationBarStyleBlack,
    PDNavigationBarStyleOrange
} PDNavigationBarStyle;

typedef enum {
    GTScrollNavigationBarNone,
    GTScrollNavigationBarScrollingDown,
    GTScrollNavigationBarScrollingUp
} GTScrollNavigationBarState;

@interface PDNavigationBar : UINavigationBar <UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *linkToTopView;
@property (strong, nonatomic) NSString *tableName;
@property (assign, nonatomic) GTScrollNavigationBarState scrollState;

@property (strong, nonatomic) PDDynamicFontLabel *titleLabel;
@property (strong, nonatomic) UIButton *titleButton;
@property (nonatomic, assign) PDNavigationBarStyle customBarStyle;

- (IBAction)titleButtonTouch:(id)sender;
- (void)resetToDefaultPosition:(BOOL)animated;
- (void)showTopButton;
- (void)hideTopButton;
- (BOOL)isShowed;

@end

@interface UINavigationController (GTScrollNavigationBarAdditions)

@property(strong, nonatomic, readonly) PDNavigationBar *scrollNavigationBar;

@end