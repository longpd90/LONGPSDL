//
//  PDDeleteAccountAlertView.m
//  Pashadelic
//
//  Created by TungNT2 on 12/21/13.
//
//

#import "PDDeleteAccountAlertView.h"
#import "PDDynamicFontLabel.h"
#import "PDGradientButton.h"

#define kPDActivityViewWidth        30
@implementation PDDeleteAccountAlertView

- (id)init
{
    self = [UIView loadFromNibNamed:@"PDDeleteAccountAlertView"];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    [self.messageLabel setText:NSLocalizedString(@"This will permanently remove your account at Pashadelic and all of your photos? \n\nDo you really want to delete your account?", nil)];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel", nil)];
    [self.cancelButton setRedGradientButtonStyle];
    [self.deleteButton setTitle:NSLocalizedString(@"delete", nil)];
    [self.deleteButton setOrangeGradientButtonStyle];
}

- (IBAction)buttonCancelClicked:(id)sender
{
    [self dismissWithBackgroundView:YES];
}

- (IBAction)buttonDeleteClicked:(id)sender
{
    UIView *backgroundView = [kPDAppDelegate.window viewWithTag:kPDWindowBackgroundViewTag];
    if (backgroundView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(0, 0, kPDActivityViewWidth, kPDActivityViewWidth);
        activityView.center = backgroundView.centerOfView;
        [backgroundView addSubview:activityView];
        [activityView startAnimating];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewDidFinish:)]) {
        [self.delegate alertViewDidFinish:self];
    }
    [self dismissWithBackgroundView:NO];
}

@end
