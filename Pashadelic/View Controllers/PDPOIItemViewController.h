//
//  PDGeoTagViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.05.13.
//
//

#import "PDPhotoTableViewController.h"
#import "PDPOIItem.h"
#import "PDServerGeoTagLoader.h"
#import "PDPOIInfoViewController.h"
#import "UIImageView+Extra.h"
#import "MGGradientView.h"
#import "PDRatingView.h"
#import "PDPOIReviewsViewController.h"
#import "PDPOIFollowersViewController.h"
#import "PDFollowLandmarkButton.h"

@interface PDPOIItemViewController : PDPhotoTableViewController

@property (strong, nonatomic) PDPOIFollowersViewController *followersViewController;
@property (strong, nonatomic) PDPOIReviewsViewController *reviewsViewController;
@property (weak, nonatomic) IBOutlet PDRatingView *ratingView;
@property (strong, nonatomic) PDPOIItem *poiItem;
@property (strong, nonatomic) PDPOIInfoViewController *infoViewController;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *photosCountButton;
@property (weak, nonatomic) IBOutlet PDGradientButton *sortTypeButton;
@property (weak, nonatomic) IBOutlet PDFollowLandmarkButton *followButton;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIImageView *poiImageView;
@property (weak, nonatomic) IBOutlet UIButton *reviewsButton;
@property (weak, nonatomic) IBOutlet UIButton *followersButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomBarButton;
@property (weak, nonatomic) IBOutlet UIView *bottomBarContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UIView *topView;


- (IBAction)changeSorting:(id)sender;
- (IBAction)showReviews:(id)sender;
- (IBAction)showFollowers:(id)sender;
- (IBAction)toggleBottomBar:(id)sender;

@end
