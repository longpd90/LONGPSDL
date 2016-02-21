#import "PDCaptureSessionManager.h"
#import <ImageIO/ImageIO.h>
#import "UIDevice-Hardware.h"
#import "UIImage+Resize.h"
#import "UIImage+Crop.h"

@interface PDCaptureSessionManager ()
- (void)loadEXIFInfoFromBuffer:(CMSampleBufferRef)buffer;
- (void)resizeStillImage;
- (void)addVideoPreviewLayer;
- (void)addStillImageOutput;
- (void)addVideoInputCamera;
@end

@implementation PDCaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;
@synthesize stillImage;

#pragma mark Capture Session Configuration

- (id)init {
	if ((self = [super init])) {
		self.captureSession = [[[AVCaptureSession alloc] init] autorelease];
		[self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
	}
	return self;
}

- (void)setupSession
{
	[self addVideoInputCamera];
	[self addStillImageOutput];
	[self addVideoPreviewLayer];

}

- (void)startSession
{
	self.effectiveScale = 1.0;
	self.effectiveTranslation = CGPointZero;
	self.beginGestureScale = 1.0;
	self.beginGestureTranslation = CGPointZero;
	self.previewLayer.affineTransform = CGAffineTransformIdentity;
	if ([[self captureSession] canAddInput:self.captureDeviceInput]) {
		[[self captureSession] addInput:self.captureDeviceInput];
	} else {
		NSLog(@"Couldn't add video input");
	}
	if ([self.captureSession canAddOutput:self.stillImageOutput]) {
		[[self captureSession] addOutput:self.stillImageOutput];
	} else {
		NSLog(@"Couldn't add video output");
	}
	[self.captureSession startRunning];
		
}

- (void)stopSession
{
	[self.captureSession stopRunning];
	[self.captureSession removeInput:self.captureDeviceInput];
	[self.captureSession removeOutput:self.stillImageOutput];
}

- (void)addVideoPreviewLayer
{
	if (self.previewLayer) return;
	
	[self setPreviewLayer:[[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]] autorelease]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
	
}

- (void)addVideoInputCamera
{
	NSArray *devices = [AVCaptureDevice devices];
	
	for (AVCaptureDevice *device in devices) {
		if ([device hasMediaType:AVMediaTypeVideo]) {
			if ([device position] == AVCaptureDevicePositionBack) {
				self.captureDevice = device;
			}
		}
	}
	
	self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
}

- (void)addStillImageOutput
{
	[self setStillImageOutput:[[[AVCaptureStillImageOutput alloc] init] autorelease]];
	NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
	[[self stillImageOutput] setOutputSettings:outputSettings];
	[outputSettings release];
}

- (void)captureStillImage
{
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in [[self stillImageOutput] connections]) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
			break;
		}
	}
	[videoConnection setVideoScaleAndCropFactor:self.effectiveScale];
	
	[[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
		[self loadEXIFInfoFromBuffer:imageSampleBuffer];
		NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
		self.stillImage = [[[UIImage alloc] initWithData:imageData] autorelease];
		[self resizeStillImage];
		
		if ([self.delegate respondsToSelector:@selector(captureManagerStillImageCaptured:)]) {
			[self.delegate captureManagerStillImageCaptured:self];
		}
	}];
}

- (void)resizeStillImage
{
	if (self.stillImage.size.width > kPDMaxPhotoSize || self.stillImage.size.height > kPDMaxPhotoSize) {
		self.stillImage = [self.stillImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
																														bounds:CGSizeMake(kPDMaxPhotoSize, kPDMaxPhotoSize)
																							interpolationQuality:kCGInterpolationHigh];
	}
	CGSize previewLayerSize = self.previewLayer.bounds.size;
	CGFloat verticalRatio = kPDMaxPhotoSize / previewLayerSize.height;
	CGFloat horizontalRatio = kPDMaxPhotoSize / previewLayerSize.width;
	CGSize requiredImageSize;
	if (verticalRatio > horizontalRatio) {
		requiredImageSize = CGSizeMake(floor(previewLayerSize.width * horizontalRatio), floor(previewLayerSize.height * horizontalRatio));
	} else {
		requiredImageSize = CGSizeMake(floor(previewLayerSize.width * verticalRatio), floor(previewLayerSize.height * verticalRatio));
	}
	CGSize imageSize = self.stillImage.size;
	self.stillImage = [self.stillImage croppedImage:CGRectMake(round((imageSize.height - requiredImageSize.height) / 2),
																														 round((imageSize.width - requiredImageSize.width) / 2),
																														 requiredImageSize.width, requiredImageSize.height)];
}

- (void)loadEXIFInfoFromBuffer:(CMSampleBufferRef)buffer
{
	CFDictionaryRef exifAttachments = CMGetAttachment(buffer, kCGImagePropertyExifDictionary, NULL);
	NSMutableDictionary *mutableEXIF = [NSMutableDictionary dictionaryWithDictionary:(__bridge NSDictionary *)exifAttachments];
	
	NSMutableDictionary *tiffDictionary = [mutableEXIF objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
	if (!tiffDictionary) {
		tiffDictionary = [NSMutableDictionary dictionary];
	}
	[tiffDictionary setObject:@"Apple" forKey:(id)kCGImagePropertyTIFFMake];
	[tiffDictionary setObject:[[UIDevice currentDevice] platformString] forKey:(id)kCGImagePropertyTIFFModel];
	[tiffDictionary setObject:[[UIDevice currentDevice] systemVersion] forKey:(id)kCGImagePropertyTIFFSoftware];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy:MM:dd' 'HH:mm:ss"];
	[tiffDictionary setObject:[formatter stringFromDate:[NSDate date]] forKey:(id)kCGImagePropertyTIFFDateTime];
	[formatter release];
	
	[mutableEXIF setObject:tiffDictionary forKey:(id)kCGImagePropertyTIFFDictionary];
	
	NSMutableDictionary *exifDictionary = [mutableEXIF objectForKey:(NSString *)kCGImagePropertyExifDictionary];
	if (!exifDictionary) {
		exifDictionary = [NSMutableDictionary dictionary];
	}
	if (![[exifDictionary objectForKey:(NSString *)kCGImagePropertyExifDateTimeOriginal] dateFormattedByString:@"yyyy:MM:dd HH:mm:ss"]) {
		[exifDictionary setObject:[[NSDate date] stringValueFormattedBy:@"yyyy:MM:dd HH:mm:ss"] forKey:(NSString *)kCGImagePropertyExifDateTimeOriginal];
	}
	if (![[exifDictionary objectForKey:(NSString *)kCGImagePropertyExifDateTimeDigitized] dateFormattedByString:@"yyyy:MM:dd HH:mm:ss"]) {
		[exifDictionary setObject:[[NSDate date] stringValueFormattedBy:@"yyyy:MM:dd HH:mm:ss"] forKey:(NSString *)kCGImagePropertyExifDateTimeDigitized];
	}
	
	[mutableEXIF setObject:exifDictionary forKey:(id)kCGImagePropertyTIFFDictionary];
	
	self.exifInfo = [NSDictionary dictionaryWithDictionary:mutableEXIF];
}

- (BOOL)hasFlash
{
	return self.captureDevice.hasFlash;
}

- (void)setFlashModeForState:(AVCaptureFlashMode)flashMode
{
	NSError *error;
	if (self.hasFlash) {
		if ([self.captureDevice lockForConfiguration:&error]) {
			if ([self.captureDevice isFlashModeSupported:flashMode]) {
				[self.captureDevice setFlashMode:flashMode];
			}
			[self.captureDevice unlockForConfiguration];
		}
		else {
			if ([self.delegate respondsToSelector:@selector(captureManager:didFailWithError:)]) {
				[self.delegate captureManager:self didFailWithError:error];
			}
		}
	}
}

- (void)autoFocusAtPoint:(CGPoint)point
{
	AVCaptureDevice *device = self.captureDevice;
	NSError *error;
	if ([device lockForConfiguration:&error]) {
		if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
			[device setFocusPointOfInterest:point];
			[device setFocusMode:AVCaptureFocusModeAutoFocus];
		}
		
		if ([device isExposurePointOfInterestSupported] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
			[device setExposurePointOfInterest:point];
			[device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
		}
		[device unlockForConfiguration];
	} else {
		if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
			[[self delegate] captureManager:self didFailWithError:error];
		}
	}
}

- (void)continuousFocusAtPoint:(CGPoint)point
{
	AVCaptureDevice *device = self.captureDevice;
	if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			[device setFocusPointOfInterest:point];
			[device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
			[device unlockForConfiguration];
		} else {
			if ([[self delegate] respondsToSelector:@selector(captureManager:didFailWithError:)]) {
				[[self delegate] captureManager:self didFailWithError:error];
			}
		}
	}
}

- (void)dealloc
{
	[[self captureSession] stopRunning];
	[_captureDeviceInput release], _captureDeviceInput = nil;
	[_exifInfo release], _exifInfo = nil;
	[previewLayer release], previewLayer = nil;
	[captureSession release], captureSession = nil;
	[stillImageOutput release], stillImageOutput = nil;
	[stillImage release], stillImage = nil;
	
	[super dealloc];
}

@end
