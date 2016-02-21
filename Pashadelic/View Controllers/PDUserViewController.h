//
//  PDUserViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 27/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerUserLoader.h"
#import "PDPhotoTableViewController.h"
#import "PDServerUserFollowings.h"
#import "PDServerUserFollowersLoader.h"
#import "PDUsersTableView.h"
#import "PDPhotoUserTableView.h"
#import "PDUserViewButton.h"
#import "PDServerGetUserPins.h"
#import "PDFollowItemButton.h"

@interface PDUserViewController : PDPhotoTableViewController
<MGServerExchangeDelegate, PDItemSelectDelegate,PDItemsTableDelegate>
{
	BOOL isUserInfoLoaded;
}
@property (nonatomic, assign) NSUInteger userViewSource;
@property (strong, nonatomic) PDUsersTableView *usersTableView;
@property (strong, nonatomic) PDPhotoUserTableView *photoUsersTableView;
@property (strong, nonatomic) PDUser *user;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIButton *userPhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *collectionsButton;
@property (weak, nonatomic) IBOutlet UIButton *followerButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapMakerImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet PDFollowItemButton *followButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *showUserMapButton;
@property (strong, nonatomic) IBOutlet UIView *aboutView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextview;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestesLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *interestsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *userMapMarkerView;

- (IBAction)changeSource:(id)sender;
- (IBAction)showUserMap:(id)sender;
- (IBAction)showAboutUser:(id)sender;

@end
