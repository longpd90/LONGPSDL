//
//  PDMeViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 8/11/12.
//
//

#import "PDUsersTableView.h"
#import "PDPhotosTableView.h"
#import "PDUserProfile.h"
#import "PDServerProfilePhotosLoader.h"
#import "PDServerGetMyPins.h"
#import "PDServerProfileUsersLoader.h"
#import "PDUserViewController.h"
#import "PDProfileSettingsViewController.h"
#import "PDUserViewController.h"
#import "PDPhotoTableViewController.h"
#import "PDToolbarGradientButton.h"

@interface PDMeViewController : PDPhotoTableViewController
<MGServerExchangeDelegate, PDItemSelectDelegate, PDItemsTableDelegate>

@property (nonatomic, assign) NSUInteger myFeedViewSource;
@property (strong, nonatomic) PDUserProfile *profile;
@property (strong, nonatomic) NSMutableArray *photoNoSpotIDs;
@property (weak, nonatomic) IBOutlet PDToolbarGradientButton *sourceFollowersButton;
@property (weak, nonatomic) IBOutlet PDToolbarGradientButton *sourcePinsButton;
@property (weak, nonatomic) IBOutlet PDToolbarGradientButton *sourcePhotosButton;
@property (weak, nonatomic) IBOutlet PDToolbarGradientButton *sourceFollowingsButton;
@property (strong, nonatomic) PDUsersTableView *usersTableView;
@property (strong, nonatomic) PDUserViewController *userViewController;
@property (strong, nonatomic) PDProfileSettingsViewController *profileSettingsViewController;
@property (strong, nonatomic) PDPhotoUserTableView *photoUsersTableView;
@property (assign, nonatomic) int turnCheckSpotID;
@property (nonatomic) BOOL isLeftButtonToBack;
- (IBAction)changeSource:(id)sender;
- (void)refreshSourceButtons;
- (void)userChangedNotification:(NSNotification *)notification;

@end
