//
//  UIMenuView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdditionalFunctions.h"
#import "UIView+Extra.h"

@class UIMenuView;
@class PDTableViewController;

@protocol UIMenuViewDelegate  <NSObject>
@optional
- (void)menuViewDidFinish:(UIMenuView *)menuView;
- (void)menuViewDidCancel:(UIMenuView *)menuView;
- (void)showHelp;
@end

@interface UIMenuView : UIView

@property (weak, nonatomic) PDTableViewController *parentViewController;
@property (strong, nonatomic) UIView *backgroundMenuView;
@property (weak, nonatomic) id <UIMenuViewDelegate> delegate;
@property (nonatomic) BOOL needRefetchData;
@property (nonatomic) BOOL needFetchData;
@property (nonatomic) BOOL needRefreshSuperview;

- (void)showMenuInViewController:(UIViewController *)viewController;
- (void)hideMenu;
- (IBAction)finish:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)showHelp:(id)sender;
- (void)initialize;

@end

