//
//  PDTagViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

enum PDTagViewSource {
	PDTagViewSourcePhotos = 1,
	PDTagViewSourceUsers
	};

#import "PDServerTagPhotosLoader.h"
#import "PDServerTagUsersLoader.h"
#import "PDPhotoTableViewController.h"
#import "PDUsersTableView.h"
#import "PDTag.h"

@interface PDTagViewController : PDPhotoTableViewController

@property (strong, nonatomic) PDTag *tag;
@property (assign, nonatomic) NSUInteger sourceType;
@property (strong, nonatomic) PDUsersTableView *usersTableView;
@property (weak, nonatomic) IBOutlet PDToolbarButton *sourcePhotosButton;
@property (weak, nonatomic) IBOutlet PDToolbarButton *sourceFollowersButton;

- (IBAction)changeSource:(id)sender;

@end
