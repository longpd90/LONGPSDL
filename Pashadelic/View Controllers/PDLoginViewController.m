//
//  PDLoginViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDLoginViewController.h"
#import "PDServerLogin.h"
#import "PDSignupViewController.h"
#import "PDSplashViewController.h"
#import "UIImage+Extra.h"

@interface PDLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (BOOL)validateData;

@end

@implementation PDLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initInterface];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  if (![self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Private

- (void)initInterface
{
    self.view.backgroundColor = [UIColor clearColor];
	self.contentScrollView.contentSize = CGSizeMake(self.view.width, self.loginButton.bottomYPoint + 10);
	self.loginTextField.placeholder = NSLocalizedString(@"id or email", nil);
	self.passwordTextField.placeholder = NSLocalizedString(@"password", nil);
    
    [self.forgotPasswordButton setTitle:NSLocalizedString(@"Forgot your password?", nil) forState:UIControlStateNormal];
    [self.forgotPasswordButton.titleLabel setFont:[UIFont fontWithName:PDGlobalNormalFontName size:16]];
    self.forgotPasswordButton.width = [self.forgotPasswordButton.title sizeWithFont:self.forgotPasswordButton.titleLabel.font].width + 10;
    self.forgotPasswordButton.center = CGPointMake(self.view.frame.size.width / 2, self.forgotPasswordButton.center.y);
	UIImage *backIcon = [[[UIImage alloc] init] fontAwesomeImageForIcon:[FAKFontAwesome arrowLeftIconWithSize:23] imageSize:self.backButton.frame.size attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	[self.backButton setImage:backIcon forState:UIControlStateNormal];
    
    UIImageView *loginIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.loginTextField.height, self.loginTextField.height)];
    loginIcon.layer.cornerRadius = loginIcon.height / 2;
    loginIcon.layer.borderColor = self.loginTextField.textColor.CGColor;
    loginIcon.layer.borderWidth = 1;
	loginIcon.image = [[[UIImage alloc] init] fontAwesomeImageForIcon:[FAKFontAwesome userIconWithSize:round(loginIcon.frame.size.height * 0.7)]
                                                            imageSize:loginIcon.frame.size
                                                           attributes:@{NSForegroundColorAttributeName: self.loginTextField.textColor}];
    self.loginTextField.leftView = loginIcon;
    self.loginTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *passwordIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.passwordTextField.height, self.passwordTextField.height)];
    passwordIcon.layer.cornerRadius = loginIcon.height / 2;
    passwordIcon.layer.borderColor = self.passwordTextField.textColor.CGColor;
    passwordIcon.layer.borderWidth = 1;
	passwordIcon.image = [[[UIImage alloc] init] fontAwesomeImageForIcon:[FAKFontAwesome lockIconWithSize:round(passwordIcon.frame.size.height * 0.7)]
                                                               imageSize:passwordIcon.frame.size
                                                              attributes:@{NSForegroundColorAttributeName: self.passwordTextField.textColor}];
    
    self.passwordTextField.leftView = passwordIcon;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
	
	[self.loginButton applyRedStyleToButton];
    [self.loginWithFacebookButton applyBlueStyleToButton];
}


- (BOOL)validateData
{
	if (self.loginTextField.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter login", nil)];
		return NO;
	}
	
	if (self.passwordTextField.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter password", nil)];
		return NO;
	}
	
	return YES;
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Login";
}

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

- (IBAction)loginButtonTouch:(id)sender
{
	if (![self validateData]) return;
	
	[self.view endEditing:YES];
	[kPDAppDelegate showWaitingSpinner];
	PDServerLogin *serverLogin = [[PDServerLogin alloc] initWithDelegate:self];
	[serverLogin loginWithUsername:self.loginTextField.text password:self.passwordTextField.text];
}

- (IBAction)loginWithFacebookButtonTouch:(id)sender
{
	[kPDAppDelegate showWaitingSpinner];
	self.facebookGetUserInfo = [[PDFacebookGetUserInfo alloc] initWithDelegate:self];
	[self.facebookGetUserInfo getUserInfo];
}

- (IBAction)forgotPasswordButtonTouch:(id)sender {
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([locale rangeOfString:@"zh"].location != NSNotFound) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/cn/users/password/new", kPDAppWebPage]]];
    } else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/users/password/new", kPDAppWebPage]]];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([textField isEqual:self.passwordTextField]) {
		[self loginButtonTouch:nil];
		return YES;
	} else if ([textField isEqual:self.loginTextField]) {
		[self.passwordTextField becomeFirstResponder];
		return YES;
	}
	
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	[self showErrorMessage:error];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
  if ([serverExchange isKindOfClass:[PDServerLogin class]]) {
    [self trackEvent:@"Log-in"];
  } else if ([serverExchange isKindOfClass:[PDServerSignupWithFacebook class]]) {
    [self trackEvent:@"Log-in FB"];
  }
	[kPDAppDelegate hideWaitingSpinner];
  
	[kPDAppDelegate.viewDeckController dismissViewControllerAnimated:NO completion:^{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDSuccessLoggedInNotification object:self];
  }];
}


#pragma mark - Facebook delegate

- (void)facebookDidFail:(PDFacebookExchange *)facebookExchange withError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	if ([error isEqualToString:kPDFacebookGetInfoErrorNoInfo]) {
		PDFacebookGetUserInfo *getInfoExchange = (PDFacebookGetUserInfo *) facebookExchange;
		
    PDSignupViewController *signupViewController = [[PDSignupViewController alloc] initWithNibName:@"PDSignupViewController" bundle:nil];
    [self.parentViewController addChildViewController:signupViewController];
    signupViewController.view.frame = self.parentViewController.view.zeroPositionFrame;
    [self.parentViewController.view addSubview:signupViewController.view];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
		signupViewController.emailTextField.text = getInfoExchange.email;
		signupViewController.usernameTextField.text = getInfoExchange.username;
    
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
