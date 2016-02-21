//
//  PDDeleteAccountAlertView.h
//  Pashadelic
//
//  Created by TungNT2 on 12/21/13.
//
//

#import "PDAlertView.h"
@class PDDynamicFontLabel;
@class PDGradientButton;

@interface PDDeleteAccountAlertView : PDAlertView
@property (nonatomic, weak) IBOutlet PDDynamicFontLabel *messageLabel;
@property (nonatomic, weak) IBOutlet PDGradientButton *cancelButton;
@property (nonatomic, weak) IBOutlet PDGradientButton *deleteButton;

- (IBAction)buttonCancelClicked:(id)sender;
- (IBAction)buttonDeleteClicked:(id)sender;

@end
