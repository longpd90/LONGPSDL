//
//  PDPOIReviewsViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDTableViewController.h"
#import "PDServerPOIReviewsLoader.h"
#import "PDServerRatePOIItem.h"
#import "PDReviewsTableView.h"

@interface PDPOIReviewsViewController : PDTableViewController

@property (strong, nonatomic) PDServerRatePOIItem *serverRate;
@property (strong, nonatomic) PDReviewsTableView *reviewsTableView;
@property (strong, nonatomic) PDPOIItem *poiItem;
@property (weak, nonatomic) IBOutlet UIButton *reviewInfoButton;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIView *ratingToolbarView;

- (IBAction)rateButtonTouch:(id)sender;
- (IBAction)reviewInfoButtonTouch:(id)sender;

@end
