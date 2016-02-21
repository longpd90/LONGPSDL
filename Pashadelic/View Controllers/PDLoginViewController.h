//
//  PDLoginViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDTextField.h"
#import "PDFacebookGetUserInfo.h"
#import "PDServerSignupWithFacebook.h"
#import "PDViewController.h"
#import "PDLinedButton.h"

@interface PDLoginViewController : PDViewController
<MGServerExchangeDelegate, PDFacebookExchangeDelegate>

@property (weak, nonatomic) IBOutlet PDUnderlinedTextField *loginTextField;
@property (weak, nonatomic) IBOutlet PDUnderlinedTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *loginWithFacebookButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *loginButton;
@property (weak, nonatomic) IBOutlet PDLinedButton *forgotPasswordButton;
@property (strong, nonatomic) PDFacebookGetUserInfo *facebookGetUserInfo;

- (IBAction)loginButtonTouch:(id)sender;
- (IBAction)loginWithFacebookButtonTouch:(id)sender;
- (IBAction)forgotPasswordButtonTouch:(id)sender;

@end
