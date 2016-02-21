//
//  PDFeedbackAlertView.h
//  Pashadelic
//
//  Created by TungNT2 on 12/23/13.
//
//

#import "PDAlertView.h"

@class PDDynamicFontLabel;
@class PDGradientButton;
@class SSTextView;
@class PDOverlayView;
@interface PDFeedbackAlertView : PDAlertView
@property (nonatomic, weak) IBOutlet PDDynamicFontLabel *messageLabel;
@property (nonatomic, weak) IBOutlet SSTextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet PDGradientButton *submitButton;
@property (nonatomic, weak) IBOutlet PDGradientButton *skipButton;
@property (nonatomic, strong) PDOverlayView *overlayView;
- (IBAction)buttonSubmitClicked:(id)sender;
- (IBAction)buttonSkipClicked:(id)sender;

@end
