//
//  PDSearchBarTextField.m
//  Pashadelic
//
//  Created by TungNT2 on 4/25/14.
//
//

#import "PDSearchBarTextField.h"

@implementation PDSearchBarTextField

- (void)initialize
{
    [self setLeftViewWithImage:[UIImage imageNamed:@"icon_location_search.png"]];
    [self setRightViewWithImage:[UIImage imageNamed:@"btn_search_cancel.png"]];
    self.rightClearButton.hidden = YES;
}

- (void)setLeftViewWithImage:(UIImage *)image
{
    UIImageView *magnifier = [[UIImageView alloc] initWithImage:image];
    magnifier.contentMode = UIViewContentModeScaleAspectFit;
	self.leftViewMode = UITextFieldViewModeAlways;
	self.leftView = magnifier;
}

- (void)setRightViewWithImage:(UIImage *)image
{
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightClearButton = [UIButton buttonWithImage:image];
}

- (void)setRightClearButton:(UIButton *)rightClearButton
{
    _rightClearButton = rightClearButton;
    self.rightView = rightClearButton;
}

- (BOOL)validateTextSearch
{
    NSCharacterSet * characterSet = [NSCharacterSet characterSetWithCharactersInString:@"~!@#$%^[]|{}&*()_+=-/?\\⁄€‹›ﬂ‡°·‚—ºª•¶§∞¢£™¡`"];
    if ([self.text rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
        [UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Prohibit any special characters", nil)];
        return NO;
    } else {
        return YES;
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected)
        self.textColor = [UIColor redColor];
    else
        self.textColor = [UIColor blackColor];
}

@end
