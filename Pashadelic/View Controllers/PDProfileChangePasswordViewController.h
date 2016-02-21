//
//  PDProfileChangePasswordViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 10.12.12.
//
//

#import "PDViewController.h"
#import "PDServerChangePassword.h"
#import "PDServerForgotPassword.h"

@interface PDProfileChangePasswordViewController : PDViewController
<MGServerExchangeDelegate>

@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet PDGradientButton *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *someNewPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;

- (IBAction)save:(id)sender;
- (void)forgotPassword;

@end
