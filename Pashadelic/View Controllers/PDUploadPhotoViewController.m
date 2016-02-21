//
//  PDUploadPhotoViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 28/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDUploadPhotoViewController.h"
#import "PDServerPhotoUploader.h"
#import <ImageIO/ImageIO.h>
#import "PDServerEnableShare.h"
#import "UIImage+MTFilter.h"

@interface PDUploadPhotoViewController ()
- (void)initMapView;
- (void)initLandmarkTextView;
- (BOOL)validateData;
- (void)cancel;
- (void)customizeTextFields;
- (void)editLandmark;

@end

@implementation PDUploadPhotoViewController
@synthesize mapPlaceholderView;
@synthesize photo, photoMapView;
@synthesize titleTextField, descriptionTextField, photoLandmarkTextField;


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
    self.title = NSLocalizedString(@"Upload", nil);
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self setRightBarButtonToButton:[self redBarButtonWithTitle:NSLocalizedString(@"upload", nil)
                                                               action:@selector(finish:)]];
	[self initMapView];
	[self customizeTextFields];
    
	descriptionTextField.placeholder = kPDCommentsPlaceholderText;
    [descriptionTextField newInterface];

	[_previousKeyboardButton setRedGradientButtonStyle];
	[_previousKeyboardButton setTitle:NSLocalizedString(@"previous", nil) forState:UIControlStateNormal];
	[_nextKeyboardButton setRedGradientButtonStyle];
	[_nextKeyboardButton setTitle:NSLocalizedString(@"next", nil) forState:UIControlStateNormal];
	[_doneKeyboardButton setRedGradientButtonStyle];
	[_doneKeyboardButton setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];

	titleTextField.placeholder = NSLocalizedString(@"Title : Describe the photo", nil);
    [titleTextField uploadPhotoStyle];

    _photoTagsTextField.placeholder = NSLocalizedString(@"Tags (optional)", nil);
    [_photoTagsTextField uploadPhotoStyle];
    [_photoTagsTextField clearBackgroundColor];
    
    _photoTipsTextfield.placeholder = NSLocalizedString(@"Add extra tips (e.g. tripod access)", nil);
    [_photoTipsTextfield uploadPhotoStyle];
    [_photoTipsTextfield clearBackgroundColor];
    
    photoLandmarkTextField.placeholder = NSLocalizedString(@"Select a landmark in the photo", nil);
    photoLandmarkTextField.backgroundColor = [UIColor clearColor];
    photoLandmarkTextField.layer.borderColor = [UIColor clearColor].CGColor;
    photoLandmarkTextField.textAlignment = NSTextAlignmentCenter;
    photoLandmarkTextField.textColor = [UIColor whiteColor];
    
    if (self.photo) {
        [self setPhoto:self.photo];
    }
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

- (void)setPhoto:(PDPhoto *)newPhoto
{
    photo = newPhoto;
    if ([self isViewLoaded]) {
        UIImage *blurImage = [UIImage imageWithBlur:newPhoto.image];
        [self.backgroundImageView setImage:blurImage];
        [self.backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)dealloc
{
	[self.photoMapView releaseMemory];
	self.photoMapView = nil;
}

#pragma mark - Private

- (void)customizeTextFields
{    
    titleTextField.inputAccessoryView = _keyboardToolbar;
    descriptionTextField.inputAccessoryView = _keyboardToolbar;
}

- (BOOL)validateData
{
	if (!self.photo.image) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"No image data", nil)];
		return NO;
	}
    
	if (titleTextField.text.length == 0 || [titleTextField.text isEqualToString:titleTextField.placeholder]) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter photo title", nil)];
		return NO;
	}
    
	return YES;
}

- (void)initMapView
{
	photoMapView = [[PDPhotosMapView alloc] initWithFrame:CGRectMakeWithSize(0, 0, mapPlaceholderView.frame.size)];
    mapPlaceholderView.layer.masksToBounds = YES;
	[mapPlaceholderView addSubview:photoMapView];
	mapPlaceholderView.layer.cornerRadius = 8;
	photoMapView.changeMapModeButton.hidden = YES;
	[mapPlaceholderView sendSubviewToBack:photoMapView];
}

- (void)cancel
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
														message:NSLocalizedString(@"The photo will be saved in the library, but all additional information will be lost.", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
											  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alertView show];
}

- (void)initLandmarkTextView
{
    photoLandmarkTextField.rightViewMode = UITextFieldViewModeAlways;
    photoLandmarkTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
}

- (IBAction)editTags:(id)sender
{
    PDPhotoTagsViewController *photoTagsViewController = [[PDPhotoTagsViewController alloc] initWithNibName:@"PDPhotoTagsViewController" bundle:nil];
    photoTagsViewController.photo = photo;
    [self.navigationController pushViewController:photoTagsViewController animated:YES];
}

- (IBAction)editTips:(id)sender
{
    PDPhotoTipsViewController *photoTipsViewController = [[PDPhotoTipsViewController alloc] initWithNibName:@"PDTipsViewViewController" bundle:nil];
    photoTipsViewController.photo = photo;
    [self.navigationController pushViewController:photoTipsViewController animated:YES];
}

- (void)editLandmark
{
    if ([[self previousViewController] isKindOfClass:[PDPhotoLandmarkViewController class]]) {
        [self.navigationController popViewControllerAnimated:YES];
        if (!photo.poiItem.name) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(editLandmarkWithPhoto:)]) {
                [self.delegate editLandmarkWithPhoto:self.photo];
            }
        }
    } else if ([[self previousViewController] isKindOfClass:[PDLandmarkSelectMapViewController class]]) {
        NSArray *viewControllers = [self.navigationController viewControllers];
        [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count - 3] animated:YES];
    } else {
        PDPhotoLandmarkViewController *photoLandmarkViewController = [[PDPhotoLandmarkViewController alloc] initForUniversalDevice];
        [photoLandmarkViewController changeTitleRightBarButton];
        photoLandmarkViewController.photo = photo;
        [self.navigationController pushViewController:photoLandmarkViewController animated:YES];
    }
}

- (void)showOverlayViewWithEdit:(TextEditType )textEditType
{
    if (!self.overlayViewTop) {
        self.overlayViewTop = [[PDOverlayView alloc] init];
        self.overlayViewTop.backgroundColor = [UIColor clearColor];
        self.overlayViewTop.delegate = self;
        [self.view addSubview:self.overlayViewTop];
    }
    self.overlayViewTop.hidden = NO;
    
    
    if (!self.overlayViewBottom) {
        self.overlayViewBottom = [[PDOverlayView alloc] init];
        self.overlayViewBottom.backgroundColor = [UIColor clearColor];
        self.overlayViewBottom.delegate = self;
        [self.view addSubview:self.overlayViewBottom];
    }
    self.overlayViewBottom.hidden = NO;
    
    if (textEditType == PDTitleTextField) {
        self.overlayViewTop.frame = CGRectMake(0,0, 320,titleTextField.frame.origin.y);
        self.overlayViewBottom.frame = CGRectMake(0,titleTextField.frame.origin.y + titleTextField.frame.size.height, 320, self.view.frame.size.height - titleTextField.frame.size.height);

    }
    else if (textEditType == PDDescriptionTextView)
    {
        self.overlayViewTop.frame = CGRectMake(0,0, 320,descriptionTextField.frame.origin.y);
        self.overlayViewBottom.frame = CGRectMake(0,descriptionTextField.frame.origin.y + descriptionTextField.frame.size.height, 320, self.view.frame.size.height - titleTextField.frame.size.height);

    }

}

#pragma mark - Public

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    if (!photo.poiItem.name) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(editLandmarkWithPhoto:)]) {
            [self.delegate editLandmarkWithPhoto:self.photo];
        }
    }
}

- (NSString *)pageName
{
	return @"Photo Upload";
}

- (IBAction)changeLocation:(id)sender
{
	PDLocationSelectViewController *locationSelectViewController = [[PDLocationSelectViewController alloc] initWithNibName:@"PDLocationSelectViewController" bundle:nil];
    locationSelectViewController.delegate = self;
    [locationSelectViewController changeTitleRightBarButton];
    [self.navigationController pushViewController:locationSelectViewController animated:NO];
    [locationSelectViewController setCoordinates:photo.coordinates];
}

- (void)resetView
{
	titleTextField.text = @"";
	descriptionTextField.text = @"";
	_photoTagsTextField.text = @"";
    photoLandmarkTextField.text = @"";
    _photoTipsTextfield.text = @"";
}

- (IBAction)btnPreviousClicked:(id)sender
{
    if ([self.currentControl isEqual:descriptionTextField]) {
		self.currentControl = titleTextField;
		[titleTextField becomeFirstResponder];
        _nextKeyboardButton.hidden = NO;
	}
}

- (IBAction)btnNextClicked:(id)sender
{
	_nextKeyboardButton.hidden = NO;
    if ([self.currentControl isEqual:titleTextField]) {
		self.currentControl = descriptionTextField;
		[descriptionTextField becomeFirstResponder];
        _nextKeyboardButton.hidden = YES;
	}
}

- (IBAction)enableFacebook:(id)sender
{
	self.facebookExchange = [[PDFacebookExchange alloc] initWithDelegate:self];
	[self.facebookExchange loginForPublish];
}

- (void)fetchData
{
	_facebookShareSwitch.hidden = YES;
	_facebookShareSwitch.on = NO;
	_facebookEnableButton.enabled = NO;
	self.serverExchange = [[PDServerFacebookShareStatus alloc] initWithDelegate:self];
	[self.serverExchange getFacebookShareStatus];
}

- (void)refreshView
{
	self.needRefreshView = NO;
	self.title = NSLocalizedString(@"Upload", nil);
	_photoTagsTextField.text = photo.tags;
    _photoTipsTextfield.text = nil;
    NSMutableString *tips = [[NSMutableString alloc] init];
    
    if (photo.tripod == 1)
        [tips appendFormat:@", %@",NSLocalizedString(@"tripod usage", nil)];
    else if (photo.tripod == 0)
        [tips appendFormat:@", %@",NSLocalizedString(@"no tripod usage", nil)];
    
    if (photo.is_crowded == 1)
        [tips appendFormat:@", %@",NSLocalizedString(@"crowded", nil)];
    else if (photo.is_crowded == 0)
        [tips appendFormat:@", %@",NSLocalizedString(@"no crowded", nil)];
    
	if (photo.is_parking == 1)
        [tips appendFormat:@", %@",NSLocalizedString(@"parking nearby", nil)];
    else if (photo.is_parking == 0)
        [tips appendFormat:@", %@",NSLocalizedString(@"no parking nearby", nil)];
    
    if (photo.is_dangerous == 1)
        [tips appendFormat:@", %@",NSLocalizedString(@"dangerous", nil)];
    else if (photo.is_dangerous == 0)
        [tips appendFormat:@", %@",NSLocalizedString(@"no dangerous", nil)];
    
    if (photo.indoor == 1)
        [tips appendFormat:@", %@",NSLocalizedString(@"indoor", nil)];
    else if (photo.indoor == 0)
        [tips appendFormat:@", %@",NSLocalizedString(@"outdoor", nil)];
    
    if (photo.is_permission == 1)
        [tips appendFormat:@", %@",NSLocalizedString(@"require permission", nil)];
    else if (photo.is_permission == 0)
        [tips appendFormat:@", %@",NSLocalizedString(@"no require permission", nil)];
    
    if (photo.is_paid == 1)
        [tips appendFormat:@", %@",NSLocalizedString(@"cost to access", nil)];
    else if (photo.is_paid == 0)
        [tips appendFormat:@", %@",NSLocalizedString(@"no cost to access", nil)];
    
    if (photo.difficulty_access == 1)
        [tips appendFormat:@", %@",NSLocalizedString(@"accessibility: hard", nil)];
    else if (photo.difficulty_access == 2)
        [tips appendFormat:@", %@",NSLocalizedString(@"accessibility: medium", nil)];
    else if (photo.difficulty_access == 3)
        [tips appendFormat:@", %@",NSLocalizedString(@"accessibility: easy", nil)];

    if (tips.length > 0) {
        NSString *tipsText = [tips substringFromIndex:1];
        _photoTipsTextfield.text = tipsText;
    }
    
    if (photo.poiItem.name == nil)
        photoLandmarkTextField.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Select a landmark in the photo", nil)];
    else
        photoLandmarkTextField.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"with landmark", nil), photo.poiItem.name];

	photoMapView.items = [NSArray arrayWithObject:photo];
	[photoMapView reloadMap];
}

- (void)doneTextEditing:(id)sender
{
	[titleTextField resignFirstResponder];
	[descriptionTextField resignFirstResponder];
    self.overlayViewTop.hidden = YES;
    self.overlayViewBottom.hidden = YES;
}

- (void)finish:(id)sender
{
	if (![self validateData]) return;
    
	if (self.isLoading) {
		[UIAlertView showAlertWithTitle:nil
								message:NSLocalizedString(@"Please wait while app upload info for Facebook", nil)];
		return;
	}
	photo.title = titleTextField.text;
	photo.details = descriptionTextField.text;

    [[PDServerPhotoUploader sharedInstance] addItemToQueueWithPhoto:photo
                                                           exifInfo:photo.exifData
                                                              poiId:photo.poiItem.identifier
                                                      facebookShare:_facebookShareSwitch.on];
    [self trackEvent:@"Photo upload"];
    [kPDAppDelegate.viewDeckController dismissViewControllerAnimated:NO completion:^{
	    [[PDServerPhotoUploader sharedInstance] startUploadQueue];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPDResetCameraViewNotification object:nil];
		[self resetView];

	}];
}

- (IBAction)socialButtonTouch:(id)sender
{
	UIButton *button = (UIButton *)sender;
	button.selected = !button.selected;
}
#pragma mark - overlay view delegate

- (void)didTouchesToOverlayView
{
    [titleTextField resignFirstResponder];
    [descriptionTextField resignFirstResponder];
    self.overlayViewTop.hidden = YES;
    self.overlayViewBottom.hidden = YES;
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if (![self.serverExchange isEqual:serverExchange]) return;
	self.loading = NO;
	
	if ([serverExchange isKindOfClass:[PDServerFacebookShareStatus class]]) {
		_facebookShareSwitch.hidden = ![result boolForKey:@"fb_share_availabe"];
		_facebookEnableButton.enabled = ![result boolForKey:@"fb_share_availabe"];
		
	} else if ([serverExchange isKindOfClass:[PDFacebookExchange class]]) {
		_facebookShareSwitch.hidden = NO;
		_facebookEnableButton.enabled = NO;
		self.serverExchange = [[PDServerEnableShare alloc] initWithDelegate:self];
		[self.serverExchange enableFacebookShare];
	}
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	self.loading = NO;
	_facebookShareSwitch.hidden = YES;
	_facebookEnableButton.enabled = YES;
	[self showErrorMessage:error];
}


#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) return;
	
	[self resetView];
	[kPDAppDelegate.viewDeckController dismissViewControllerAnimated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kPDResetCameraViewNotification object:self];
	
}


#pragma mark - UITextViewDelegate and UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneTextEditing:nil];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if ([textField isEqual:_photoTagsTextField]) {
		[self editTags:nil];
		return NO;
	}
	if ([textField isEqual:_photoTipsTextfield]) {
        [self editTips:nil];
        return NO;
    }
    if ([textField isEqual:photoLandmarkTextField]) {
        [self editLandmark];
        return NO;
    }
    if ([textField isEqual:titleTextField]) {
        [self showOverlayViewWithEdit:PDTitleTextField];
        
    }
	self.currentControl = textField;
	[self scrollToCurrentControl];
	return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	self.currentControl = textView;
	[self scrollToCurrentControl];
	_nextKeyboardButton.hidden = YES;
	return YES;
}

#pragma mark - textview delegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self showOverlayViewWithEdit:PDDescriptionTextView];

}

- (void)textViewDidChange:(UITextView *)textView
{
    [(SSTextView *)textView showCaretPosition];
}

#pragma mark - Facebook delegate

- (void)facebookDidFail:(PDFacebookExchange *)facebookExchange withError:(NSString *)error
{
	[self showErrorMessage:error];
    self.loading = NO;
}

- (void)facebookDidFinish:(PDFacebookExchange *)facebookExchange withResult:(id)result
{
	_facebookShareSwitch.on = NO;
	_facebookShareSwitch.hidden = NO;
	_facebookEnableButton.enabled = NO;
	self.loading = NO;
	self.serverExchange = [[PDServerFacebookShareState alloc] initWithDelegate:self];
	[self.serverExchange updateFacebookShareState];
}


#pragma mark - Location select delegate

- (void)locationDidSelect:(CLLocationCoordinate2D)coordinates viewController:(PDLocationSelectViewController *)viewController
{
    photo.poiItem.name = nil;
	photo.latitude = coordinates.latitude;
	photo.longitude = coordinates.longitude;
    
	NSMutableDictionary *GPSInfo = [NSMutableDictionary dictionaryWithDictionary:
									[photo.exifData objectForKey:(NSString *)kCGImagePropertyGPSDictionary]];
	
	
	if (coordinates.latitude < 0) {
		[GPSInfo setObject:@"S" forKey:@"LatitudeRef"];
		[GPSInfo setObject:[NSNumber numberWithDouble:-coordinates.latitude] forKey:@"Latitude"];
	} else {
		[GPSInfo setObject:@"N" forKey:@"LatitudeRef"];
		[GPSInfo setObject:[NSNumber numberWithDouble:coordinates.latitude] forKey:@"Latitude"];
	}
	
	if (coordinates.longitude < 0) {
		[GPSInfo setObject:@"W" forKey:@"LongitudeRef"];
		[GPSInfo setObject:[NSNumber numberWithDouble:-coordinates.longitude] forKey:@"Longitude"];
	} else {
		[GPSInfo setObject:@"E" forKey:@"LongitudeRef"];
		[GPSInfo setObject:[NSNumber numberWithDouble:coordinates.longitude] forKey:@"Longitude"];
	}
	
	NSMutableDictionary *mutableExifInfo = [NSMutableDictionary dictionaryWithDictionary:photo.exifData];
	[mutableExifInfo setObject:GPSInfo forKey:(NSString *)kCGImagePropertyGPSDictionary];
	photo.exifData = mutableExifInfo;
    [viewController.navigationController popViewControllerAnimated:NO];
}

- (void)locationSelectDidCancel:(PDLocationSelectViewController *)viewController
{
    [viewController.navigationController popViewControllerAnimated:NO];
}

@end
