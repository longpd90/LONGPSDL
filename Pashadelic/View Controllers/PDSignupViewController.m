//
//  PDSignupWIthMailViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDSignupViewController.h"
#import "PDServerSignup.h"
#import "PDSplashViewController.h"

@interface PDSignupViewController ()
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (BOOL)validateValues;
- (void)checkUsername;
- (void)checkEmail;
- (void)setTextField:(UITextField *)textField check:(BOOL)check;
- (void)initTextFields;
@end

@implementation PDSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.termsButton.bottomYPoint);
	
    [self.signupWithEmailButton applyRedStyleToButton];
    [self.signupWithFacebookButton  applyBlueStyleToButton];
	[self.backButton setFontAwesomeIconForImage:[FAKFontAwesome arrowLeftIconWithSize:24]
                                       forState:UIControlStateNormal
                                     attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	
    self.termsButton.titleLabel.numberOfLines = 0;
    self.termsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.termsButton setTitle:NSLocalizedString(@"Your email address and phone number will always remain private. By clicking Sign up you are agreeing that you have read and agreed the terms of service", nil) forState:UIControlStateNormal];
    [self initTextFields];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}


#pragma mark - Private

- (void)confirmTextFields:(UITextField *)textField confirmedTextField:(UITextField *)confirmTextField
{
	if (confirmTextField.text.length == 0 && textField.text.length == 0) {
		confirmTextField.rightView.hidden = YES;
		
	} else if ([confirmTextField.text isEqualToString:textField.text]) {
		confirmTextField.rightView.hidden = NO;
		[self setTextField:confirmTextField check:YES];
		
	} else {
		confirmTextField.rightView.hidden = NO;
		[self setTextField:confirmTextField check:NO];
	}
}

- (BOOL)validateValues
{
    if (self.usernameTextField.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter username", nil)];
		return NO;
	}
    
	if (self.emailTextField.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter email", nil)];
		return NO;
	}
	
	if (self.passwordTextField.text.length < 6) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Password must be at least 6 characters long", nil)];
		return NO;
	}
	
	return YES;
}

- (void)setTextField:(UITextField *)textField check:(BOOL)check
{
    NSUInteger checkImageSize = 20;
	if (!textField.rightView) {
		textField.rightViewMode = UITextFieldViewModeAlways;
		textField.rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, checkImageSize, checkImageSize)];
	}
	
	if (check) {
		[(UIImageView *) textField.rightView setFontAwesomeIconForImage:[FAKFontAwesome checkCircleIconWithSize:checkImageSize]
                                                         withAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	} else {
		[(UIImageView *) textField.rightView setFontAwesomeIconForImage:[FAKFontAwesome timesCircleIconWithSize:checkImageSize]
                                                         withAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]}];
	}
}

- (void)initTextFields
{
	self.emailTextField.placeholder = NSLocalizedString(@"email", nil);
	self.usernameTextField.placeholder = NSLocalizedString(@"user id", nil);
	self.passwordTextField.placeholder = NSLocalizedString(@"password", nil);
    
    UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.usernameTextField.height, self.usernameTextField.height)];
    userIcon.layer.cornerRadius = userIcon.height / 2;
    userIcon.layer.borderColor = self.usernameTextField.textColor.CGColor;
    userIcon.layer.borderWidth = 1;
	[userIcon setFontAwesomeIconForImage:[FAKFontAwesome userIconWithSize:round(userIcon.frame.size.height * 0.7)]
                          withAttributes:@{NSForegroundColorAttributeName: self.usernameTextField.textColor}];
    self.usernameTextField.leftView = userIcon;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *emailIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.emailTextField.height, self.emailTextField.height)];
    emailIcon.layer.cornerRadius = emailIcon.height / 2;
    emailIcon.layer.borderColor = self.emailTextField.textColor.CGColor;
    emailIcon.layer.borderWidth = 1;
	[emailIcon setFontAwesomeIconForImage:[FAKFontAwesome envelopeOIconWithSize:round(userIcon.frame.size.height * 0.7)]
                           withAttributes:@{NSForegroundColorAttributeName: self.emailTextField.textColor}];
    self.emailTextField.leftView = emailIcon;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.passwordTextField.height, self.passwordTextField.height)];
    passwordIcon.layer.cornerRadius = passwordIcon.height / 2;
    passwordIcon.layer.borderColor = self.passwordTextField.textColor.CGColor;
    passwordIcon.layer.borderWidth = 1;
	[passwordIcon setFontAwesomeIconForImage:[FAKFontAwesome lockIconWithSize:round(userIcon.frame.size.height * 0.7)]
                              withAttributes:@{NSForegroundColorAttributeName: self.passwordTextField.textColor}];
    self.passwordTextField.leftView = passwordIcon;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
}


#pragma mark - Public

- (void)goBack:(id)sender
{
    if ([self.parentViewController respondsToSelector:@selector(hideChildViewControllerAnimated)]) {
        [self.parentViewController performSelector:@selector(hideChildViewControllerAnimated)];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)scrollToCurrentControl
{
}

- (NSString *)pageName
{
	return @"Signup";
}

- (IBAction)showTermsOfUse:(id)sender
{
	[self presentViewControllerWithName:@"PDTermsOfUseViewController" withStyle:UIModalTransitionStyleFlipHorizontal];
}

- (IBAction)signupWithEmail:(id)sender
{
	if (![self validateValues]) return;
	
	[kPDAppDelegate showWaitingSpinner];
	PDServerSignup *serverSignup = [[PDServerSignup alloc] initWithDelegate:self];
	[serverSignup signupWithUsername:self.usernameTextField.text
                            password:self.passwordTextField.text
                               email:self.emailTextField.text];
	
}

- (IBAction)signupWithFacebook:(id)sender
{
	[kPDAppDelegate showWaitingSpinner];
	self.facebookGetUserInfo = [[PDFacebookGetUserInfo alloc] initWithDelegate:self];
	[self.facebookGetUserInfo getUserInfo];
}


#pragma mark - Text field delegate

- (void)checkUsername
{
	if (self.usernameTextField.text.length > 0) {
		self.usernameTextField.rightView.hidden = NO;
		self.serverExchange = [[PDServerCheckUsername alloc] initWithDelegate:self];
		[self.serverExchange checkUsername:self.usernameTextField.text];
	} else {
		self.usernameTextField.rightView.hidden = YES;
	}
}

- (void)checkEmail
{
	if (self.emailTextField.text.length > 0) {
		self.emailTextField.rightView.hidden = NO;
		self.serverExchange = [[PDServerCheckEmail alloc] initWithDelegate:self];
		[self.serverExchange checkEmail:self.emailTextField.text];
	} else {
		self.emailTextField.rightView.hidden = YES;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField isEqual:self.emailTextField]) {
		[self.passwordTextField becomeFirstResponder];
		return YES;
        
	} else if ([textField isEqual:self.usernameTextField]) {
		[self.emailTextField becomeFirstResponder];
		return YES;
        
	} else if ([textField isEqual:self.passwordTextField]) {
		[self signupWithEmail:nil];
		return YES;
    }
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if ([textField isEqual:self.emailTextField]) {
		[self checkEmail];
		
	} else if ([textField isEqual:self.usernameTextField]) {
		[self checkUsername];
	}
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	if ([serverExchange isKindOfClass:[PDServerCheckUsername class]]
        || [serverExchange isKindOfClass:[PDServerCheckEmail class]]) return;
	
	[kPDAppDelegate hideWaitingSpinner];
	[self showErrorMessage:error];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if ([serverExchange isKindOfClass:[PDServerSignup class]]
        || [serverExchange isKindOfClass:[PDServerSignupWithFacebook class]]) {
		[kPDAppDelegate hideWaitingSpinner];
        if ([serverExchange isKindOfClass:[PDServerSignup class]]) {
            [self trackEvent:@"Sign-up"];
        } else if ([serverExchange isKindOfClass:[PDServerSignupWithFacebook class]]) {
            [self trackEvent:@"Sign-up FB"];
        }
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Your account was successfully created", nil)];
        [kPDAppDelegate.viewDeckController dismissViewControllerAnimated:NO completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kPDSuccessLoggedInNotification object:self];
        }];
	} else if ([serverExchange isKindOfClass:[PDServerCheckUsername class]] && self.usernameTextField.text.length) {
		NSInteger statusCode = [result intForKey:@"status_code"];
		[self setTextField:self.usernameTextField check:(statusCode == 200)];
		
	} else if ([serverExchange isKindOfClass:[PDServerCheckEmail class]] && self.emailTextField.text.length) {
		NSInteger statusCode = [result intForKey:@"status_code"];
		[self setTextField:self.emailTextField check:(statusCode == 200)];
	}
}


#pragma mark - Facebook delegate

- (void)facebookDidFail:(PDFacebookExchange *)facebookExchange withError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	if ([error isEqualToString:kPDFacebookGetInfoErrorNoInfo]) {
		PDFacebookGetUserInfo *getInfoExchange = (PDFacebookGetUserInfo *) facebookExchange;
		
		self.emailTextField.text = getInfoExchange.email;
		self.usernameTextField.text = getInfoExchange.username;
	} else {
		[self showErrorMessage:error];
	}
}

- (void)facebookDidFinish:(PDFacebookExchange *)facebookExchange withResult:(id)result
{
	self.serverExchange = [[PDServerSignupWithFacebook alloc] initWithDelegate:self];
	[self.serverExchange signupWithFacebook];
}

@end
