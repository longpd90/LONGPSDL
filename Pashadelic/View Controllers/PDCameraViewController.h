//
//  PDCameraViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PDFilterViewController.h"
#import "PDUploadPhotoViewController.h"
#import "PDNavigationController.h"
#import "PDLocationSelectViewController.h"
#import "PDPhotoLandmarkViewController.h"

@class PDAVCamCaptureManager;

@interface PDCameraViewController : PDViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,
UIAlertViewDelegate, PDFilterViewControllerDelegate, PDLocationSelectDelegate>

@property (strong, nonatomic) UIButton *flashlightButton;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *libraryButton;
@property (strong, nonatomic) UIButton *takePhotoButton;
@property (strong, nonatomic) UIImagePickerController *cameraPickerController;
@property (strong, nonatomic) UIImage *originalPhotoImage;
@property (strong, nonatomic) NSMutableDictionary *exifData;
@property (strong, nonatomic) IBOutlet UIView *videoPreviewView;

@property (nonatomic,retain) UIImageView *focusView;
@property (assign) AVCaptureFlashMode avFlashMode;

@end
