//
//  PDPOIFollowersViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDTableViewController.h"
#import "PDUsersTableView.h"

@interface PDPOIFollowersViewController : PDTableViewController

@property (strong, nonatomic) PDUsersTableView *usersTableView;
@property (strong, nonatomic) PDPOIItem *poiItem;

@end
