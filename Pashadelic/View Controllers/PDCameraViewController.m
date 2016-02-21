//
//  PDCameraViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDCameraViewController.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Resize.h"
#import "UIImage+Extra.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "PDCaptureSessionManager.h"

@interface PDCameraViewController () <UIGestureRecognizerDelegate, PDCaptureSessionManagerDelegate>

//@property (nonatomic,retain) PDAVCamCaptureManager *captureManager;
@property (strong, nonatomic) PDCaptureSessionManager *captureManager;

- (void)initCameraView;
- (void)initCameraControls;
- (void)initPhotoLibraryPickerController;
- (void)resetView;
- (void)takePhoto;

- (void)close;
- (void)toggleFlashlight;
- (void)goToLibrary;

- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer;
- (void)setButtonForFlashMode:(AVCaptureFlashMode)flashMode;
- (void)setHiddenForCameraWithState:(BOOL)state;
- (void)showFilterViewControllerFromViewController:(id)viewController;

- (void)loadEXIFDataFromURL:(NSURL *)URL;
- (BOOL)loadEXIFDataFromAsset:(ALAsset *)asset;
- (void)loadEXIFDataFromDictionary:(NSDictionary *)dictionary;
- (void)saveImageToPhotoLibrary:(UIImage *)image withExifData:(NSMutableDictionary *)exif;
- (UIImage *)resizedImage:(UIImage *)source;
- (NSDictionary *)gpsDictionaryForLocation:(CLLocation *)location;
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;

@end

@implementation PDCameraViewController
@synthesize originalPhotoImage, exifData, flashlightButton, libraryButton, takePhotoButton, closeButton, focusView, avFlashMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (IS_PHONE_4_INCH)
		self = [super initWithNibName:@"PDCameraViewController5" bundle:nibBundleOrNil];
	else
		self = [super initWithNibName:@"PDCameraViewController" bundle:nibBundleOrNil];
	if (self) {
		self.navigationItem.title = NSLocalizedString(@"Camera", nil);
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self initCameraView];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	[self initCameraControls];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(resetView)
																							 name:kPDResetCameraViewNotification
																						 object:nil];
	
	// Add a single tap gesture to focus on the point tapped, then lock focus
	UITapGestureRecognizer *tapGestureToFocus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
	[tapGestureToFocus setDelegate:self];
	[tapGestureToFocus setNumberOfTapsRequired:1];
	[self.videoPreviewView addGestureRecognizer:tapGestureToFocus];
	
	// do one time set-up of gesture recognizers
	UIGestureRecognizer *pinchGestureToZoomInOut = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)];
	pinchGestureToZoomInOut.delegate = self;
	[self.videoPreviewView addGestureRecognizer:pinchGestureToZoomInOut];
	self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self fullscreenMode:YES animated:NO];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[self setHiddenForCameraWithState:NO];
	}
	else {
		[self setHiddenForCameraWithState:YES];
	}
	
	[self initLocationService];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.captureManager startSession];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.captureManager stopSession];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self fullscreenMode:NO animated:NO];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	int xPadding = 20;
	int yPadding = 10;
	
	closeButton.frame = CGRectMakeWithSize(self.view.width - closeButton.width, 0,
																				 CGSizeMake(60, 60));
	libraryButton.frame = CGRectMakeWithSize(0, self.view.height - 60,
																					 CGSizeMake(60, 60));
	libraryButton.imageEdgeInsets = UIEdgeInsetsMake(yPadding, xPadding, 0, 0);
	takePhotoButton.frame = CGRectMakeWithSize((self.view.width - takePhotoButton.width) / 2,
																						 self.view.height - takePhotoButton.height - yPadding,
																						 takePhotoButton.frame.size);
	self.flashlightButton.frame = CGRectMakeWithSize(0, 0, CGSizeMake(60, 60));
	self.flashlightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

#pragma mark - Private

- (void)initCameraView
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[self setCaptureManager:[[PDCaptureSessionManager alloc] init]];
		self.captureManager.delegate = self;
		[self.captureManager setupSession];
		CALayer *rootLayer = [self.videoPreviewView layer];
		[rootLayer setMasksToBounds:YES];
		[self.captureManager.previewLayer setFrame:[rootLayer bounds]];
		[rootLayer addSublayer:self.captureManager.previewLayer];

	} else {
		[self initPhotoLibraryPickerController];
	}
}

- (void)initCameraControls
{
	closeButton = [UIButton buttonWithImage:[UIImage imageNamed:@"btn-camera-cancel-off.png"]];
	closeButton.width += 30;
	closeButton.height += 30;
	[closeButton setImage:[UIImage imageNamed:@"btn-camera-cancel-on.png"] forState:UIControlStateHighlighted];
	[closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];
	
	libraryButton = [UIButton buttonWithImage:[UIImage imageNamed:@"btn-camera-library-off.png"]];
	[libraryButton setImage:[UIImage imageNamed:@"btn-camera-library-on.png"] forState:UIControlStateHighlighted];
	[libraryButton addTarget:self action:@selector(goToLibrary) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:libraryButton];
	
	takePhotoButton = [UIButton buttonWithImage:[UIImage imageNamed:@"btn-camera-shutter-off.png"]];
	[takePhotoButton setImage:[UIImage imageNamed:@"btn-camera-shutter-on.png"] forState:UIControlStateHighlighted];
	[takePhotoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:takePhotoButton];
	
	if (self.captureManager.hasFlash) {
		self.flashlightButton = [UIButton buttonWithImage:[UIImage imageNamed:@"btn_no_flash.png"]];
		[self setButtonForFlashMode:self.avFlashMode];
		[self.flashlightButton addTarget:self action:@selector(toggleFlashlight) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:self.flashlightButton];
	}
	
	[self viewWillLayoutSubviews];
}

- (void)resetView
{
	self.originalPhotoImage = nil;
	self.exifData = nil;
	[self removeAndCancelFocusViewAnimation];
}

- (void)close
{
	[self fullscreenMode:NO animated:NO];
	[self resetView];
	[kPDAppDelegate.viewDeckController dismissViewControllerAnimated:NO completion:nil];
}

- (void)setButtonForFlashMode:(AVCaptureFlashMode)flashMode
{
	switch (flashMode) {
		case AVCaptureFlashModeOff:
			[self.flashlightButton setImage:[UIImage imageNamed:@"btn_no_flash.png"] forState:UIControlStateNormal];
			break;
		case AVCaptureFlashModeOn:
			[self.flashlightButton setImage:[UIImage imageNamed:@"btn_flash.png"] forState:UIControlStateNormal];
			break;
		case AVCaptureFlashModeAuto:
			[self.flashlightButton setImage:[UIImage imageNamed:@"btn_flash_auto.png"] forState:UIControlStateNormal];
			break;
		default:
			break;
	}
	self.avFlashMode = flashMode;
	[self.captureManager setFlashModeForState:self.avFlashMode];
}

- (void)setHiddenForCameraWithState:(BOOL)state
{
	self.closeButton.hidden = state;
	self.flashlightButton.hidden = state;
	self.libraryButton.hidden = state;
	self.takePhotoButton.hidden = state;
	if (!state) {
		self.videoPreviewView.hidden = NO;
		_cameraPickerController.view.hidden = YES;
	}
	else {
		self.videoPreviewView.hidden = YES;
		_cameraPickerController.view.hidden = NO;
	}
}

- (void)initPhotoLibraryPickerController
{
	_cameraPickerController = [[UIImagePickerController alloc] init];
	_cameraPickerController.delegate = self;
	_cameraPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[_cameraPickerController loadView];
	[self.view addSubview:_cameraPickerController.view];
}

- (void)takePhoto
{
	[self.captureManager captureStillImage];
	[self trackEvent:@"Take photo"];
}

#pragma mark Public

- (void)fullscreenMode:(bool)fullscreenMode animated:(bool)animated
{
	[UIApplication sharedApplication].statusBarHidden = fullscreenMode;
	[super fullscreenMode:fullscreenMode animated:animated];
}

- (void)toggleFlashlight
{
	switch (self.avFlashMode) {
		case AVCaptureFlashModeOff:
			self.avFlashMode = AVCaptureFlashModeOn;
			break;
		case AVCaptureFlashModeOn:
			self.avFlashMode = AVCaptureFlashModeAuto;
			break;
		case AVCaptureFlashModeAuto:
			self.avFlashMode = AVCaptureFlashModeOff;
			break;
		default:
			break;
	}
	[self setButtonForFlashMode:self.avFlashMode];
}

- (void)goToLibrary
{
	if (!_cameraPickerController) {
		[self initPhotoLibraryPickerController];
	}
	_cameraPickerController.view.hidden = NO;
	self.videoPreviewView.hidden = YES;
	[self setHiddenForCameraWithState:YES];
	[self trackCurrentPage];
}

- (void)showFilterViewControllerFromViewController:(id)viewController
{
	if (!originalPhotoImage || originalPhotoImage.size.width == 0 || originalPhotoImage.size.height == 0) return;
	
	PDFilterViewController *filterViewController = [[PDFilterViewController alloc] init];
	filterViewController.delegate = self;
	PDPhoto *photoObject = [PDPhoto new];
	photoObject.image = originalPhotoImage;
    photoObject.photoWidth = originalPhotoImage.size.width;
    photoObject.photoHeight = originalPhotoImage.size.height;
	photoObject.exifData = exifData;
	filterViewController.photo = photoObject;
	PDNavigationController *navigationController = [[PDNavigationController alloc] initWithRootViewController:filterViewController];
	navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[viewController presentViewController:navigationController animated:NO completion:nil];
}

- (NSString *)pageName
{
	return @"Camera";
}


#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) {
		[self close];
		return;
	}
	PDLocationSelectViewController *locationSelectViewController = [[PDLocationSelectViewController alloc] initWithNibName:@"PDLocationSelectViewController" bundle:nil];
	locationSelectViewController.delegate = self;
	PDNavigationController *navigationController = [[PDNavigationController alloc] initWithRootViewController:locationSelectViewController];
	[self presentViewController:navigationController animated:NO completion:nil];
}


#pragma mark - PDAVCamera Controls

- (void)makeAndApplyAffineTransform
{
	CGAffineTransform affineTransform = CGAffineTransformMakeTranslation(self.captureManager.effectiveTranslation.x, self.captureManager.effectiveTranslation.y);
	affineTransform = CGAffineTransformScale(affineTransform, self.captureManager.effectiveScale, self.captureManager.effectiveScale);
	[CATransaction begin];
	[CATransaction setAnimationDuration:.025];
	[self.captureManager.previewLayer setAffineTransform:affineTransform];
	[CATransaction commit];
}

- (void)showFocusView
{
	self.focusView.hidden=NO;
	[self performSelector:@selector(removeFocusView) withObject:nil afterDelay:2.5];
}

- (void)removeFocusView
{
	if (self.focusView) {
		[self.focusView removeFromSuperview];
		self.focusView=nil;
	}
}

- (void)removeAndCancelFocusViewAnimation
{
	if (self.focusView) {
		[self.focusView removeFromSuperview];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeFocusView) object:nil];
		self.focusView = nil;
	}
}


#pragma mark - UIGestureRecognizer delegate

- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer
{
	if ([self.captureManager.captureDevice isFocusPointOfInterestSupported]) {
		[self removeAndCancelFocusViewAnimation];
		CGPoint currentPoint = [gestureRecognizer locationInView:self.videoPreviewView];
		
		NSMutableArray *array =[[NSMutableArray alloc]initWithCapacity:2];
		[array addObject:[UIImage imageNamed:@"focus_1.png"]];
		[array addObject:[UIImage imageNamed:@"focus_2.png"]];
		
		self.focusView =[[UIImageView alloc]init];
		self.focusView.hidden = NO ;
		self.focusView.animationImages=array;
		self.focusView.animationDuration=0.5;
		self.focusView.animationRepeatCount=0;
		[self.focusView startAnimating];
		self.focusView.frame =CGRectMake(currentPoint.x-60,currentPoint.y-60,120,120);
		self.focusView.tag=100;
		[self.videoPreviewView addSubview:self.focusView];
		[self.videoPreviewView bringSubviewToFront:self.focusView];
		
		CGRect newRect=CGRectMake(currentPoint.x-30,currentPoint.y-30,60,60);
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		[self.focusView setFrame:newRect];
		[UIView commitAnimations];
		
		CGPoint tapPoint = [gestureRecognizer locationInView:self.videoPreviewView];
		CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
		[self.captureManager autoFocusAtPoint:convertedFocusPoint];
		[self showFocusView];
	}
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
		self.captureManager.beginGestureScale = self.captureManager.effectiveScale;
	}
	
	if ( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ) {
		CGPoint location = [gestureRecognizer locationInView:self.videoPreviewView];
		self.captureManager.beginGestureTranslation = CGPointMake(self.captureManager.effectiveTranslation.x - location.x, self.captureManager.effectiveTranslation.x - location.y);
	}
	return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if (touch.view == self.videoPreviewView)
		return YES;
	return NO;
}

- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer
{
	BOOL allTouchesAreOnThePreviewLayer = YES;
	NSUInteger numTouches = [recognizer numberOfTouches], i;
	for ( i = 0; i < numTouches; ++i ) {
		CGPoint location = [recognizer locationOfTouch:i inView:self.videoPreviewView];
		CGPoint convertedLocation = [self.captureManager.previewLayer convertPoint:location fromLayer:self.captureManager.previewLayer.superlayer];
		if (![self.captureManager.previewLayer containsPoint:convertedLocation] ) {
			allTouchesAreOnThePreviewLayer = NO;
			break;
		}
	}
	
	if (allTouchesAreOnThePreviewLayer ) {
		if ((self.captureManager.beginGestureScale*recognizer.scale)>=1.0 && (self.captureManager.beginGestureScale*recognizer.scale)<=5.0) {
			self.captureManager.effectiveScale = self.captureManager.beginGestureScale * recognizer.scale;
			[self makeAndApplyAffineTransform];
		}
	}
}

#pragma mark - PDAVCamManager delegate

- (void)captureManagerStillImageCaptured:(PDAVCamCaptureManager *)captureManager
{
	if (!isLocationReceived) {
		[[PDSingleErrorAlertView instance] showErrorMessage:NSLocalizedString(@"Enable location service for Pashadelic.\nImprove your experience on pashadelic and find photo-spots close to you!", nil)];
		[self close];
		return;
	}
	originalPhotoImage = self.captureManager.stillImage;
	originalPhotoImage = [originalPhotoImage fixOrientation];
	[self loadEXIFDataFromDictionary:self.captureManager.exifInfo];
  [self showFilterViewControllerFromViewController:self];
}

- (void)captureManager:(PDAVCamCaptureManager *)captureManager didFailWithError:(NSError *)error
{
	CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
		[alertView show];
	});
}


#pragma mark - Image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	originalPhotoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
		originalPhotoImage = [originalPhotoImage fixOrientation];
		originalPhotoImage = [self resizedImage:originalPhotoImage];
		[self loadEXIFDataFromDictionary:info];
	} else {
		[self trackEvent:@"Select photo"];
		originalPhotoImage = [self resizedImage:originalPhotoImage];
		[self loadEXIFDataFromURL:[info valueForKey:UIImagePickerControllerReferenceURL]];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			self.videoPreviewView.hidden = NO;
		}
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		[self setHiddenForCameraWithState:NO];
	else
		[self close];
}


#pragma mark - Filter view delegate

- (void)filterDidCancel
{
	[self fullscreenMode:YES animated:NO];
	[self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Location select delegate

- (void)locationDidSelect:(CLLocationCoordinate2D)coordinates viewController:(PDLocationSelectViewController *)viewController
{
	NSMutableDictionary *GPSInfo = [NSMutableDictionary dictionaryWithDictionary:
																	[exifData objectForKey:(NSString *)kCGImagePropertyGPSDictionary]];
	
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
	
	[exifData setObject:GPSInfo forKey:(NSString *)kCGImagePropertyGPSDictionary];
	
	[self showFilterViewControllerFromViewController:viewController];
}

- (void)locationSelectDidCancel:(PDLocationSelectViewController *)viewController
{
	[viewController dismissViewControllerAnimated:NO completion:nil];
	[self close];
}

#pragma mark - Override

- (void)updateLocation
{
	[super updateLocation];
	[[PDLocationHelper sharedInstance] updateLocation:^(NSError *error, CLLocation *location) {
		if (error) {
			[kPDAppDelegate updateLocationDidFailWithError:error];
			return;
		}
		isLocationReceived = YES;
	}];
}

#pragma mark - Utilites Methods

- (void)loadEXIFDataFromURL:(NSURL *)URL
{
	ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
	[assetLibrary assetForURL:URL resultBlock:^(ALAsset *asset) {
		ALAssetRepresentation *representation = [asset defaultRepresentation];
		NSUInteger byteArraySize = (NSInteger) representation.size;
		
		NSMutableData* rawData = [[NSMutableData alloc] initWithCapacity:byteArraySize];
		void *bufferPointer = [rawData mutableBytes];
		
		NSError *error = nil;
		[representation getBytes:bufferPointer fromOffset:0 length:byteArraySize error:&error];
		if (error) {
			NSLog(@"%@", [error localizedDescription]);
		}
		
		rawData = [NSMutableData dataWithBytes:bufferPointer length:byteArraySize];
		NSString *filepath = [kPDCachePath stringByAppendingPathComponent:@"camera_image.jpg"];
		[rawData writeToFile:filepath atomically:YES];
		
		if ([self loadEXIFDataFromAsset:asset])
			[self showFilterViewControllerFromViewController:self];
		
	} failureBlock:^(NSError *error) {
		[self close];
		NSLog(@"Error: %@", [error localizedDescription]);
	}];
}

- (BOOL)loadEXIFDataFromAsset:(ALAsset *)asset
{
	exifData = [NSMutableDictionary dictionaryWithDictionary:asset.defaultRepresentation.metadata];
	
	NSMutableDictionary *GPSInfo = [NSMutableDictionary dictionaryWithDictionary:
																	[exifData objectForKey:(NSString *)kCGImagePropertyGPSDictionary]];
	if (GPSInfo.count == 0) {
		NSString *message = NSLocalizedString(@"Selected photo doesn't have GPS information.\nDo you want to map the photo manually?", nil);
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
																												message:message
																											 delegate:self
																							cancelButtonTitle:NSLocalizedString(@"No", nil)
																							otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
		[alertView show];
		return NO;
	}
	[exifData setObject:GPSInfo forKey:(NSString *)kCGImagePropertyGPSDictionary];
	return YES;
}

- (void)loadEXIFDataFromDictionary:(NSDictionary *)dictionary
{
	exifData = [NSMutableDictionary dictionaryWithDictionary:dictionary];
	[self saveImageToPhotoLibrary:originalPhotoImage withExifData:exifData];
}

- (void)saveImageToPhotoLibrary:(UIImage *)image withExifData:(NSMutableDictionary *)exif
{
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	
	double longitude = (double)[[PDLocationHelper sharedInstance] longitudes];
	double latitude = (double)[[PDLocationHelper sharedInstance] latitudes];
	CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
	[exif setObject:[self gpsDictionaryForLocation:location] forKey:(NSString*)kCGImagePropertyGPSDictionary];
	[exif setObject:[NSNumber numberWithInt:UIImageOrientationUp] forKey:@"Orientation"];
	[exifData setObject:[NSNumber numberWithInt:UIImageOrientationUp] forKey:@"Orientation"];
	
	// create album pashadelic if it haven't already created and save photo to
	[library saveImage:image and:exif toAlbum:@"Pashadelic" withCompletionBlock:^(NSError *error) {
		//handling error
		if (error) {
			NSLog(@"Create album pashadelic failed: %@",[error description]);
		}
	}];
}

- (UIImage *)resizedImage:(UIImage *)source
{
	if (source.size.width <= kPDMaxPhotoSize && source.size.height <= kPDMaxPhotoSize) return source;
	
	return [source resizedImageWithContentMode:UIViewContentModeScaleAspectFit
																			bounds:CGSizeMake(kPDMaxPhotoSize, kPDMaxPhotoSize)
												interpolationQuality:kCGInterpolationHigh];
}

- (NSDictionary *)gpsDictionaryForLocation:(CLLocation *)location
{
	CLLocationDegrees exifLatitude  = location.coordinate.latitude;
	CLLocationDegrees exifLongitude = location.coordinate.longitude;
	
	NSString * latRef;
	NSString * longRef;
	if (exifLatitude < 0.0) {
		exifLatitude = exifLatitude * -1.0f;
		latRef = @"S";
	} else {
		latRef = @"N";
	}
	
	if (exifLongitude < 0.0) {
		exifLongitude = exifLongitude * -1.0f;
		longRef = @"W";
	} else {
		longRef = @"E";
	}
	
	NSMutableDictionary *locDict = [[NSMutableDictionary alloc] init];
	
	[locDict setObject:location.timestamp forKey:(NSString*)kCGImagePropertyGPSTimeStamp];
	[locDict setObject:latRef forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
	[locDict setObject:[NSNumber numberWithDouble:exifLatitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
	[locDict setObject:longRef forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
	[locDict setObject:[NSNumber numberWithDouble:exifLongitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
	[locDict setObject:[NSNumber numberWithDouble:location.horizontalAccuracy] forKey:(NSString*)kCGImagePropertyGPSDOP];
	[locDict setObject:[NSNumber numberWithDouble:location.altitude] forKey:(NSString*)kCGImagePropertyGPSAltitude];
	
	return locDict;
	
}

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
	CGPoint pointOfInterest = CGPointMake(.5f, .5f);
	CGSize frameSize = self.videoPreviewView.frame.size;
	AVCaptureConnection *stillImageConnection = [self.captureManager.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
	if ([stillImageConnection isVideoMirrored]) {
		viewCoordinates.x = frameSize.width - viewCoordinates.x;
	}
	
	if ( [[self.captureManager.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
		pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
	} else {
		
		
		CGRect cleanAperture;
		for (AVCaptureInputPort *port in self.captureManager.captureDeviceInput.ports) {
			//        for (AVCaptureInputPort *port in [[[self captureManager] videoInput] ports]) {
			if ([port mediaType] == AVMediaTypeVideo) {
				cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
				CGSize apertureSize = cleanAperture.size;
				CGPoint point = viewCoordinates;
				
				CGFloat apertureRatio = apertureSize.height / apertureSize.width;
				CGFloat viewRatio = frameSize.width / frameSize.height;
				CGFloat xc = .5f;
				CGFloat yc = .5f;
				
				if ( [[self.captureManager.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
					if (viewRatio > apertureRatio) {
						CGFloat y2 = frameSize.height;
						CGFloat x2 = frameSize.height * apertureRatio;
						CGFloat x1 = frameSize.width;
						CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
						if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
							xc = point.y / y2;
							yc = 1.f - ((point.x - blackBar) / x2);
						}
					} else {
						CGFloat y2 = frameSize.width / apertureRatio;
						CGFloat y1 = frameSize.height;
						CGFloat x2 = frameSize.width;
						CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
						if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
							xc = ((point.y - blackBar) / y2);
							yc = 1.f - (point.x / x2);
						}
					}
				} else if ([[self.captureManager.previewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
					if (viewRatio > apertureRatio) {
						CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
						xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
						yc = (frameSize.width - point.x) / frameSize.width;
					} else {
						CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
						yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
						xc = point.y / frameSize.height;
					}
				}
				
				pointOfInterest = CGPointMake(xc, yc);
				break;
			}
		}
	}
	
	return pointOfInterest;
}

@end
