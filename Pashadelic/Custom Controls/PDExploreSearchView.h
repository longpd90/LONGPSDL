//
//  PDExploreSearchView.h
//  Pashadelic
//
//  Created by TungNT2 on 2/25/14.
//
//

#import "PDSearchBarController.h"
#import "UISearchView.h"
#import "PDSearchBarTextField.h"

@class PDSearchBarTextField;
@class PDGradientButton;
@class PDPlace;

@interface PDExploreSearchView : UISearchView <PDSearchBarControllerDelegate, UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet PDGradientButton *cancelButton;
@property (nonatomic, weak) IBOutlet PDGradientButton *goButton;
@property (nonatomic, weak) IBOutlet PDSearchBarTextField *searchTextField;

@property (nonatomic, strong) IBOutlet PDSearchBar *searchBar;
@property (nonatomic, weak) IBOutlet PDSearchBarController *searchBarController;

@property (nonatomic, strong) PDPlace *selectedPlace;
@property (nonatomic, strong) NSString *searchedText;
@property (nonatomic, weak) id <UISearchViewDelegate> delegate;

@end
