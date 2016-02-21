//
//  PDPlanInfoViewController.m
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/11/14.
//
//

#import <Social/Social.h>
#import <EventKit/EventKit.h>
#import "UIView+Extra.h"
#import "PDPlanInfoViewController.h"
#import "NSString+Date.h"
#import "PDServerJoinPlan.h"
#import "PDServerPlanDetailLoader.h"
#import "PDServerJoinPlan.h"
#import "PDPlanCommentsViewController.h"
#import "PDPlanMapViewController.h"
#import "PDMeViewController.h"
#import "PDUserViewController.h"
#import "PDPlanParticipantsViewController.h"

#define kPDBackgroundColor             [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1]
enum PDJoinPlanStatus {
    PDJoinPlanStatusFull = 0,
    PDJoinPlanStatusCanJoin,
    PDJoinPlanStatusJoined,
    PDJoinPlanStatusOwner
};

@interface PDPlanInfoViewController ()
@property (assign, nonatomic) NSInteger joinStatus;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSArray *eventList;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) NSMutableArray *comments;
@property (assign, nonatomic) float heighTableView;
@property (assign, nonatomic) CGPoint currentOffset;
@end

@implementation PDPlanInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initInteface];
    [self refreshView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.titleView = self.navigationBarView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setPlan:(PDPlan *)plan
{
    _plan = plan;
    [self fetchData];

}

#pragma mark - Public

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)fetchData
{
    [super fetchData];
    self.serverExchange = [[PDServerPlanDetailLoader alloc] initWithDelegate:self];
    [self.serverExchange loadPlanDetail:self.plan.identifier];
}

#pragma mark - Private

- (void)initInteface
{
    [self initNavagationBar];
    commentCellExample = [UIView loadFromNibNamed:@"PDCommentCell"];
    _commentTextView.placeholder = NSLocalizedString(@"Add comment...", nil);
    [self initPhotosTable];
    NSDictionary *whiteColorAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.dateTimeView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.dateTimeView.layer.borderWidth = 0.5f;
    self.descriptionPlan.scrollEnabled = NO;
    [self.angleImage setFontAwesomeIconForImage:[FAKFontAwesome angleRightIconWithSize:20] withAttributes:whiteColorAttribute];
    [self refreshParticipantsView];
}

- (void)initNavagationBar
{
    self.activityIndicatorView.hidden = YES;
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self.shareButton setFontAwesomeIconForImage:[FAKFontAwesome shareSquareIconWithSize:22]
                                        forState:UIControlStateNormal
                                      attributes:@{NSForegroundColorAttributeName:kPDGlobalGrayColor}];
}

- (void)initPhotosTable
{
	self.photosTableView = [[PDPhotosTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.photosTableView.itemsTableDelegate = self;
    [self.photosTableView setBackgroundColor:kPDBackgroundColor];
    self.itemsTableView = _photosTableView;
    [self.tablePlaceholderView addSubview:_photosTableView];
    _photosTableView.tableHeaderView = self.headerView;
}

- (void)showUserInfo:(PDUser *)user
{
    if (kPDUserID == user.identifier) {
        PDMeViewController *meViewController = [[PDMeViewController alloc] initWithNibName:@"PDMeViewController" bundle:nil];
        
        [self.navigationController pushViewController:meViewController animated:YES];
        [meViewController setIsLeftButtonToBack:YES];
    }
    else {
        PDUserViewController *userViewController = [[PDUserViewController alloc] initWithNibName:@"PDUserViewController" bundle:nil];
        userViewController.user = user;
        [self.navigationController pushViewController:userViewController animated:YES];
    }
}

#pragma mark - layout subview

- (void)layoutSubviews
{
    self.previewMapView.y = self.planToShootView.bottomYPoint + 30;
    self.organizerView.y = self.previewMapView.bottomYPoint + 25;
    self.participantsView.y = self.organizerView.bottomYPoint + 30;
    self.conversationView.y = self.participantsView.bottomYPoint + 30;
    self.headerView.height = self.conversationView.bottomYPoint;
    self.itemsTableView.tableHeaderView = self.headerView;
}

#pragma mark - refresh view

- (void)refreshView
{
    [self refreshNavigationBar];
    [self refreshPhotoPlanView];
    [self refreshPlanToShootView];
    [self refreshPreviewMap];
    [self refreshOrganizerView];
    [self refreshParticipantsView];
    [self refreshCommentView];
    [self layoutSubviews];
}

- (void)refreshNavigationBar
{
    
    if (kPDUserID == self.plan.userID) {
        self.joinStatus = PDJoinPlanStatusOwner;
    } else if (self.plan.capacity == self.plan.participantsCount) {
        for (int i = 0; i < self.plan.paticipants.count; i ++)
        {
            PDUser *user = (PDUser *)self.plan.paticipants[i];
            if (user.identifier == kPDUserID) {
                self.joinStatus = PDJoinPlanStatusJoined;
                break;
            } else self.joinStatus = PDJoinPlanStatusCanJoin;
        }
        if (self.joinStatus != PDJoinPlanStatusJoined) {
            self.joinStatus = PDJoinPlanStatusFull;
        }
    } else {
        for (int i = 0; i < self.plan.paticipants.count; i ++)
        {
            PDUser *user = (PDUser *)self.plan.paticipants[i];
            if (user.identifier == kPDUserID) {
                self.joinStatus = PDJoinPlanStatusJoined;
                break;
            } else self.joinStatus = PDJoinPlanStatusCanJoin;
        }
    }

    [self refreshJoinButton];
}

- (void)refreshJoinButton
{
    switch (self.joinStatus) {
        case PDJoinPlanStatusFull:
            self.joinButton.hidden = YES;
            self.leaveButton.hidden = YES;
            self.fullButton.hidden = NO;
            break;
        case PDJoinPlanStatusJoined:
            self.joinButton.hidden = YES;
            self.leaveButton.hidden = NO;
            self.fullButton.hidden = YES;
            break;
        case PDJoinPlanStatusCanJoin:
            self.joinButton.hidden = NO;
            self.leaveButton.hidden = YES;
            self.fullButton.hidden = YES;
            break;
        case PDJoinPlanStatusOwner:
            self.joinButton.hidden = YES;
            self.leaveButton.hidden = YES;
            self.fullButton.hidden = YES;
        default:
            break;
    }
    if (self.joinStatus == PDJoinPlanStatusJoined || self.joinStatus == PDJoinPlanStatusOwner) {
        self.addEvent.hidden = NO;
    } else self.addEvent.hidden = YES;
}


- (void)refreshPhotoPlanView
{
    self.photoPlanImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoPlanImageView.clipsToBounds = YES;
    
    NSURL *imageURL;
    if (self.plan.photo.fullImageURL == nil) {
        NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?"
                         "center=%f,%f"
                         "&zoom=%zd"
                         "&size=%zdx%zd"
                         "&scale=%zd"
                         "&sensor=false"
                         "&api_key=%@",
                         self.plan.latitude, self.plan.longitude,
                         12,
                         310, 180,
                         (NSInteger)[[UIScreen mainScreen] scale],
                         kPDGoogleMapsAPIToken];
        imageURL = [NSURL URLWithString:url];
    } else
        imageURL = self.plan.photo.fullImageURL;
    
    [self.photoPlanImageView sd_setImageWithURL:imageURL];
    
    NSDateFormatter *dateFormatter;
	if (!dateFormatter) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	}
	NSDate *date = [dateFormatter dateFromString:self.plan.time];
    
    self.dateLabel.text = [NSString stringSuffixDateWithDate:date dateFormatter:@"MMM d."];
    self.yearLabel.text = [NSString stringDate:date dateFormatter:@"YYYY"];
    self.timeLabel.text = [NSString stringDate:date dateFormatter:@"h:mma"];
    
    if (self.plan.address == nil || [self.plan.address isEqualToString:@""]) {
        self.addressLabel.text = [NSString stringWithFormat:@"%f, %f", self.plan.latitude, self.plan.longitude];
    } else
        self.addressLabel.text = self.plan.address;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    self.date = [dateFormatter dateFromString:self.plan.time];
}

- (void)refreshPlanToShootView
{
    self.titleLabel.text = self.plan.name;
    if ([self.plan.description isEqualToString:@""]) {
        self.planToShootView.height = self.titleLabel.bottomYPoint;
    } else {
        self.descriptionPlan.text = self.plan.description;
        CGSize newSize = [self.descriptionPlan sizeThatFits:CGSizeMake(self.descriptionPlan.width, MAXFLOAT)];
        self.descriptionPlan.height = newSize.height;
        self.planToShootView.height = self.descriptionPlan.bottomYPoint;
    }

    
}

- (void)refreshPreviewMap
{
    [self.previewMapImageView sd_setImageWithURL:[NSURL URLWithString:self.plan.mapImageURLString]];
}

- (void)refreshOrganizerView
{
    [self.creatorAvatar sd_setImageWithURL:self.plan.user.thumbnailURL];
    self.creatorAvatar.layer.cornerRadius = 5.0;
    self.creatorAvatar.layer.masksToBounds = YES;
    
    if (self.plan.user.userPhotoThumbnails.count == 0) {
        self.photosOfOwner.height = 0;
        self.ownerName.y = self.creatorAvatar.bottomYPoint + 20;
    } else {
        float heightPhoto = 45.0;
        self.photosOfOwner.height = heightPhoto;
        for (int i = 0; i < MIN(3, self.plan.user.userPhotoThumbnails.count); i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (heightPhoto + 2), 0, heightPhoto, heightPhoto)];
            
            PDPhoto *photo = [[PDPhoto alloc] init];
            [photo loadShortDataFromDictionary:(NSDictionary *)self.plan.user.userPhotoThumbnails[i]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView sd_setImageWithURL:photo.thumbnailURL];
            self.photosOfOwner.width = imageView.x + imageView.width;
            [self.photosOfOwner addSubview:imageView];
        }
        self.photosOfOwner.center = CGPointMake(self.organizerView.center.x, self.photosOfOwner.center.y);
        self.ownerName.y = self.photosOfOwner.bottomYPoint + 20;
    }
    self.numberPhotoAndFollowers.y = self.ownerName.bottomYPoint;
    NSString *photoString;
    NSString *followerString;
    if (self.plan.user.photosCount < 2) {
        photoString = NSLocalizedString(@"photo",nil);
    } else photoString = NSLocalizedString(@"photos",nil);
    if (self.plan.user.followersCount < 2) {
        followerString = photoString = NSLocalizedString(@"follower",nil);
    } else followerString = NSLocalizedString(@"followers",nil);
    self.numberPhotoAndFollowers.text = [NSString stringWithFormat:@"%@ %d / %@ %d", photoString, self.plan.user.photosCount, followerString, self.plan.user.followersCount];
    self.ownerName.text = [self.plan.user.name uppercaseString];
    self.organizerView.height = self.numberPhotoAndFollowers.bottomYPoint;
}

- (void)refreshParticipantsView
{
    int number = self.plan.paticipants.count;
    int row = (int)(number / 8) + 1;
    float size = 28.0;
    if (self.groupParticipants == nil) {
        self.groupParticipants = [[UIView alloc] initWithFrame:CGRectMake(0, 70, size, size)];
    }
    NSArray *viewsToRemove = [self.groupParticipants subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    
    [self.participantsView addSubview: self.groupParticipants];
    self.groupParticipants.backgroundColor = [UIColor clearColor];
    self.groupParticipants.width = (size + 1) * 8;
    self.groupParticipants.center = CGPointMake(self.participantsView.width / 2, self.groupParticipants.center.y);

    for (int i = 0; i < row; i ++) {
        int start = 8 * i;
        int end = 8 * (i + 1);
        float y = i * 29;
        if (end <= number) {
            [self createParticipantsWithY:y startIndex:start endIndex:end];
        } else {
            [self createParticipantsWithY:y startIndex:start endIndex:number];
        }
    }
    int left = _plan.capacity - _plan.participantsCount;
    if (left < 2) {
        self.participantsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d going / %d spot left", nil), _plan.participantsCount, left];
    } else self.participantsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d going / %d spots left", nil), _plan.participantsCount, left];
    
    self.participantsLabel.y = self.groupParticipants.bottomYPoint + 15;
    self.participantsView.height = self.participantsLabel.bottomYPoint + 30;
    self.showPaticipantButton.height = self.participantsView.height;
    [self.participantsView bringSubviewToFront:self.showPaticipantButton];
}

- (void)createParticipantsWithY:(float)y startIndex:(NSInteger)start endIndex:(NSInteger)end
{
    int d = 0;
    if (start == end) return;
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, y, 29 * (end - start), 29)];
    for (int i = start; i < end; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(d * 29, 0, 28, 28)];
        d++;
        PDUser *user = (PDUser *)self.plan.paticipants[i];
        [imageView sd_setImageWithURL:user.thumbnailURL];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 3;
        [subView addSubview:imageView];
    }
    subView.center = CGPointMake(self.groupParticipants.width/2, subView.center.y);
    self.groupParticipants.height = subView.bottomYPoint;
    [self.groupParticipants addSubview:subView];

}

- (void)refreshCommentView
{

    if (self.joinStatus == PDJoinPlanStatusJoined || self.joinStatus == PDJoinPlanStatusOwner) {
        self.addCommentView.hidden = NO;
    } else {
        self.addCommentView.hidden = YES;
    }
    [self.commentTableView reloadData];
    if (self.plan.commentsCount == 0) {
        _seeAll.hidden = YES;
        _seeAllLabel.hidden = YES;
    } else {
        _countCommentLabel.hidden = NO;
        _seeAllLabel.hidden = NO;
    }
    if (self.plan.commentsCount == 0) {
        self.countCommentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Have no any comment", nil)];
    } else if (self.plan.commentsCount > 1) {
        self.countCommentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"There are %d comments", nil), self.plan.commentsCount];
    } else {
        self.countCommentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"This is %d comment", nil), self.plan.commentsCount];;
    }

    self.conversationView.height = self.commentTableView.contentSize.height;
    self.seeAllConversation.height = self.conversationView.height - self.addCommentView.height;
}

#pragma mark - Comment tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return MIN(3, self.comments.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    commentCellExample.commentTextLabel.text = [[self.comments objectAtIndex:indexPath.row] comment];
    
	CGFloat newHeight = [commentCellExample.commentTextLabel sizeThatFits:
						 CGSizeMake(commentCellExample.commentTextLabel.bounds.size.width, MAXFLOAT)].height;
	
    self.heighTableView = self.heighTableView + commentCellExample.commentTextLabel.y + newHeight + 10;
	return commentCellExample.commentTextLabel.y + newHeight + 10 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CommentCellIdentifier = @"PDCommentCell";
	PDCommentCell *cell = (PDCommentCell *) [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
	if (!cell) {
		cell = [UIView loadFromNibNamed:CommentCellIdentifier];
		cell.delegate = self;
	}
    if (self.comments.count > indexPath.row) {
        cell.tag = indexPath.row;
        PDComment *comment = [self.comments objectAtIndex:indexPath.row];
        comment.itemDelegate = self;
        cell.comment = comment;
        [cell disableDeteleAndReply];
    }
	return cell;
}



#pragma mark - PDCommentCell delegate

- (void)commentWasDeleted:(PDComment *)comment
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.comments];
    [array removeObject:comment];
    self.plan.comments = array;
    self.comments = array;
    self.plan.commentsCount--;
    [self refreshView];
}
- (void)replyToUserComment:(PDComment *)comment atIndex:(int)intdex
{
}

#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self shareWithFacebook];
            break;
        }
        case 1:
        {
            [self shareWithTwitter];
            break;
        }
        default:
            break;
    }
}


#pragma mark - IBAction

- (IBAction)addEventToCalendar:(id)sender {
    if (!self.eventStore) {
        self.eventStore = [[EKEventStore alloc] init];
    }

    if ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            if (granted) {
                [self savePlanToCalendar:self.eventStore];
            }
        }];
    } else {
        [self savePlanToCalendar:self.eventStore];
    }
    
}

- (void)savePlanToCalendar:(EKEventStore *)eventStore
{
    BOOL existedPlan = [self checkExistedPlan];
    if (!existedPlan) {
        EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
        event.title     = self.plan.name;
        event.startDate = self.date;
        event.endDate   = [self.date dateByAddingTimeInterval:0];
        [event setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err;
        [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        [self performSelectorOnMainThread:@selector(showAlertWithMessage:)
                               withObject:@"This plan was added to calendar successfully"
                            waitUntilDone:YES];

    } else {
        [self performSelectorOnMainThread:@selector(showAlertWithMessage:)
                               withObject:@"Plan already created"
                            waitUntilDone:YES];
        
    }
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(message, nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}
- (BOOL)checkExistedPlan
{
    BOOL existedPlan;
    NSArray *events = [self fetchEventsFromDate:self.date];
    for (int i = 0; i < events.count; i ++) {
        EKEvent *event = (EKEvent *)events[i];
        if ([event.title isEqualToString:self.plan.name]) {
            existedPlan = YES;
            break;
        } else existedPlan = NO;
        
    }
    return existedPlan;
}

- (NSMutableArray *)fetchEventsFromDate:(NSDate *)startDate
{
    NSDateComponents *tomorrowDateComponents = [[NSDateComponents alloc] init];
    tomorrowDateComponents.minute = 1;
	
    NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:tomorrowDateComponents
                                                                    toDate:startDate
                                                                   options:0];
    EKCalendar *defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
	NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
    
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate
                                                                      endDate:endDate
                                                                    calendars:calendarArray];
	NSMutableArray *events = [NSMutableArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
    
	return events;
}

- (IBAction)sharePhoto:(id)sender {
    [self shareAction];
}

- (IBAction)joinPlan:(id)sender {
    self.serverExchange = [[PDServerJoinPlan alloc] initWithDelegate:self];
    [self.serverExchange joinUnjoinPlan:self.plan];
    self.activityIndicatorView.hidden = NO;
}

- (IBAction)leavePlan:(id)sender {

    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:nil
                               message:NSLocalizedString(@"Do you really want to leave this plan?", nil)
                              delegate:self
                     cancelButtonTitle:NSLocalizedString(@"No", nil)
                     otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    alertView.tag = 1;
    [alertView show];
}

- (IBAction)showDetailMapView:(id)sender {
    PDPlanMapViewController *mapViewController = [[PDPlanMapViewController alloc] initForUniversalDevice];
    mapViewController.plan = self.plan;
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)seeAllConversation:(id)sender {
    if (self.plan.commentsCount == 0 ) return;
	PDPlanCommentsViewController *commentsViewController = [[PDPlanCommentsViewController alloc] initForUniversalDevice];
    commentsViewController.plan = self.plan;
	[self.navigationController pushViewController:commentsViewController animated:YES];
}

- (IBAction)sendComment:(id)sender {
    
    if (![self validateData]) return;
	[kPDAppDelegate showWaitingSpinner];
	[self trackEvent:@"Comment"];
	PDServerComment *serverComment = [[PDServerComment alloc] initWithDelegate:self];
	self.serverExchange = serverComment;
    [serverComment commentPlan: self.plan text:_commentTextView.text];
    
}

- (IBAction)showUser:(id)sender {
    [self showUserInfo:_plan.user];
}

- (IBAction)showListParticipants:(id)sender {
    PDPlanParticipantsViewController *participantsViewController = [[PDPlanParticipantsViewController alloc] initForUniversalDevice];
    participantsViewController.plan = self.plan;
    [participantsViewController fetchData];
    [self.navigationController pushViewController:participantsViewController animated:YES];
}

- (BOOL)validateData
{
	if (self.commentTextView.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter comment text", nil)];
		return NO;
	}
	
	return YES;
}

- (void)shareAction
{
    if (!_shareActionSheet) {
        _shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:NSLocalizedString(@"Share on Facebook",nil), NSLocalizedString(@"Share on Twitter", nil), nil];
    }
    [_shareActionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)shareWithFacebook
{
	SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
	[facebookController setInitialText:NSLocalizedString(@"Share Plan", nil)];
	NSString *sharePlanURL = [kPDSharePlanURL stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.plan.identifier]];
	[facebookController addURL:[NSURL URLWithString:sharePlanURL]];
	[self presentViewController:facebookController animated:YES completion:nil];
    [self trackEvent:@"Share Facebook"];
}

- (void)shareWithTwitter
{
	NSString *sharePlanURL = [kPDSharePlanURL stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.plan.identifier]];
	SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
	[twitterController addImage:self.photoPlanImageView.image];
	[twitterController setInitialText:sharePlanURL];
	[self presentViewController:twitterController animated:YES completion:nil];
    
    [self trackEvent:@"Share Twitter"];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (!self.view.window) return;
    CGRect frame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardY = self.view.height - frame.size.height - self.conversationView.height;
    float deltaCommentView = self.conversationView.y - self.itemsTableView.contentOffset.y;
    float delta = deltaCommentView - keyboardY;
	double duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	self.keyboardShown = YES;
    self.currentOffset = self.itemsTableView.contentOffset;
    CGPoint newOffSet = CGPointMake(0, self.itemsTableView.contentOffset.y + delta + 4);
    
	[UIView animateWithDuration:duration animations:^{
		[self.itemsTableView setContentOffset:newOffSet animated:YES];
		[self viewWillLayoutSubviews];
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (!self.view.window) return;
    
	double duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	self.keyboardShown = NO;
    
    CGPoint newOffset = CGPointMake(0, self.currentOffset.y);
	[UIView animateWithDuration:duration animations:^{
        [self.itemsTableView setContentOffset:newOffset animated:YES];
		[self viewWillLayoutSubviews];
	}];
    
}

- (void)textViewDidChange:(UITextView *)textView
{
	int linesNumber = textView.contentSize.height / textView.font.lineHeight;
	if (linesNumber > 3) {
		linesNumber = 3;
	}
	
	if (addCommentLinesNumber != linesNumber) {
		addCommentLinesNumber = linesNumber;
	}
    [self.commentTableView reloadData];
}


#pragma mark - ServerExchange Delegate

- (void)serverExchange:(id)serverExchange didParseResult:(id)result
{
    [super serverExchange:serverExchange didParseResult:result];
    self.loading = NO;
    self.itemsTableView.tableViewState = PDItemsTableViewStateNormal;
    if ([serverExchange isKindOfClass:[PDServerPlanDetailLoader class]]) {
        [self.plan loadDataFromDictionary:result];
        self.comments = (NSMutableArray *)self.plan.comments;
        [self refreshView];
    } else if ([serverExchange isKindOfClass:[PDServerJoinPlan class]]) {
        if (self.joinStatus == PDJoinPlanStatusJoined) {
            self.joinStatus = PDJoinPlanStatusCanJoin;
            [self removeUserInParticipants];
        } else {
            self.joinStatus = PDJoinPlanStatusJoined;
            [self addUserToParticipants];
        }
        self.activityIndicatorView.hidden = YES;
        [self refreshJoinButton];
        [self refreshParticipantsView];
        [self refreshCommentView];
    }  else if ([serverExchange isKindOfClass:[PDServerComment class]]) {
		[kPDAppDelegate hideWaitingSpinner];
		[_commentTextView resignFirstResponder];
		PDComment *comment = [[PDComment alloc] init];
		comment.plan = _plan;
		[comment loadFullDataFromDictionary:[result objectForKey:@"comment"]];
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.comments];
		[array insertObject:comment atIndex:0];
		self.comments = array;
		_plan.commentsCount++;
		_commentTextView.text = nil;
		[self textViewDidChange:_commentTextView];
        
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:_plan forKey:@"object"];
		[userInfo setObject:@[
                              @{@"value" : _plan.comments, @"key" : @"comments"},
                              @{@"value" : [NSNumber numberWithInteger:_plan.commentsCount], @"key" : @"commentsCount"}] forKey:@"values"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
															object:self
														  userInfo:userInfo];
        [self refreshView];
    }
}

- (void)removeUserInParticipants
{
    NSMutableArray *mutableParticipants = [NSMutableArray arrayWithArray:self.plan.paticipants];
    for (PDUser *user in mutableParticipants) {
        if (user.identifier == kPDUserID) {
            [mutableParticipants removeObject:user];
            break;
        }
    }
    self.plan.participantsCount --;
    self.plan.paticipants = [NSArray arrayWithArray:mutableParticipants];
}

- (void)addUserToParticipants
{
    NSMutableArray *mutableParticipants = [NSMutableArray arrayWithArray:self.plan.paticipants];
    [mutableParticipants addObject:kPDUserProfile];
    self.plan.participantsCount ++;
    self.plan.paticipants = [NSArray arrayWithArray:mutableParticipants];
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.activityIndicatorView.hidden = NO;
        self.serverExchange = [[PDServerJoinPlan alloc] initWithDelegate:self];
        [self.serverExchange joinUnjoinPlan:self.plan];
    }
}

@end
