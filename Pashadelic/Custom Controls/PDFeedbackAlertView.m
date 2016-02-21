//
//  PDFeedbackAlertView.m
//  Pashadelic
//
//  Created by TungNT2 on 12/23/13.
//
//

#import "PDFeedbackAlertView.h"
#import "PDDynamicFontLabel.h"
#import "PDGradientButton.h"
#import "SSTextView.h"
#define PointYKeypadShow 292
#define PointYButtonKeyPadHidden 300

@interface PDFeedbackAlertView (Private) <UITextViewDelegate>
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)swipeDownGestureHandler;
@end

@implementation PDFeedbackAlertView

- (id)init
{
    self = [UIView loadFromNibNamed:@"PDFeedbackAlertView"];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    [self.messageLabel setText:NSLocalizedString(@"Your account has been deleted. Thank you for being a part of Pashadelic", nil)];
    [self.submitButton setTitle:NSLocalizedString(@"submit", nil)];
    [self.submitButton setBlueDarkGradientButtonStyle];
    self.submitButton.enabled = NO;
    [self.submitButton setBlueDarkGradientButtonStyle];
    [self.skipButton setTitle:NSLocalizedString(@"skip", nil)];
    [self.skipButton setGrayLightGradientButtonStyle];
    [self.feedbackTextView setPlaceholder:NSLocalizedString(@"Please tell us what we could have done better to keep you as part of our community", nil)];
    self.feedbackTextView.delegate = self;
    self.feedbackTextView.layer.shadowOffset = CGSizeMake(2, 2);
	self.feedbackTextView.layer.shadowOpacity = 0.5;
	self.feedbackTextView.layer.shadowRadius = 2.0;
	self.feedbackTextView.layer.shadowColor = [UIColor blackColor].CGColor;
	self.feedbackTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.feedbackTextView.layer.borderWidth = 0.4;
    self.feedbackTextView.layer.cornerRadius = 5;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownGestureHandler)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDownGesture];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)buttonSubmitClicked:(id)sender
{
    if (self.feedbackTextView.text != nil && [self.feedbackTextView.text length] > 0) {
        [kPDAppDelegate sendDeactiveAccountFeedbackWithBody:self.feedbackTextView.text];
    }
    [self.feedbackTextView resignFirstResponder];
    self.feedbackTextView.text = nil;
    [self dismissWithBackgroundView:YES];
}

- (IBAction)buttonSkipClicked:(id)sender
{
    [self dismissWithBackgroundView:YES];
}

#pragma mark - UITextView delegate

- (void)textViewDidChange:(UITextView *)textView
{
    [(SSTextView *)textView showCaretPosition];
    if (textView.text != 0 && [textView.text length] > 0) {
        [self.submitButton setRedGradientButtonStyle];
        self.submitButton.enabled = YES;
    }
    else {
        [self.submitButton setBlueDarkGradientButtonStyle];
        self.submitButton.enabled = NO;
    }
}

#pragma mark - UIView Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.feedbackTextView resignFirstResponder];
}

#pragma mark - Notification 

- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        self.submitButton.y = PointYKeypadShow;
        self.skipButton.y = PointYKeypadShow;
        if (IS_PHONE_4_INCH)
            self.y = 20;
        else
            self.y = -70;
    } completion:^(BOOL finished) {
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{

    [UIView animateWithDuration:0.2 animations:^{
        self.submitButton.y = PointYButtonKeyPadHidden;
        self.skipButton.y = PointYButtonKeyPadHidden;
        self.y = (self.superview.height - self.height)/2;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Gesture Recognize

- (void)swipeDownGestureHandler
{
    [self.feedbackTextView resignFirstResponder];
}

@end
