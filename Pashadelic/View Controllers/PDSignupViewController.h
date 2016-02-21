//
//  PDSignupWIthMailViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerCheckUsername.h"
#import "PDServerCheckEmail.h"
#import "PDViewController.h"
#import "PDFacebookGetUserInfo.h"
#import "PDServerSignupWithFacebook.h"

@interface PDSignupViewController : PDViewController
<MGServerExchangeDelegate, PDFacebookExchangeDelegate>

@property (weak, nonatomic) IBOutlet PDGlobalFontButton *signupWithEmailButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *signupWithFacebookButton;
@property (weak, nonatomic) IBOutlet PDUnderlinedTextField *emailTextField;
@property (weak, nonatomic) IBOutlet PDUnderlinedTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet PDUnderlinedTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *termsButton;
@property (strong, nonatomic) PDFacebookGetUserInfo *facebookGetUserInfo;

- (IBAction)showTermsOfUse:(id)sender;
- (IBAction)signupWithEmail:(id)sender;
- (IBAction)signupWithFacebook:(id)sender;

@end
