//
//  PDSearchBar.h
//  Pashadelic
//
//  Created by TungNT2 on 4/23/14.
//
//

#import <Foundation/Foundation.h>
#import "PDSearchBarController.h"
#import "PDSearchBarTextField.h"

@class PDSearchBarTextField;
@class PDSearchBarController;

@interface PDSearchBar : UIView
@property (nonatomic, strong) IBOutlet PDSearchBarTextField *textField;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;
@property (nonatomic, strong) PDSearchBarController *searchController;

+ (PDSearchBar *)view;
- (void)activateSearch:(BOOL)activate;
- (void)setPlaceHolder:(NSString *)placeholder;
- (void)setIconForLeftView:(UIImage *)image;
- (void)setIconForRightView:(UIImage *)image;
- (IBAction)cancel:(id)sender;
- (void)clearSearch;
@end
