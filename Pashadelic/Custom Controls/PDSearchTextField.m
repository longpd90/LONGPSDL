//
//  PDSearchTextField.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.04.13.
//
//

#import "PDSearchTextField.h"

@implementation PDSearchTextField

- (void)initialize
{
	[super initialize];
	UIImageView *magnifier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_search.png"]];
	self.leftViewMode = UITextFieldViewModeAlways;
	self.leftView = magnifier;
	self.rightViewMode = UITextFieldViewModeAlways;
	self.rightClearButton = [UIButton buttonWithImage:[UIImage imageNamed:@"btn_search_cancel.png"]];
	self.rightView = self.rightClearButton;
}


- (void)setIConLocationSearchForLeftView
{
    UIImageView *magnifier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_location_search.png"]];
    magnifier.contentMode = UIViewContentModeScaleAspectFit;
	self.leftViewMode = UITextFieldViewModeAlways;
	self.leftView = magnifier;
}

- (BOOL)validateTextSearch
{
    NSCharacterSet * characterSet = [NSCharacterSet characterSetWithCharactersInString:@"~!@#$%^[]|{}&*()+=-/?\\⁄€‹›ﬂ‡°·‚—ºª•¶§∞¢£™¡`"];
    if ([self.text rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
        [UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Prohibit any special characters", nil)];
        return NO;
    } else {
        return YES;
    }
}

@end
