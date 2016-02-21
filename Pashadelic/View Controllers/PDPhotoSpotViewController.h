//
//  PDPhotoDetailViewController.h
//  Pashadelic
//
//  Created by LongPD on 6/2/14.
//
//

#import "PDUsersView.h"
#import "PDTableViewController.h"
#import "MWPhotoBrowser.h"
#import "PDPhotoImageView.h"
#import "TTTAttributedLabel.h"
#import "PDLinedButton.h"
#import "PDPhotoViewGroup.h"
#import "PDCollectionsViewController.h"
#import "PDPhotosTableView.h"
#import "PDCommentCell.h"
#import "PDPhotoTipsView.h"
#import "PDTipDescription.h"
#import <MapKit/MapKit.h>
#import "PDServerPhotoLoader.h"
#import "PDServerLike.h"
#import "PDServerPin.h"
#import "PDPhotoViewGroup.h"
#import "PDPhotoMapViewController.h"
#import "PDPhotosView.h"
#import "PDPhotoPinnedUsersViewController.h"
#import "PDPhotoLikingUsersViewController.h"
#import "PDPhotoInfoViewController.h"
#import "PDServerComment.h"
#import "PDServerFollowItem.h"
#import "PDDynamicFontButton.h"
#import "PDDynamicSizeButton.h"
#import "PDShadowView.h"
#import "PDCommentsViewController.h"

enum PDBackgroudColor {
	PDGrayBackgroudColor = 0,
    PDWhiteBackgroudColor
};

#define kPDMaxDesctiptionHeight 68

@class PDPhotoSpotViewController;
@class PDTagViewController;
@class PDPOIItemViewController;
@class PDPhotoTableViewController;


@protocol PDPhotoSpotViewControllerDataSource <NSObject>
- (NSUInteger)numberOfPhotosFor:(PDPhotoSpotViewController *)photoViewController;
- (NSUInteger)indexOfPhoto:(PDPhoto *)photo forPhotoViewController:(PDPhotoSpotViewController *)photoViewController;
- (PDPhoto *)photoAtIndex:(NSUInteger)index forPhotoViewController:(PDPhotoSpotViewController *)photoViewController;
- (void)dismissPhotoViewController:(PDPhotoSpotViewController *)photoViewController
                         withPhoto:(PDPhoto *)photo
                        photoImage:(UIImage *)image
                    photoImageSize:(CGSize)photoImageSize;
- (void)didDeletePhoto;

@end

@interface PDPhotoSpotViewController : PDTableViewController
<MGServerExchangeDelegate, PDItemSelectDelegate, MWPhotoBrowserDelegate, TTTAttributedLabelDelegate,
PDCommentsViewControllerDelegate, PDPhotoImageViewDelegate, UIActionSheetDelegate, PDPhotoViewDelegate, PDCommentCellDelegate, PDPhotoTipsViewDelegate> {
    PDCommentCell *commentCellExample;
	int addCommentLinesNumber;
}

@property (strong, nonatomic) NSMutableArray *locations; 

@property (assign, nonatomic) int tipSelecting;
@property (strong, nonatomic) PDTipDescription *tipDescription;
@property (nonatomic, retain) PDComment *replyComment;
@property (strong, nonatomic) PDPhotosTableView *photosTableView;
@property (weak, nonatomic) id <PDPhotoSpotViewControllerDataSource> photosDataSource;
@property (strong, nonatomic) PDPhoto *photo;
@property (strong, nonatomic) PDCollectionsViewController *collectionsViewController;
@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) UIActionSheet *shareActionSheet;
@property (strong, nonatomic) UIActionSheet *editPhotoActionSheet;
@property (strong, nonatomic) UIActionSheet *reportPhotoActionSheet;
@property (strong, nonatomic) UIImageView *snapshotImageView;
@property (strong, nonatomic) PDPhotoSpotViewController *photoViewController;
@property (strong, nonatomic) UIView *fadeView;
@property (strong, nonatomic) UIImageView *photoThumbnailImageView;
@property (assign, nonatomic) NSUInteger initialPhotoIndex;
@property (assign, readwrite, nonatomic) CGRect initialPhotoThumbnailViewFrame;
@property (assign, nonatomic) BOOL fullscreenPhotoBrowserShown;
@property (assign, nonatomic) CGPoint currentOffset;
@property (assign, nonatomic) BOOL changeBackgroundColor;
@property (weak, nonatomic) IBOutlet PDPhotoImageView *photoImage;

// time group View
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

// photo tile group View
@property (weak, nonatomic) IBOutlet UIView *photoTitleView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *photoTileLabel;
@property (weak, nonatomic) IBOutlet UIButton *editPhotoButton;

// photo description group view
@property (weak, nonatomic) IBOutlet PDShadowView *shadowDescriptionView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *descriptionView;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *photoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;

// photo map group view
@property (weak, nonatomic) IBOutlet UIView *placeHolderCommentTableView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *photoCoutOwnerLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *followersContOwnerLabel;
@property (weak, nonatomic) IBOutlet PDShadowView *shadowMapview;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *mapView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *backgroundMapview;
@property (weak, nonatomic) IBOutlet UIButton *mapPreviewButton;
@property (weak, nonatomic) IBOutlet UIView *viewInMapView;
@property (weak, nonatomic) IBOutlet UIView *tipPreview;
@property (weak, nonatomic) IBOutlet UIImageView *arrowRightTipImageView;
@property (weak, nonatomic) IBOutlet UIView *tipsBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *angleLeftTipView;
@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *showTipsLabel;

//photo landmark group view
@property (weak, nonatomic) IBOutlet PDShadowView *shadowLandmarkView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *landmarkView;
@property (weak, nonatomic) IBOutlet UIImageView *landmarkAvatar;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *landmarkNameLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *photoCountLandmarkLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *userCountLandmarkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowRightLandMarkImageView;

//photo exif group view
@property (weak, nonatomic) IBOutlet PDShadowView *shadowExifView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *exifView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *manufacterrLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *cameraLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *lenLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *filterLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *isoSpeedRatingLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *focalLengtLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *apertureLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *shutterSpeedLabel;
@property (weak, nonatomic) IBOutlet PDLinedButton *manufacterButton;
@property (weak, nonatomic) IBOutlet PDLinedButton *cameraButton;

//photo tag group view
@property (weak, nonatomic) IBOutlet PDShadowView *shadowTagBackgroundView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *tagsBackgroudView;
@property (weak, nonatomic) IBOutlet UIView *tagsView;
@property (weak, nonatomic) IBOutlet UIButton *showMoreTagButton;

//photo like collect view
@property (weak, nonatomic) IBOutlet PDShadowView *shadowLikeCollectView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *likeCollectView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectCountLabel;
@property (weak, nonatomic) IBOutlet PDUsersView *likePhotosView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *seeAllCollectLabel;
@property (weak, nonatomic) IBOutlet PDUsersView *collectsPhotoView;
@property (weak, nonatomic) IBOutlet UIButton *likesCountButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *seeAllLikeLabel;
@property (weak, nonatomic) IBOutlet UIButton *pinsCountButton;

//photo comment group view
@property (weak, nonatomic) IBOutlet PDPhotosView *ownerPhotosView;
@property (weak, nonatomic) IBOutlet PDShadowView *shadowCommentView;
@property (weak, nonatomic) IBOutlet PDPhotoViewGroup *commentView;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) IBOutlet UIView *commentTableHeaderView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *countCommentLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *seeAllLabel;
@property (strong, nonatomic) IBOutlet UIView *placeholderComment;
@property (weak, nonatomic) IBOutlet UIView *writeCommentView;
@property (weak, nonatomic) IBOutlet SSTextView *commentTextView;
@property (weak, nonatomic) IBOutlet PDGradientButton *sendButton;

//explorer group view
@property (weak, nonatomic) IBOutlet UIView *explorerView;
@property (weak, nonatomic) IBOutlet UIButton *angleExplorer;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *photoSpotNearbyLabel;
@property (weak, nonatomic) IBOutlet UIButton *showNearbyPhotoButton;

//content view
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;

//navigation bar view
@property (strong, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet PDDynamicSizeButton *pinButton;

- (IBAction)editPhotoTouches:(id)sender;
- (IBAction)sharePhoto:(id)sender;
- (IBAction)pinPhoto:(id)sender;
- (IBAction)likePhoto:(id)sender;
- (IBAction)showPOIInfo:(id)sender;
- (IBAction)goToMap:(id)sender;
- (IBAction)showTip:(id)sender;
- (IBAction)hiddenTips:(id)sender;
- (IBAction)showUserDetail:(id)sender;
- (IBAction)showHiddenNearbyPhoto:(id)sender;
- (IBAction)sendComment:(id)sender;
- (IBAction)showMoreComments:(id)sender;
- (IBAction)showLikingUsers:(id)sender;
- (IBAction)showPinnedUsers:(id)sender;
- (IBAction)showMoreDescription:(id)sender;
- (IBAction)showManufacterTags:(id)sender;
- (IBAction)showCameraTags:(id)sender;
- (IBAction)showMoreTag:(id)sender;
- (IBAction)scrollToComment:(id)sender;

@end
