//
//  PDMapToolsViewController.h
//  Pashadelic
//
//  Created by TungNT2 on 4/23/13.
//
//

#import "PDMapViewController.h"
#import "PDPhotoMapToolsView.h"
#import "PDServerNearbyLoader.h"
#import "PDSearchBarController.h"

@interface PDPhotoToolsViewController : PDMapViewController
<PDPullableViewDelegate, UITextFieldDelegate, PDSearchBarControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *titleLocationView;
@property (nonatomic, weak) IBOutlet UILabel *titleLocationLabel;
@property (nonatomic, strong) IBOutlet PDSearchBar *searchBar;
@property (nonatomic, strong) IBOutlet PDSearchBarController *searchBarController;
@property (nonatomic, strong) PDPhotoMapToolsView *photoMapToolsView;
@property (strong, nonatomic) IBOutlet UIView *searchView;

@end
