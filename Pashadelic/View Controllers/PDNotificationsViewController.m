//
//  PDNotificationsViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 20.04.13.
//
//

#import "PDNotificationsViewController.h"
#import "PDPlanInfoViewController.h"

#define MaxSizeWith         1000
@interface PDNotificationsViewController (Private)
- (void)refreshTitle;
@end

@implementation PDNotificationsViewController

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
    self.photosTableView.scrollsToTop = NO;

	[self setLeftButtonToMainMenu];
	self.title = NSLocalizedString(@"Notifications", nil);
	[self initNotificationTableView];
	self.notificationsCountLabel.layer.cornerRadius = 8;
	[self refreshView];
	[self refetchData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Notifications";
}

- (void)initNotificationTableView
{
    self.notificationTableView = [[PDNotificationsTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.notificationTableView.itemsTableDelegate = self;
	self.notificationTableView.photoViewDelegate = self;
    self.notificationTableView.planViewDelegate = self;
	self.itemsTableView = self.notificationTableView;
	[self.tablePlaceholderView addSubview:_notificationTableView];
}

- (void)fetchData
{
	[super fetchData];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerNotificationsLoader alloc] initWithDelegate:self];
	}
	[self.serverExchange loadNotifications:self.currentPage];
}

- (void)showMainMenu
{
	[super showMainMenu];
	self.userViewController = nil;
}

- (void)refreshView
{
	self.unreadItemsCount = [PDUnreadItemsManager instance].unreadItemsCount;
	[super refreshView];
	[self refreshTitle];
}

- (void)setUnreadItemsCount:(NSInteger)newUnreadItemsCount
{
    _unreadItemsCount = newUnreadItemsCount;
    if (_unreadItemsCount > MaxThreeDigitsNumber) {
        _unreadItemsCount = MaxThreeDigitsNumber;
    }
}

- (void)refreshTitle
{
	self.unreadItemsCount = [PDUnreadItemsManager instance].unreadItemsCount;
	if (self.unreadItemsCount == 0) {
		self.titleFirstLabel.text = NSLocalizedString(@"There are no new notifications", nil);
		self.titleFirstLabel.frame = self.toolbarView.zeroPositionFrame;
		self.titleFirstLabel.textAlignment = NSTextAlignmentCenter;
		self.titleSecondLabel.hidden = YES;
		self.notificationsCountLabel.hidden = YES;
			
	} else {
		self.titleFirstLabel.textAlignment = NSTextAlignmentLeft;
		self.titleSecondLabel.hidden = NO;
		self.notificationsCountLabel.hidden = NO;
		self.titleFirstLabel.text = NSLocalizedString(@"There are", nil);
		[self.titleFirstLabel sizeToFit];
        self.titleFirstLabel.x = 70;
		
		self.notificationsCountLabel.x = self.titleFirstLabel.rightXPoint + 5;
		self.notificationsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.unreadItemsCount];
		[self.notificationsCountLabel sizeToFit];
		self.notificationsCountLabel.width += 8;
		
		self.titleSecondLabel.x = self.notificationsCountLabel.rightXPoint + 5;
		self.titleSecondLabel.text = NSLocalizedString(@"new notifications", nil);
		[self.titleSecondLabel sizeToFit];

		self.toolbarView.width = self.titleSecondLabel.rightXPoint;
		self.toolbarView.x = (self.view.width - self.toolbarView.width) / 2;
	}
}

- (void)showUser:(PDUser *)user
{
	if (!self.userViewController) {
		self.userViewController = [[PDUserViewController alloc] initWithNibName:@"PDUserViewController" bundle:nil];
	}
	self.userViewController.user = user;
	[self.navigationController pushViewController:self.userViewController animated:YES];
}

- (void)photo:(PDPhoto *)photo didSelectInView:(UIView *)view image:(UIImage *)image
{
	self.selectedPhoto = photo;
	[self showPhoto:photo];
}

- (void)showPlan:(PDPlan *)plan
{
    PDPlanInfoViewController *planInfoViewController = [[PDPlanInfoViewController alloc] initForUniversalDevice];
    planInfoViewController.plan = plan;
    [self.navigationController pushViewController:planInfoViewController animated:YES];
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
    self.totalPages = [result intForKey:@"total_page"];
	self.items = [serverExchange loadNotificationItemsFromArray:result[@"feeds"]];
	[self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj setItemDelegate:self];
	}];
	[[PDUnreadItemsManager instance] reset];
	[PDUnreadItemsManager instance].unreadItemsCount = [result intForKey:@"count"];
	[self refreshView];
}

#pragma mark - Photo view data source

- (NSUInteger)numberOfPhotosFor:(PDPhotoSpotViewController *)photoViewController
{
  return 1;
}

- (NSUInteger)indexOfPhoto:(PDPhoto *)photo forPhotoViewController:(PDPhotoSpotViewController *)photoViewController
{
  return 0;
}

- (PDPhoto *)photoAtIndex:(NSUInteger)index forPhotoViewController:(PDPhotoSpotViewController *)photoViewController
{
	if (index == 0) {
		return self.selectedPhoto;
	} else {
		return nil;
	}
}

- (void)dismissPhotoViewController:(PDPhotoSpotViewController *)photoViewController withPhoto:(PDPhoto *)photo photoImage:(UIImage *)image photoImageSize:(CGSize)photoImageSize
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
