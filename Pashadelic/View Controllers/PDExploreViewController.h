//
//  PDExploreViewController.h
//  Pashadelic
//
//  Created by LongPD on 2/20/14.
//
//

#import "PDPhotoTableViewController.h"
#import "PDSearchTextField.h"
#import "PDServerNearbyLoader.h"
#import "UISearchView.h"
#import "PDExploreMapViewController.h"
#import "PDFilterSearchViewController.h"

@class PDPlace;

@interface PDExploreViewController : PDPhotoTableViewController <MGServerExchangeDelegate, UITextFieldDelegate,
UISearchViewDelegate, PDExploreMapViewControllerDelegate>

@property (nonatomic, strong) PDPlace *selectedPlace;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (weak, nonatomic) IBOutlet MGLocalizedLabel *labelTopView;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *showMapButton;
@property (nonatomic, strong) PDServerNearbyLoader *serverNearbyLoader;
@property (nonatomic, strong) PDSearchTextField *searchTextField;
@property (nonatomic, strong) id googleServices;
@property (nonatomic, strong) NSString *searchedText;

- (IBAction)showPhotosInMap:(id)sender;

@end
