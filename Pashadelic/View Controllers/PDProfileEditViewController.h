//
//  PDProfileEditViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 15/10/12.
//
//

#import "PDViewController.h"
#import "PDUserProfile.h"
#import "PDServerUserAvatarUpload.h"
#import "PDServerProfileEditInfoLoader.h"
#import "PDServerProfileInfoUpload.h"
#import "PDStateSelectViewController.h"

@interface PDProfileEditViewController : PDViewController
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate,
MGServerExchangeDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate,
PDCountrySelectDelegate>

@property (weak, nonatomic) PDUserProfile *profile;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet PDGradientButton *finishButton;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *levelSwitch;
@property (strong, nonatomic) IBOutlet UIView *finishButtonView;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UITextView *interestsTextView;

- (IBAction)finishButtonTouch:(id)sender;
- (IBAction)pickAvatar:(id)sender;

@end
