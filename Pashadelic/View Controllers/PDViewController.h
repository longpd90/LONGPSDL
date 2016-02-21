//
//  PDViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extra.h"
#import "AdditionalFunctions.h"
#import "UINavigationController+Extra.h"
#import "Globals.h"
#import <QuartzCore/QuartzCore.h>
#import "UIMenuView.h"
#import "PDServerExchange.h"
#import "MGViewController.h"
#import "PDGoogleAnalytics.h"
#import "UIButton+Extra.h"
#import "UIImageView+Extra.h"
#import "PDTextField.h"
#import "IIViewDeckController.h"
#import "MGGradientView.h"
#import "MGLocalizedButton.h"
#import "MGLocalizedLabel.h"
#import "PDNavigationBar.h"
#import "PDBarButton.h"
#import "PDToolbarButton.h"
#import "PDGlobalFontLabel.h"
#import "PDGlobalFontButton.h"
#import "PDGradientButton.h"
#import "PDUnderlinedTextField.h"
#import "PDLocationHelper.h"

typedef enum {
    kPDLeftBarButtonStyleBlack = 0,
    kPDLeftBarButtonStyleWhite = 1,
    kPDLeftBarButtonStyleWhiteAndBorder = 2,
    kPDLeftBarButtonStyleGrayAngle,
    kPDLeftBarButtonStyleWhiteAngle
} kPDLeftBarButtonStyle;

@class PDUser;
@class PDPhoto;

@interface PDViewController : MGViewController
<UIMenuViewDelegate>
{
	NSString *viewTitle;
    BOOL isLocationReceived;
}

@property (assign, nonatomic, getter = isFullscreenMode) BOOL fullscreenMode;
@property (assign, nonatomic, getter = isLoading) BOOL loading;
@property (assign, nonatomic, getter = isNeedRefreshView) BOOL needRefreshView;
@property (assign, nonatomic) PDNavigationBarStyle navigationBarStyle;
@property (strong, nonatomic) MGRotatingWaitingSpinner *loadingView;
@property (strong, nonatomic) id serverExchange;
@property (strong, nonatomic) UIButton *noInternetButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (strong, nonatomic) UIAlertView *errorAlertView;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipeGesture;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipeGesture;

- (IBAction)showMenu:(id)sender;
- (void)showNoInternetButton; 
- (void)hideNoInternetButton;
- (PDNavigationBarStyle)defaultNavigationBarStyle;
- (PDNavigationBar *)customNavigationBar;
- (void)setLeftBarButtonToBackWithStyle:(kPDLeftBarButtonStyle)style;
- (void)setLeftButtonToMainMenu;
- (PDGradientButton *)grayBarButtonWithTitle:(NSString *)title action:(SEL)action;
- (PDGradientButton *)redBarButtonWithTitle:(NSString *)title action:(SEL)action;
- (void)setRightBarButtonToButton:(UIButton *)button;
- (void)setLeftBarButtonToButton:(UIButton *)button;
- (UIView *)setRightButtonToImage:(UIImage *)image offset:(CGSize)offset withAction:(SEL)action;
- (UIView *)setLeftButtonToImage:(UIImage *)image offset:(CGSize)offset withAction:(SEL)action;
- (PDBarButton *)setLeftBarButtonToImage:(UIImage *)image offset:(CGSize)offset withAction:(SEL)action;
- (PDBarButton *)setRightBarButtonToImage:(UIImage *)image offset:(CGSize)offset withAction:(SEL)action;
- (PDBarButton *)setRightBarButtonToIcon:(FAKIcon *)icon color:(UIColor *)color offset:(CGSize)offset withAction:(SEL)action;

- (void)showHelp;
- (void)showInitialHelp;
- (NSArray *)helpID;
- (NSArray *)helpItems;

- (void)refreshUnreadItemsIcon;
- (void)refreshView;
- (void)refetchData;
- (void)fetchData;
- (IBAction)goBack:(id)sender;
- (UIViewController *)previousViewController;

- (void)showUser:(PDUser *)user;
- (void)showPhoto:(PDPhoto *)photo;
- (void)trackCurrentPage;
- (void)trackEvent:(NSString *)event;
- (void)fullscreenMode:(bool)fullscreenMode animated:(bool)animated;
- (NSString *)pageName;
- (void)showMainMenu;
- (void)presentViewControllerWithName:(NSString *)name withStyle:(UIModalTransitionStyle) style;
- (void)showErrorMessage:(NSString *)message;
- (void)applyShadowAndRoundedCornersToToolbarView;
- (void)releaseMapMemory:(MKMapView *)map;
- (void)swipeLeftGestureHandler;
- (void)swipeRightGestureHandler;
- (NSDate *)currentDate;

- (void)initLocationService;
- (void)updateLocation;
- (void)locationChanged:(NSNotification *)notification;
- (void)updateLocationDidFailWithError:(NSError *)error;
@end
