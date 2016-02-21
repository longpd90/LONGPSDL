#import <AVFoundation/AVFoundation.h>

@protocol PDCaptureSessionManagerDelegate;

@interface PDCaptureSessionManager : NSObject {

}
@property (retain, nonatomic) AVCaptureDevice *captureDevice;
@property (retain, nonatomic) AVCaptureDeviceInput *captureDeviceInput;
@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;
@property (retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) UIImage *stillImage;
@property (assign, nonatomic) id<PDCaptureSessionManagerDelegate> delegate;
@property (assign) CGFloat effectiveScale;
@property (assign) CGPoint effectiveTranslation;
@property (assign) CGFloat beginGestureScale;
@property (assign) CGPoint beginGestureTranslation;
@property (retain, nonatomic) NSDictionary *exifInfo;

- (void)captureStillImage;
- (void)setFlashModeForState:(AVCaptureFlashMode)flashMode;
- (void)autoFocusAtPoint:(CGPoint)point;
- (void)continuousFocusAtPoint:(CGPoint)point;
- (BOOL)hasFlash;
- (void)startSession;
- (void)stopSession;
- (void)setupSession;
@end

@protocol PDCaptureSessionManagerDelegate <NSObject>
@optional
- (void)captureManager:(PDCaptureSessionManager *)captureManager didFailWithError:(NSError *)error;
- (void)captureManagerStillImageCaptured:(PDCaptureSessionManager *)captureManager;
- (void)captureManagerDeviceConfigurationChanged:(PDCaptureSessionManager *)captureManager;
@end