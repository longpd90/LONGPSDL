//
//  PDProfileChangePasswordViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 10.12.12.
//
//

#import "PDProfileChangePasswordViewController.h"

@interface PDProfileChangePasswordViewController ()
- (BOOL)validateData;
@end

enum PasswordRows {
	kCurrentPassword = 0,
	kNewPassword,
	kConfirmPassword,
//	kForgotPassord,
	kPasswordRowsCount
};

@implementation PDProfileChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Change password", nil);
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	self.contentScrollView = _tableView;
	[_saveButton setRedGradientButtonStyle];
    [_saveButton.titleLabel setFont:[UIFont fontWithName:PDGlobalBoldFontName size:20]];
	[_saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
	_tableView.tableFooterView = _footerView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[self setFooterView:nil];
	[self setSaveButton:nil];
	[self setTableView:nil];
	[self setConfirmPasswordTextField:nil];
	[self setSomeNewPasswordTextField:nil];
	[self setOldPasswordTextField:nil];
	[super viewDidUnload];
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Change password";
}

- (BOOL)validateData
{
	if (_oldPasswordTextField.text.length < 6) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Password must be at least 6 characters long", nil)];
		return NO;
	}
	
	
	if (![_someNewPasswordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Passwords don't match", nil)];
		return NO;
	}
	
	if (_someNewPasswordTextField.text.length == 0 || _confirmPasswordTextField.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter new password", nil)];
		return NO;
	}
	
	return YES;
}

- (IBAction)save:(id)sender
{
	if (![self validateData]) return;
	
	[_confirmPasswordTextField resignFirstResponder];
	
	[kPDAppDelegate showWaitingSpinner];
	self.serverExchange = [[PDServerChangePassword alloc] initWithDelegate:self];
	[self.serverExchange changePassword:_oldPasswordTextField.text newPassword:_someNewPasswordTextField.text];
}

- (void)forgotPassword
{
	[kPDAppDelegate showWaitingSpinner];
	self.serverExchange = [[PDServerForgotPassword alloc] initWithDelegate:self];
	[self.serverExchange forgotPassword];
}


#pragma mark - Table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return kPasswordRowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ProfileCellIdentifier = @"PDPasswordCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ProfileCellIdentifier];
	}
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryView = nil;
	cell.textLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:17];
	
	if (indexPath.row == kCurrentPassword) {
		cell.textLabel.text = NSLocalizedString(@"Current Password", nil);
		cell.accessoryView = _oldPasswordTextField;
		
	} else if (indexPath.row == kNewPassword) {
		cell.textLabel.text = NSLocalizedString(@"New Password", nil);
		cell.accessoryView = _someNewPasswordTextField;
		
	} else if (indexPath.row == kConfirmPassword) {
		cell.textLabel.text = NSLocalizedString(@"Confirm Password", nil);
		cell.accessoryView = _confirmPasswordTextField;
	}
		
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	
	if ([textField isEqual:_oldPasswordTextField]) {
		[textField resignFirstResponder];
		[_someNewPasswordTextField becomeFirstResponder];
		
	} else if ([textField isEqual:_someNewPasswordTextField]) {
		[textField resignFirstResponder];
		[_confirmPasswordTextField becomeFirstResponder];
		
	} else if ([textField isEqual:_confirmPasswordTextField]) {
		[self save:nil];
	}
	
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	if ([serverExchange isKindOfClass:[PDServerChangePassword class]]) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Password was changed", nil)];
		[self.navigationController popViewControllerAnimated:YES];
		
	} else if ([serverExchange isKindOfClass:[PDServerForgotPassword class]]) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"E-mail with password was successfully sent", nil)];
		[self.navigationController popViewControllerAnimated:YES];
	}

}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	[self showErrorMessage:error];	
}

@end
