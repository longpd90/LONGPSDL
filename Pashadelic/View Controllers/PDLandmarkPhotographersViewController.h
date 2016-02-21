//
//  PDLandmarkPhotographersViewController.h
//  Pashadelic
//
//  Created by LTT on 6/19/14.
//
//

#import "PDPhotoTableViewController.h"
#import "PDUsersTableView.h"
#import "PDUserViewController.h"
#import "PDLocation.h"
@interface PDLandmarkPhotographersViewController : PDPhotoTableViewController
<PDItemSelectDelegate, MGServerExchangeDelegate>
@property (strong, nonatomic) PDLocation *location;
@property (strong, nonatomic) PDUsersTableView *usersTableView;
@property (strong, nonatomic) PDUserViewController *userViewController;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;

@end
