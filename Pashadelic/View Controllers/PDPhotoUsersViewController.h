//
//  PDPhotoUsersViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDTableViewController.h"
#import "PDUsersTableView.h"


@interface PDPhotoUsersViewController : PDTableViewController
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) PDUsersTableView *usersTableView;
@property (weak, nonatomic) IBOutlet UIButton *usersTypeAndCountButton;
@property (weak, nonatomic) PDPhoto *photo;

@end
