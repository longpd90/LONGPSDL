//
//  PDSearchBar.m
//  Pashadelic
//
//  Created by TungNT2 on 4/23/14.
//
//

#import "PDSearchBar.h"
#import "UIView+Extra.h"

#define kPDDefaultSpace 10

@implementation PDSearchBar

@synthesize  searchController = _searchController;


- (void)activateSearch:(BOOL)activate
{
    float width = activate ? self.width - self.cancelButton.width - self.textField.x - kPDDefaultSpace * 2 :
                             self.width - self.textField.x - kPDDefaultSpace;
    [UIView animateWithDuration:0.3 animations:^{
        self.textField.frame = CGRectMake(self.textField.x, self.textField.y, width, self.textField.height);
        self.cancelButton.frame = CGRectMake(self.textField.x + kPDDefaultSpace + self.textField.width,
                                             self.cancelButton.y,
                                             self.cancelButton.width,
                                             self.cancelButton.height);
        self.cancelButton.alpha = activate ? 1 : 0;
    }];
}

+ (PDSearchBar *)view
{
    return (PDSearchBar *)[[UIViewController alloc] initWithNibName:@"PDSearchBar" bundle:nil].view;
}

- (IBAction)cancel:(id)sender
{
    self.searchController.active = NO;
}

- (void)setSearchController:(PDSearchBarController *)searchController
{
    _searchController = searchController;
    self.textField.delegate = searchController;
}

- (void)setIconForLeftView:(UIImage *)image
{
	self.textField.leftView = [[UIImageView alloc] initWithImage:image];
}

- (void)setIconForRightView:(UIImage *)image
{
    self.textField.rightClearButton = [UIButton buttonWithImage:image];
}

- (void)setPlaceHolder:(NSString *)placeholder
{
    self.textField.placeholder = placeholder;
    self.textField.rightClearButton.hidden = YES;
}

- (void)clearSearch
{
    self.textField.text = nil;
    self.textField.isSelected = NO;
    self.textField.rightClearButton.hidden = YES;
    if (![self.textField isFirstResponder])
        [self.textField becomeFirstResponder];
}

@end
