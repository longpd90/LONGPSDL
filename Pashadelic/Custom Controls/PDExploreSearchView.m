//
//  PDExploreSearchView.m
//  Pashadelic
//
//  Created by TungNT2 on 2/25/14.
//
//

#import "PDExploreSearchView.h"
#import "PDGradientButton.h"
#import "PDPlace.h"
#import "PDGooglePlaceAutocomplete.h"
#import "PDGooglePlaceDetails.h"
#import "PDGoogleGeocoding.h"
#import "UIImage+Extra.h"

@interface PDExploreSearchView ()
- (void)initSearchBar;
- (void)searchText;
- (void)cancelSearchText:(id)sender;
- (void)textFieldDidChange:(NSNotification *)notification;
- (void)refreshView;
@end
@implementation PDExploreSearchView

- (id)init
{
    self = [UIView loadFromNibNamed:@"PDExploreSearchView"];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    [self initInterface];
}

- (void)dealloc
{
    self.searchTextField = nil;
    self.searchedText = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)initInterface
{
    [self initSearchBar];
    [self.cancelButton setWhiteSmokeGradientButtonStyle];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel explore", nil) forState:UIControlStateNormal];
    [self.goButton setRedGradientButtonStyle];
    UIImage *backgroundDisableImage = [[UIImage alloc] imageWithColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
    [self.goButton setBackgroundImage:backgroundDisableImage forState:UIControlStateDisabled];
    [self.goButton setTitle:NSLocalizedString(@"go", nil) forState:UIControlStateNormal];
    [self.goButton setTitle:[self.goButton titleForState:UIControlStateNormal]
                   forState:UIControlStateDisabled];
    self.goButton.enabled = YES;
    
    self.searchTextField.placeholder = NSLocalizedString(@"e.g Golden gate bridge", nil);
    [self.searchTextField setLeftViewWithImage:[UIImage imageNamed:@"icon_search.png"]];
    self.searchTextField.delegate = self;
    [self.searchTextField becomeFirstResponder];
    [self.searchTextField.rightClearButton addTarget:self
                                              action:@selector(cancelSearchText:)
                                    forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self.searchTextField];
}

- (void)initSearchBar
{
    self.searchBarController.searchBar.frame = self.searchBar.frame;
    [self.searchBar.superview addSubview:self.searchBarController.searchBar];
    [self.searchBar removeFromSuperview];
    self.searchBarController.delegate = self;
    self.searchBar = self.searchBarController.searchBar;
    [self.searchBar setPlaceHolder:NSLocalizedString(@"enter landmark, city, state name", nil)];
}

- (void)setSearchedText:(NSString *)searchedText
{
    _searchedText = searchedText;
    self.searchTextField.text = searchedText;
    if (self.searchTextField.text && self.searchTextField.text.length > 0) {
        self.searchTextField.rightClearButton.hidden = NO;
    }
    if (![self.searchTextField isFirstResponder]) {
        [self.searchTextField becomeFirstResponder];
    }
}

- (void)setSelectedPlace:(PDPlace *)selectedPlace
{
    if (!selectedPlace) return;
    
    _selectedPlace = selectedPlace;
    self.searchBar.textField.text = selectedPlace.description;
    self.searchBar.textField.rightClearButton.hidden = NO;
    self.searchBar.textField.isSelected = YES;
}

- (void)refreshView
{
    self.goButton.enabled = YES;
}

- (IBAction)search:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchViewDidFinishWithTextSearch:place:)]) {
        [self.delegate searchViewDidFinishWithTextSearch:self.searchTextField.text place:self.selectedPlace];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self hideSearch];
}

- (IBAction)cancel:(id)sender
{
    self.searchBarController.active = NO;
    [super cancel:sender];
}

#pragma mark - Search text

- (void)searchText
{
    if (self.searchTextField.text && self.searchTextField.text.length > 0) {
        self.searchTextField.rightClearButton.hidden = NO;
    } else {
        self.searchTextField.rightClearButton.hidden = YES;
    }
}

- (void)cancelSearchText:(id)sender
{
    self.searchTextField.rightClearButton.hidden = YES;
    self.searchTextField.text = nil;
    if (![self.searchTextField isFirstResponder])
        [self.searchTextField becomeFirstResponder];
}

#pragma mark - Search Location Suggestion

- (void)cancelSearch
{
    self.goButton.enabled = self.searchBar.textField.isSelected ? YES : NO;
}

#pragma mark - NSNotificationCenter

- (void)textFieldDidChange:(NSNotification *)notification
{
    if ([notification.object isEqual:self.searchTextField]) {
        [self searchText];
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self search:nil];
    return YES;
}

#pragma mark - SearchBar delegate

- (void)searchBar:(PDSearchBarController *)searchBarController didSelectedPlace:(PDPlace *)place
{
    self.selectedPlace = place;
    self.searchBar.textField.isSelected = YES;
    self.goButton.enabled = YES;
}

- (void)searchBarDidCancel
{
    self.goButton.enabled = self.searchBar.textField.isSelected ? YES : NO;
}

@end
