//
//  PDProfileEditViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 15/10/12.
//
//

#import "PDProfileEditViewController.h"
#import "UIImage+Resize.h"

enum kSections {
	kSectionInfo = 0,
	kSectionDescription,
	kSectionInterests,
	kSectionAdditionalInfo,
	kSectionsCount
	};

enum kSectionInfoRows {
	kSectionInfoRowFirstName = 0,
	kSectionInfoRowLastName,
	kSectionInfoRowsCount
	};

enum kSectionAdditionalInfos {
	kSectionAdditionalInfoLevel = 0,
	kSectionAdditionalInfoPhone,
	kSectionAdditionalInfoCountry,
	kSectionAdditionalInfoState,
	kSectionAdditionalInfoCity,
	kSectionAdditionalInfoSex,
	kSectionAdditionalInfosCount
	};

@interface PDProfileEditViewController ()
- (void)selectCountry;
- (void)selectState;
- (void)reloadView;
@end

@implementation PDProfileEditViewController

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
	
	[_finishButton setRedGradientButtonStyle];
	[_finishButton setTitle:NSLocalizedString(@"Finish", nil) forState:UIControlStateNormal];
	
	self.title = NSLocalizedString(@"Edit My Profile", nil);
	[_phoneTextField removeFromSuperview];
	[_firstNameTextField removeFromSuperview];
	[_lastNameTextField removeFromSuperview];
	[_descriptionTextView removeFromSuperview];
	[_sexSwitch removeFromSuperview];
	[_cityTextField removeFromSuperview];
	[_interestsTextView removeFromSuperview];
	[_levelSwitch removeFromSuperview];
	_cityTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	_infoTableView.tableFooterView = _finishButtonView;
	_infoTableView.tableHeaderView = _titleView;
	self.contentScrollView = _infoTableView;
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[self refreshView];
	[self fetchData];
	[self.avatarButton sd_setImageWithURL:self.profile.thumbnailURL forState:UIControlStateNormal];
	
	_infoLabel.text = NSLocalizedString(@"Click on the photo on the left to change your profile photo", nil);
	_avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
	[_sexSwitch setTitle:NSLocalizedString(@"Female", nil) forSegmentAtIndex:0];
	[_sexSwitch setTitle:NSLocalizedString(@"Male", nil) forSegmentAtIndex:1];
  self.sexSwitch.tintColor = [UIColor lightGrayColor];
	
	[_levelSwitch setTitle:NSLocalizedString(@"Professional", nil) forSegmentAtIndex:0];
	[_levelSwitch setTitle:NSLocalizedString(@"Amateur", nil) forSegmentAtIndex:1];
	[_levelSwitch setTitle:NSLocalizedString(@"Hobbyist", nil) forSegmentAtIndex:2];
  self.levelSwitch.tintColor = [UIColor lightGrayColor];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:kPDSuccessLoggedInNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setInfoTableView:nil];
	[self setSexSwitch:nil];
	[self setFinishButtonView:nil];
	[self setTitleView:nil];
	[self setAvatarButton:nil];
	[self setUsernameLabel:nil];
	[self setEmailLabel:nil];
    [self setInfoLabel:nil];
	[self setCityTextField:nil];
	[self setLevelSwitch:nil];
	[self setInterestsTextView:nil];
    [self setFinishButton:nil];
    [super viewDidUnload];
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Edit Profile";
}

- (void)fetchData
{
	[kPDAppDelegate showWaitingSpinner];
	self.loading = YES;
	self.serverExchange = [[PDServerProfileEditInfoLoader alloc] initWithDelegate:self];
	[self.serverExchange loadProfileInfo:kPDUserID];
}

- (void)refreshView
{
	_emailLabel.text = _profile.email;
	_usernameLabel.text = _profile.name;
	_firstNameTextField.text = _profile.firstName;
	_lastNameTextField.text = _profile.lastName;
	_phoneTextField.text = _profile.phone;
	_descriptionTextView.text = _profile.description;
	_sexSwitch.selectedSegmentIndex = _profile.sex;
	_interestsTextView.text = _profile.interests;
	_cityTextField.text = _profile.city;
	_levelSwitch.selectedSegmentIndex = (_profile.level == 0) ? 3 : _profile.level - 1;
	[_infoTableView reloadData];
}

- (IBAction)finishButtonTouch:(id)sender
{
	[kPDAppDelegate showWaitingSpinner];
	_profile.firstName = _firstNameTextField.text;
	_profile.lastName = _lastNameTextField.text;
	_profile.phone = _phoneTextField.text;
	_profile.desc = _descriptionTextView.text;
	_profile.city = _cityTextField.text;
	_profile.interests = _interestsTextView.text;
	_profile.sex = _sexSwitch.selectedSegmentIndex;
	_profile.level = _levelSwitch.selectedSegmentIndex + 1;
	[self trackEvent:@"Change account info"];
	self.serverExchange = [[PDServerProfileInfoUpload alloc] initWithDelegate:self];
	[self.serverExchange uploadProfileInfo:_profile];
}

- (IBAction)pickAvatar:(id)sender
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select source", nil)
																 delegate:self
														cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
												   destructiveButtonTitle:NSLocalizedString(@"Camera", nil)
														otherButtonTitles:NSLocalizedString(@"Library", nil), nil];
        [actionSheet showInView:self.view];
		
	} else {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		imagePicker.allowsEditing = YES;
		[self presentViewController:imagePicker animated:YES completion:nil];
	}
}


#pragma mark - Private

- (void)reloadView
{
	_profile = kPDAppDelegate.userProfile;
	[self refetchData];
}

- (void)selectState
{
	if (_profile.countryID == 0) {
		[UIAlertView showAlertWithTitle:nil message:@"Please select country before you select state"];
		return;
	}
	
	PDStateSelectViewController *viewController = [[PDStateSelectViewController alloc] initWithNibName:@"PDCountrySelectViewController" bundle:nil];
	viewController.delegate = self;
	viewController.countryID = _profile.countryID;
	viewController.stateID = _profile.stateID;
	[self.navigationController pushViewController:viewController animated:YES];
}

- (void)selectCountry
{
	PDCountrySelectViewController *viewController = [[PDCountrySelectViewController alloc] initWithNibName:@"PDCountrySelectViewController" bundle:nil];
	viewController.delegate = self;
	viewController.countryID = _profile.countryID;
	[self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Table delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == kSectionDescription) {
		return NSLocalizedString(@"Bio", nil);
		
	} else if (section == kSectionAdditionalInfo) {
		return NSLocalizedString(@"Additional information", nil);
		
	} else if (section == kSectionInterests) {
		return NSLocalizedString(@"Interests", nil);
	}
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return kSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == kSectionInfo) {
		return kSectionInfoRowsCount;
	} else if (section == kSectionAdditionalInfo) {
		return kSectionAdditionalInfosCount;
	}
	
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == kSectionDescription) {
		return _descriptionTextView.height + 10;
		
	} else if (indexPath.section == kSectionInterests) {
		return _interestsTextView.height + 10;
	}
	
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ProfileCellIdentifier = @"PDEditProfileCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ProfileCellIdentifier];
	}
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = @"";
	cell.detailTextLabel.text = @"";
	cell.accessoryView = nil;
	
	if (indexPath.section == kSectionInfo && indexPath.row == kSectionInfoRowFirstName) {
		cell.textLabel.text = NSLocalizedString(@"First name", nil);
		cell.accessoryView = _firstNameTextField;
		
	} else if (indexPath.section == kSectionInfo && indexPath.row == kSectionInfoRowLastName) {
		cell.textLabel.text = NSLocalizedString(@"Last name", nil);
		cell.accessoryView = _lastNameTextField;
		
	} else if (indexPath.section == kSectionDescription) {
		cell.accessoryView = _descriptionTextView;
		
	} else if (indexPath.section == kSectionAdditionalInfo && indexPath.row == kSectionAdditionalInfoPhone) {
		cell.textLabel.text = NSLocalizedString(@"Phone", nil);
		cell.accessoryView = _phoneTextField;
		
	} else if (indexPath.section == kSectionAdditionalInfo && indexPath.row == kSectionAdditionalInfoSex) {
		cell.textLabel.text = NSLocalizedString(@"Sex", nil);
		cell.accessoryView = _sexSwitch;
		
	} else if (indexPath.section == kSectionAdditionalInfo && indexPath.row == kSectionAdditionalInfoCountry) {
		cell.textLabel.text = NSLocalizedString(@"Country", nil);
		cell.detailTextLabel.text = _profile.country;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	} else if (indexPath.section == kSectionAdditionalInfo && indexPath.row == kSectionAdditionalInfoState) {
		cell.textLabel.text = NSLocalizedString(@"State", nil);
		cell.detailTextLabel.text = _profile.state;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	} else if (indexPath.section == kSectionAdditionalInfo && indexPath.row == kSectionAdditionalInfoCity) {
		cell.textLabel.text = NSLocalizedString(@"City", nil);
		cell.accessoryView = _cityTextField;
		
	} else if (indexPath.section == kSectionInterests) {
		cell.accessoryView = _interestsTextView;
		
	} else if (indexPath.section == kSectionAdditionalInfo && indexPath.row == kSectionAdditionalInfoLevel) {
		cell.accessoryView = _levelSwitch;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == kSectionAdditionalInfo && indexPath.row == kSectionAdditionalInfoCountry) {
		[self selectCountry];
		
	} else if (indexPath.section == kSectionAdditionalInfo && indexPath.row == kSectionAdditionalInfoState) {
		[self selectState];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (self.currentControl && self.isKeyboardShown) {
		[self.currentControl resignFirstResponder];
	}
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	self.loading = NO;
	
	if ([serverExchange isKindOfClass:[PDServerProfileEditInfoLoader class]]) {
		[_profile loadEditInfoFromDictionary:[result objectForKey:@"user"]];
		[self refreshView];
		
	} else if ([serverExchange isKindOfClass:[PDServerUserAvatarUpload class]]) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"New avatar was uploaded", nil)];
		UIImage *image = [_avatarButton imageForState:UIControlStateDisabled];
		[[SDImageCache sharedImageCache] storeImage:image forKey:self.profile.thumbnailURL.absoluteString];
		[[SDImageCache sharedImageCache] storeImage:image forKey:self.profile.fullImageURL.absoluteString];
		[[SDImageCache sharedImageCache] storeImage:image forKey:[result stringForKey:@"avatar_url"]];
		[_avatarButton setImage:image forState:UIControlStateNormal];
        
        NSMutableDictionary *userAvatar = [NSMutableDictionary dictionaryWithObject:image forKey:@"userAvatar"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDUserAvatarWasChangedNotification
															object:self
														  userInfo:userAvatar];

	} else if ([serverExchange isKindOfClass:[PDServerProfileInfoUpload class]]) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Info was updated", nil)];
		[_profile loadEditInfoFromDictionary:result];
		[self goBack:nil];
	}
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	self.loading = NO;
	[self showErrorMessage:error];
}


#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == actionSheet.cancelButtonIndex) return;

	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	if (buttonIndex == 0) {
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	} else {
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	
	[self presentViewController:imagePicker animated:YES  completion:nil];
}


#pragma mark - Image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
	int maxSize = 300;
    
	UIImage *userImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
	if (originalImage.size.height < maxSize || originalImage.size.width < maxSize) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Avatar image can't be smaller than 300x300 pixels", nil)];
		return;

	}
	
	if (userImage.size.height > maxSize || userImage.size.width > maxSize) {
		userImage = [userImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
													bounds:CGSizeMake(maxSize, maxSize)
									  interpolationQuality:kCGInterpolationHigh];
	}
	
	[_avatarButton setImage:userImage forState:UIControlStateDisabled];
	[kPDAppDelegate showWaitingSpinner];
	self.serverExchange = [[PDServerUserAvatarUpload alloc] initWithDelegate:self];
	[self.serverExchange uploadAvatar:userImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Text field delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([textView isEqual:_interestsTextView]) {
		if (_interestsTextView.text.length + text.length - range.length > 300) {
			return NO;
		}
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	if ([textField isEqual:_firstNameTextField]) {
		[_lastNameTextField becomeFirstResponder];
		
	} else 	if ([textField isEqual:_lastNameTextField]) {
		[_descriptionTextView becomeFirstResponder];
	}
	
	return YES;
}


#pragma mark - Country/state select delegate

- (void)countryDidSelect:(NSDictionary *)country viewController:(PDCountrySelectViewController *)viewController
{
	if ([viewController isKindOfClass:[PDStateSelectViewController class]]) {
		_profile.stateID = [country[@"id"] intValue];
		_profile.state = country[@"name"];
		
	} else {
		int newCountryID = [country[@"id"] intValue];
		if (_profile.countryID != newCountryID) {
			_profile.state = nil;
			_profile.stateID = 0;
		}
		_profile.countryID = newCountryID;
		_profile.country = country[@"name"];
	}
	[_infoTableView reloadData];
}

@end
