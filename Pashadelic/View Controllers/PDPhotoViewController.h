//
//  PDPhotoViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 26/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDTableViewController.h"
#import <MapKit/MapKit.h>
#import "PDPhotoImageView.h"
#import "PDServerPhotoLoader.h"
#import "PDServerLike.h"
#import "PDServerPin.h"
#import "PDCommentsTableView.h"
#import "PDCommentsViewController.h"
#import "PDCommentCell.h"
#import "MWPhotoBrowser.h"
#import "PDNavigationController.h"
#import "PDPhotoDescriptionLabel.h"
#import "PDFollowItemButton.h"
#import "PDFollowLandmarkButton.h"
#import "PDPhotoViewGroup.h"
#import "PDLinedButton.h"
#import "PDPhotoMapViewController.h"
#import "PDPhotosView.h"
#import "PDPhotoPinnedUsersViewController.h"
#import "PDPhotoLikingUsersViewController.h"
#import "PDPhotoInfoViewController.h"
#import "PDCollectionsViewController.h"
#import "TTTAttributedLabel.h"

@class PDPhotoViewController;
@class PDTagViewController;
@class PDPOIItemViewController;
@class PDPhotoTableViewController;


@protocol PDPhotoViewControllerDataSource <NSObject>
- (NSUInteger)numberOfPhotosFor:(PDPhotoViewController *)photoViewController;
- (NSUInteger)indexOfPhoto:(PDPhoto *)photo forPhotoViewController:(PDPhotoViewController *)photoViewController;
- (PDPhoto *)photoAtIndex:(NSUInteger)index forPhotoViewController:(PDPhotoViewController *)photoViewController;
- (void)dismissPhotoViewController:(PDPhotoViewController *)photoViewController
                         withPhoto:(PDPhoto *)photo
                        photoImage:(UIImage *)image
                    photoImageSize:(CGSize)photoImageSize;
@end


@interface PDPhotoViewController : PDTableViewController
<MGServerExchangeDelegate, PDItemSelectDelegate, MWPhotoBrowserDelegate, PDPhotoViewDelegate, TTTAttributedLabelDelegate>

@property (weak, nonatomic) id <PDPhotoViewControllerDataSource> photosDataSource;
@property (assign, nonatomic) BOOL fullscreenPhotoBrowserShown;
@property (strong, nonatomic) PDPhoto *photo;
@property (strong, nonatomic) NSMutableArray *tagButtons;
@property (strong, nonatomic) PDItemsTableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) UIImageView *snapshotImageView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *tagsView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *locationView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *descriptionView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *userView;
@property (weak, nonatomic) IBOutlet PDPhotoImageView *photoImage;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *poiView;
@property (weak, nonatomic) IBOutlet PDLinedButton *poiButton;
@property (weak, nonatomic) IBOutlet UIView *bottomToolbar;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapPreviewButton;
@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *photoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;
@property (weak, nonatomic) IBOutlet UIButton *nearbyPhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *likesCountButton;
@property (weak, nonatomic) IBOutlet UIButton *pinsCountButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsCountButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *pinButton;
@property (weak, nonatomic) IBOutlet UIButton *poiInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *slideBottomToolbarButton;
@property (weak, nonatomic) IBOutlet UIView *slideView;
@property (strong, nonatomic) IBOutlet PDPhotosView *poiPhotosView;
@property (strong, nonatomic) PDCollectionsViewController *collectionsViewController;

- (void)refreshCommentsCount;
- (IBAction)slideBottomBar:(id)sender;
- (IBAction)showPOIInfo:(id)sender;
- (IBAction)showUserProfile:(id)sender;
- (IBAction)pinPhoto:(id)sender;
- (IBAction)likePhoto:(id)sender;
- (IBAction)goToMap:(id)sender;
- (IBAction)editPhoto:(id)sender;
- (IBAction)showMoreDescription:(id)sender;
- (void)showFullSizePhotoView;
- (IBAction)showNearbyPhotos:(id)sender;
- (IBAction)sharePhoto:(id)sender;
- (IBAction)showLikingUsers:(id)sender;
- (IBAction)showPinnedUsers:(id)sender;
- (IBAction)showMoreComments:(id)sender;
- (IBAction)tagButtonTouch:(id)sender;
- (void)showBottomBarAnimated:(BOOL)animated;
- (void)hideBottomBarAnimated:(BOOL)animated;

@end
