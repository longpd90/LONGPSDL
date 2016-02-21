//
//  PDSearchUsersViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 17/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoTableViewController.h"
#import "PDUsersTableView.h"
#import "PDUserViewController.h"
#import "PDServerUsersSearch.h"
#import "PDSearchTextField.h"
#import "MGGradientView.h"

@interface PDSearchUsersViewController : PDPhotoTableViewController
<PDItemSelectDelegate, MGServerExchangeDelegate>
{
	NSString *searchText;
}

@property (strong, nonatomic) PDUsersTableView *usersTableView;
@property (strong, nonatomic) PDUserViewController *userViewController;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (weak, nonatomic) IBOutlet PDSearchTextField *searchTextField;

- (IBAction)cancelSearch:(id)sender;
- (IBAction)search:(id)sender;

@end
