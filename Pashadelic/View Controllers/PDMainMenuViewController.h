//
//  PDMainMenuViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 04.04.13.
//
//

#import "PDViewController.h"
#import "PDMainMenuItem.h"
#import "PDUserProfile.h"
#import "NIBadgeView.h"
#import "PDNavigationController.h"

@interface PDMainMenuViewController : PDViewController

@property (weak, nonatomic) IBOutlet MGGradientView *shadowView;
@property (weak, nonatomic) IBOutlet UIButton *userInfoButton;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *notificationsButton;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *popularButton;
@property (weak, nonatomic) IBOutlet UIButton *photoToolButton;
@property (weak, nonatomic) IBOutlet UIButton *plansButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationsBadgeView;
@property (weak, nonatomic) IBOutlet UILabel *plansBadgeView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *aRButton;
@property (weak, nonatomic) IBOutlet UIView *menuContentView;
@property (strong, nonatomic) UIImageView *blurView;

@property (strong, nonatomic) PDNavigationController *meViewController;
@property (strong, nonatomic) PDNavigationController *cameraViewController;
@property (strong, nonatomic) PDNavigationController *homeViewController;
@property (strong, nonatomic) PDNavigationController *searchViewController;
@property (strong, nonatomic) PDNavigationController *photoToolViewController;
@property (strong, nonatomic) PDNavigationController *aRViewController;
@property (strong, nonatomic) PDNavigationController *plansViewController;
@property (strong, nonatomic) PDNavigationController *popularViewController;
@property (strong, nonatomic) PDNavigationController *notificationsViewController;
@property (strong, nonatomic) PDNavigationController *settingsViewController;
@property (strong, nonatomic) PDNavigationController *upcomingPlanViewController;
- (IBAction)showUserInfo:(id)sender;
- (IBAction)showPhotoTool:(id)sender;
- (IBAction)showPlans:(id)sender;
- (IBAction)showHome:(id)sender;
- (IBAction)showCamera:(id)sender;
- (IBAction)showNotifications:(id)sender;
- (IBAction)showSearch:(id)sender;
- (IBAction)showPopular:(id)sender;
- (IBAction)showAR:(id)sender;
- (IBAction)showSettings:(id)sender;
- (IBAction)hideMenu:(id)sender;

@end
