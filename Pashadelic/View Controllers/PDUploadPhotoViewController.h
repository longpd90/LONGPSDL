//
//  PDUploadPhotoViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 28/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDViewController.h"
#import "PDTextField.h"
#import "PDPhotoTipsViewController.h"
#import "PDPhotosMapView.h"
#import "SSTextView.h"
#import "PDCategorySelectView.h"
#import "PDServerFacebookShareStatus.h"
#import "PDServerFacebookShareState.h"
#import "PDLocationSelectViewController.h"
#import "PDFacebookExchange.h"
#import "PDNavigationController.h"
#import "PDPhotoTagsViewController.h"
#import "PDPhotoLandmarkViewController.h"
#import "PDLandmarkSelectMapViewController.h"
#import "PDOverlayView.h"

typedef enum {
    PDTitleTextField = 0,
    PDDescriptionTextView
} TextEditType;

@class PDUploadPhotoViewController;

@protocol PDUploadPhotoDelegate <NSObject>
- (void)editLandmarkWithPhoto:(PDPhoto *)photo;
@end


@interface PDUploadPhotoViewController : PDViewController <UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate,
 MGServerExchangeDelegate, PDFacebookExchangeDelegate, PDLocationSelectDelegate,PDOverlayViewDelegate>

@property (weak, nonatomic) id<PDUploadPhotoDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *mapPlaceholderView;
@property (weak, nonatomic) IBOutlet PDGradientButton *doneKeyboardButton;
@property (weak, nonatomic) IBOutlet PDGradientButton *nextKeyboardButton;
@property (weak, nonatomic) IBOutlet PDGradientButton *previousKeyboardButton;
@property (weak, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (weak, nonatomic) IBOutlet UISwitch *facebookShareSwitch;
@property (weak, nonatomic) IBOutlet UIButton *facebookEnableButton;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet PDTextField  *titleTextField;
@property (weak, nonatomic) IBOutlet SSTextView   *descriptionTextField;
@property (weak, nonatomic) IBOutlet PDTextField *photoTagsTextField;
@property (weak, nonatomic) IBOutlet PDTextField *photoTipsTextfield;
@property (weak, nonatomic) IBOutlet PDTextField *photoLandmarkTextField;
@property (weak, nonatomic) IBOutlet MGLocalizedLabel *shareOnLabel;
@property (weak, nonatomic) IBOutlet MGLocalizedLabel *editLocationLabel;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *editLocationButton;
@property (strong, nonatomic) PDOverlayView *overlayViewTop;
@property (strong, nonatomic) PDOverlayView *overlayViewBottom;

@property (strong, nonatomic) PDPhotosMapView *photoMapView;
@property (strong, nonatomic) PDPhoto *photo;
@property (strong, nonatomic) PDFacebookExchange *facebookExchange;

- (IBAction)changeLocation:(id)sender;
- (void)resetView;
- (IBAction)doneTextEditing:(id)sender;
- (IBAction)finish:(id)sender;
- (IBAction)socialButtonTouch:(id)sender;
- (IBAction)btnPreviousClicked:(id)sender;
- (IBAction)btnNextClicked:(id)sender;
- (IBAction)enableFacebook:(id)sender;
- (IBAction)editTags:(id)sender;
- (IBAction)editTips:(id)sender;

@end
