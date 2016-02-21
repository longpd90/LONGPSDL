//
//  PDUserProfileViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDUserProfile.h"
#import "PDViewController.h"
#import "PDServerLogout.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "PDFacebookExchange.h"
#import "PDProfileNotificationsViewController.h"
#import "PDDeleteAccountAlertView.h"

@interface PDProfileSettingsViewController : PDViewController
<MGServerExchangeDelegate, UITableViewDataSource, UITableViewDelegate,
MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, PDFacebookExchangeDelegate, PDAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailsTable;
@property (weak, nonatomic) PDUserProfile *profile;
@property (strong, nonatomic) IBOutlet PDGradientButton *facebookButton;
@property (strong, nonatomic) PDFacebookExchange *facebookExchange;
@property (strong, nonatomic) PDProfileNotificationsViewController *profileNotificationsViewController;

- (IBAction)logoutButtonTouch:(id)sender;
- (IBAction)editProfile:(id)sender;
- (IBAction)toggleFacebook:(id)sender;
- (void)changePassword;
- (void)inviteFacebookFriends;

@end
