//
//  PDPlanInfoViewController.h
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/11/14.
//
//

#import "PDTableViewController.h"
#import "PDDynamicFontButton.h"
#import "PDItemsTableView.h"
#import "PDPhotosTableView.h"
#import "SSTextView.h"
#import "PDCommentCell.h"
#import "PDPlan.h"
#import "PDPlanCommentsViewController.h"

@interface PDPlanInfoViewController : PDTableViewController<PDCommentCellDelegate, UIActionSheetDelegate,UIAlertViewDelegate,MGServerExchangeDelegate,PDItemsTableDelegate> {
    PDCommentCell *commentCellExample;
    int addCommentLinesNumber;
}
@property (strong, nonatomic) PDPlan *plan;
@property (strong, nonatomic) PDPhotosTableView *photosTableView;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;

// Navigation bar view
@property (strong, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *addEvent;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *joinButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *leaveButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *fullButton;

// Plan info view
@property (strong, nonatomic) IBOutlet UIView *headerView;

// Photo of plan group view
@property (weak, nonatomic) IBOutlet UIView *planPhotoView;
@property (weak, nonatomic) IBOutlet UIImageView *photoPlanImageView;

@property (weak, nonatomic) IBOutlet UIView *dateTimeView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *yearLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *dateLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

// plan to shoot group view
@property (weak, nonatomic) IBOutlet UIView *planToShootView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionPlan;

// Map Preview group
@property (weak, nonatomic) IBOutlet UIView *previewMapView;
@property (weak, nonatomic) IBOutlet UIImageView *previewMapImageView;
@property (weak, nonatomic) IBOutlet UIImageView *angleImage;

// Organizer group view
@property (weak, nonatomic) IBOutlet UIView *organizerView;
@property (weak, nonatomic) IBOutlet UIImageView *creatorAvatar;
@property (weak, nonatomic) IBOutlet UIView *photosOfOwner;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *numberPhotoAndFollowers;

// Participants group View
@property (weak, nonatomic) IBOutlet UIView *participantsView;
@property (strong, nonatomic) UIView *groupParticipants;
@property (weak, nonatomic) IBOutlet UILabel *participantsLabel;
@property (weak, nonatomic) IBOutlet UIButton *showPaticipantButton;

// Conversation group view
@property (weak, nonatomic) IBOutlet UIView *conversationView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *seeAll;
@property (weak, nonatomic) IBOutlet UIButton *seeAllLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *countCommentLabel;
@property (weak, nonatomic) IBOutlet UIButton *seeAllConversation;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *commentHeaderView;
@property (weak, nonatomic) IBOutlet UIView *addCommentView;
@property (weak, nonatomic) IBOutlet SSTextView *commentTextView;

@property (strong, nonatomic) UIActionSheet *shareActionSheet;
- (IBAction)addEventToCalendar:(id)sender;

- (IBAction)sharePhoto:(id)sender;

- (IBAction)joinPlan:(id)sender;

- (IBAction)leavePlan:(id)sender;

- (IBAction)showDetailMapView:(id)sender;
- (IBAction)seeAllConversation:(id)sender;

- (IBAction)sendComment:(id)sender;

- (IBAction)showUser:(id)sender;

- (IBAction)showListParticipants:(id)sender;

@end
