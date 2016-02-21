//
//  PDUserProfileViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDProfileSettingsViewController.h"
#import "PDSearchUsersViewController.h"
#import "PDProfileEditViewController.h"
#import "PDServerFacebookShareStatus.h"
#import "PDServerFacebookShareState.h"
#import "PDServerDeleteAccount.h"
#import "PDDeleteDeviceToken.h"
#import "PDFeedbackAlertView.h"

enum Sections {
	kEditSection = 0,
	kSocialSection,
	kOthersSection,
	kSectionsCount
};

enum EditRows {
	kEditProfileRow = 0,
	kChangePasswordRow,
	kNotificationSettingsRow,
	kForgotPasswordRow,
	kLogoutRow,
	kEditRowsCount
};

enum SocialRows {
  //	kFacebookRow = 0,
  //	kTwitterRow,
  //	kInviteFacebookFriendsRow,
	kSearchUsersRow,
	kSocialRowsCount
};

enum OtherRows {
	kAboutPashadelicRow = 0,
  //	kRateUsRow,
	kFeedbackRow,
	kClearCacheRow,
  kDeleteAccount,
	kOtherRowsCount
};

enum AlertViewTag {
	kAlertViewDelete = 0,
	kAlertViewSubmit
};

enum AlertViewDeleteButton {
	kCanCelButton = 0,
	kDeleteButton
};

enum AlertViewSubmitButton {
	kSubmitButton = 0,
	kSkipButton
};

@interface PDProfileSettingsViewController () <MGServerExchangeDelegate>
@property (strong, nonatomic) PDDeleteDeviceToken *urbanAirshipExchange;
- (void)inviteFacebookFriends;
- (void)showAboutInfo;
- (void)provideFeedback;
- (void)changeNotificationSettings;
- (void)clearCache;
- (void)resetPassword;
- (void)deactiveUrbanDeviceToken:(NSString *)deviceToken;
- (void)deleteAccount;
@end

@implementation PDProfileSettingsViewController
@synthesize detailsTable, profile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	self.title = NSLocalizedString(@"My Settings", nil);
	[self setLeftButtonToMainMenu];
	
	[_facebookButton setGrayGradientButtonStyle];
	[_facebookButton setTitle:NSLocalizedString(@"Enable", nil) forState:UIControlStateNormal];
	[_facebookButton setTitle:NSLocalizedString(@"Enabled", nil) forState:UIControlStateSelected];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:kPDSuccessLoggedInNotification object:nil];
}

- (void)viewDidUnload
{
  [self setDetailsTable:nil];
	[self setFacebookButton:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self refreshView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private

- (void)clearCache
{
	[kPDAppDelegate showWaitingSpinner];
	[[SDImageCache sharedImageCache] clearMemory];
	[[SDImageCache sharedImageCache] clearDisk];
	[kPDAppDelegate hideWaitingSpinner];
}


#pragma mark - Public

- (void)fetchData
{
	_facebookButton.hidden = YES;
	[self refreshView];
	self.serverExchange = [[PDServerFacebookShareStatus alloc] initWithDelegate:self];
	[self.serverExchange getFacebookShareStatus];
}

- (void)inviteFacebookFriends
{
	[self.navigationController pushViewControllerWithName:@"PDInviteFriendsViewController" animated:YES];
}

- (void)changePassword
{
	[self.navigationController pushViewControllerWithName:@"PDProfileChangePasswordViewController" animated:YES];
}

- (NSString *)pageName
{
	return @"My Settings";
}

- (void)refreshView
{
	self.profile = kPDAppDelegate.userProfile;
	[detailsTable reloadData];
}

- (IBAction)logoutButtonTouch:(id)sender
{
	[kPDAppDelegate showWaitingSpinner];
	PDServerLogout *serverLogout = [[PDServerLogout alloc] initWithDelegate:self];
	[serverLogout logout];
}

- (IBAction)editProfile:(id)sender
{
	PDProfileEditViewController *editViewController = [[PDProfileEditViewController alloc] initWithNibName:@"PDProfileEditViewController" bundle:nil];
	editViewController.profile = profile;
	[self.navigationController pushViewController:editViewController animated:YES];
}

- (IBAction)toggleFacebook:(id)sender
{
	_facebookButton.hidden = YES;
	[self refreshView];
	
	self.facebookExchange = [[PDFacebookExchange alloc] initWithDelegate:self];
	[self.facebookExchange loginForPublish];
}

- (void)showAboutInfo
{
	[self.navigationController pushViewControllerWithName:@"PDAboutViewController" animated:YES];
}

- (void)provideFeedback
{
	if (![MFMailComposeViewController canSendMail]) {
        [self showErrorMessage:NSLocalizedString(@"You will need to setup a mail account on your device before you can send mail!", nil)];
        return;
    }
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    mailController.delegate = self;
    mailController.mailComposeDelegate = self;
    mailController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [mailController setSubject:[NSString stringWithFormat:@"iPhone-Feedback ver %@", version]];
    [mailController setMessageBody:[NSString stringWithFormat:@"\n\nPashadelic version: %@", version] isHTML:NO];
    [mailController setToRecipients:[NSArray arrayWithObject:@"voice@pashadelic.com"]];
    [self.navigationController presentViewController:mailController animated:NO completion:nil];
}

- (void)deleteAccount
{
    PDDeleteAccountAlertView *alertDeleteAccountView = [[PDDeleteAccountAlertView alloc] init];
    alertDeleteAccountView.delegate = self;
    [alertDeleteAccountView show];
}

- (void)refetchData
{
}


#pragma mark - Private

- (void)resetPassword
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/users/password/new", kPDAppWebPage]]];
}

- (void)changeNotificationSettings
{
	if (!_profileNotificationsViewController) {
		_profileNotificationsViewController = [[PDProfileNotificationsViewController alloc] initWithNibName:@"PDProfileNotificationsViewController" bundle:nil];
	}
	[self.navigationController pushViewController:_profileNotificationsViewController animated:YES];
	[_profileNotificationsViewController fetchData];
}

- (void)deactiveUrbanDeviceToken:(NSString *)deviceToken
{
  if (!self.urbanAirshipExchange) {
    self.urbanAirshipExchange = [[PDDeleteDeviceToken alloc] initWithDelegate:self];
  }
  [self.urbanAirshipExchange deactiveDeviceToken:deviceToken];
}

#pragma mark - Table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return kSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == kEditSection) {
		return kEditRowsCount;
	} else if (section == kSocialSection) {
		return kSocialRowsCount;
	} else if (section == kOthersSection) {
		return kOtherRowsCount;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ProfileCellIdentifier = @"PDSettingsCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ProfileCellIdentifier];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	cell.accessoryView = nil;
	cell.detailTextLabel.text = @"";
	cell.textLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:17];
	
	if (indexPath.section == kEditSection && indexPath.row == kEditProfileRow) {
		cell.textLabel.text = NSLocalizedString(@"Edit personal information", nil);
		
	} else if (indexPath.section == kEditSection && indexPath.row == kChangePasswordRow) {
		cell.textLabel.text = NSLocalizedString(@"Change password", nil);
		
	} else if (indexPath.section == kEditSection && indexPath.row == kNotificationSettingsRow) {
		cell.textLabel.text = NSLocalizedString(@"Notification settings", nil);
		
	} else if (indexPath.section == kEditSection && indexPath.row == kForgotPasswordRow) {
		cell.textLabel.text = NSLocalizedString(@"Forgot password", nil);
		
	} else if (indexPath.section == kEditSection && indexPath.row == kLogoutRow) {
		cell.textLabel.text = NSLocalizedString(@"Logout", nil);
    
	} else if (indexPath.section == kSocialSection && indexPath.row == kSearchUsersRow) {
		cell.textLabel.text = NSLocalizedString(@"Search users", nil);
    
	} else if (indexPath.section == kOthersSection && indexPath.row == kAboutPashadelicRow) {
		cell.textLabel.text = NSLocalizedString(@"About Pashadelic", nil);
    
	} else if (indexPath.section == kOthersSection && indexPath.row == kFeedbackRow) {
		cell.textLabel.text = NSLocalizedString(@"Provide feedback", nil);
		
	} else if (indexPath.section == kOthersSection && indexPath.row == kClearCacheRow) {
		cell.textLabel.text = NSLocalizedString(@"Clear image cache", nil);
	}else if (indexPath.section == kOthersSection && indexPath.row == kDeleteAccount) {
		cell.textLabel.text = NSLocalizedString(@"Delete account", nil);
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == kEditSection && indexPath.row == kEditProfileRow) {
		[self editProfile:nil];
		
	} else if (indexPath.section == kSocialSection && indexPath.row == kSearchUsersRow) {
		[self.navigationController pushViewControllerWithName:@"PDSearchUsersViewController" animated:YES];
		
	} else if (indexPath.section == kEditSection && indexPath.row == kLogoutRow) {
		[self logoutButtonTouch:nil];
		
	} else if (indexPath.section == kEditSection && indexPath.row == kNotificationSettingsRow) {
		[self changeNotificationSettings];
    
	} else if (indexPath.section == kEditSection && indexPath.row == kForgotPasswordRow) {
		[self resetPassword];
		
	} else if (indexPath.section == kOthersSection && indexPath.row == kAboutPashadelicRow) {
		[self showAboutInfo];
		
	} else if (indexPath.section == kOthersSection && indexPath.row == kFeedbackRow) {
		[self provideFeedback];
		
	} else if (indexPath.section == kEditSection && indexPath.row == kChangePasswordRow) {
		[self changePassword];
		
	} else if (indexPath.section == kOthersSection && indexPath.row == kClearCacheRow) {
		[self clearCache];
	} else if (indexPath.section == kOthersSection && indexPath.row == kDeleteAccount) {
		[self deleteAccount];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == kEditSection) {
		return NSLocalizedString(@"Edit my page and profile", nil);
	} else if (section == kSocialSection) {
		return NSLocalizedString(@"Social", nil);
	} else if (section == kOthersSection) {
		return NSLocalizedString(@"Others", nil);
	}
	return nil;
}


#pragma mark - Mail delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	
	if ([serverExchange isKindOfClass:[PDServerLogout class]]) {
    [self deactiveUrbanDeviceToken:kPDDeviceToken];
		[kPDAppDelegate login];
	} else if ([serverExchange isKindOfClass:[PDServerFacebookShareStatus class]]) {
		_facebookButton.hidden = NO;
		_facebookButton.enabled = ![result boolForKey:@"fb_share_availabe"];
		[self refreshView];
		
	} else if ([serverExchange isKindOfClass:[PDServerFacebookShareState class]]) {
		_facebookButton.hidden = NO;
		_facebookButton.enabled = NO;
		[self refreshView];
	} else if ([serverExchange isKindOfClass:[PDServerDeleteAccount class]]) {
    [kPDAppDelegate login];
    PDFeedbackAlertView *feedbackAlertView = [[PDFeedbackAlertView alloc] init];
    feedbackAlertView.delegate = self;
    [feedbackAlertView show];
  }
	
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	if ([serverExchange isKindOfClass:[PDServerFacebookShareStatus class]]) {
		_facebookButton.hidden = YES;
		
	} else if ([serverExchange isKindOfClass:[PDServerFacebookShareState class]]) {
		_facebookButton.hidden = NO;
		[self refreshView];
		
	}  else if ([serverExchange isKindOfClass:[PDServerDeleteAccount class]]) {
		if ([kPDAppDelegate.window viewWithTag:kPDWindowBackgroundViewTag]) {
      [[kPDAppDelegate.window viewWithTag:kPDWindowBackgroundViewTag] removeFromSuperview];
    }
	} else {
		[kPDAppDelegate hideWaitingSpinner];
	}
	
	[self showErrorMessage:error];
}


#pragma mark - Facebook delegate

- (void)facebookDidFail:(PDFacebookExchange *)facebookExchange withError:(NSString *)error
{
	[self showErrorMessage:error];
}

- (void)facebookDidFinish:(PDFacebookExchange *)facebookExchange withResult:(id)result
{
	self.serverExchange = [[PDServerFacebookShareState alloc] initWithDelegate:self];
	[self.serverExchange updateFacebookShareState];
}

#pragma mark - alertview delegate

- (void)alertViewDidFinish:(PDAlertView *)alertView
{
  self.serverExchange = [[PDServerDeleteAccount alloc] initWithDelegate:self];
  [self.serverExchange deleteAccountWithId:kPDAppDelegate.userProfile.identifier];
}

@end
