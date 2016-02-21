//
//  PDAppDelegate.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGAppDelegate.h"
#import "PDUnreadItemsManager.h"
#import "PDHelpView.h"
#import "PDUploadPhotoView.h"
#import "Mixpanel.h"
#import "PDSingleErrorAlertView.h"
#import "PDDeckViewController.h"

@protocol MGServerExchangeDelegate;
@class PDUserProfile;
@class PDServerLoadNotReadFeedItems;
@class IIViewDeckController;
@class PDMainMenuViewController;


@interface PDAppDelegate : MGAppDelegate
<UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) PDMainMenuViewController *mainMenuViewController;
@property (strong, nonatomic) NSDictionary *helpItems;
@property (strong, nonatomic) NSMutableArray *shownHelpItems;
@property (strong, nonatomic) PDUploadPhotoView *uploadPhotoView;
@property (strong, nonatomic) PDHelpView *helpView;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PDDeckViewController *viewDeckController;
@property (strong, nonatomic) PDUserProfile *userProfile;
@property (strong, nonatomic) NSURL *userAvatarURL;
@property (assign, nonatomic, getter = isUserLoggedIn) BOOL userLoggedIn;
@property BOOL isUnreadItemsLoaded;

- (void)registerDefaults;
- (void)login;
- (void)sendDeactiveAccountFeedbackWithBody:(NSString *)body;
- (void)updateLocationDidFailWithError:(NSError *)error;
@end
