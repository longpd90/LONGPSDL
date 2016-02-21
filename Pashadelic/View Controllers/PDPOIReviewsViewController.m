//
//  PDPOIReviewsViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDPOIReviewsViewController.h"

@interface PDPOIReviewsViewController ()
- (void)refreshUserReview;
- (void)setRating:(NSUInteger)rating;
- (NSArray *)loadReviewsFromResult:(NSArray *)result;
- (NSUInteger)rating;
@end

@implementation PDPOIReviewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	for (NSInteger i = 1; i <= 5; i++) {
		UIButton *button = (UIButton *) [self.ratingToolbarView viewWithTag:i];
		[button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateSelected|UIControlStateHighlighted];
	}
	
	self.rateLabel.text = NSLocalizedString(@"Rate it", nil);
	[self.reviewInfoButton setTitle:NSLocalizedString(@"You can only write review from the website", nil) forState:UIControlStateNormal];
	[self.reviewInfoButton addTarget:self action:@selector(reviewInfoButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
	self.reviewsTableView = [[PDReviewsTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.reviewsTableView.itemsTableDelegate = self;
	self.itemsTableView = self.reviewsTableView;
	self.reviewsTableView.autoresizingMask = kFullAutoresizingMask;
	[self.tablePlaceholderView addSubview:self.reviewsTableView];
	
    if (self.poiItem) {
		self.poiItem = self.poiItem;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPoiItem:(PDPOIItem *)poiItem
{
	_poiItem = poiItem;
	if (self.isViewLoaded) {

		[self refreshView];
		[self fetchData];
	}
}

- (NSString *)pageName
{
	return @"POI Reviews";
}

- (NSArray *)loadReviewsFromResult:(NSArray *)result
{
	NSMutableArray *reviews = [NSMutableArray array];
	for (NSDictionary *reviewInfo in result) {
		PDReview *review = [PDReview new];
		[review loadFromDictionary:reviewInfo];
		if (review.userID == kPDUserID) {
			[self setRating:review.rating];
		}
		review.itemDelegate = self;
		[reviews addObject:review];
	}
	return reviews;
}

- (void)setRating:(NSUInteger)rating
{
	for (NSInteger i = 1; i <= 5; i++) {
		UIButton *button = (UIButton *) [self.ratingToolbarView viewWithTag:i];
		button.selected = (i <= rating);
	}
}

- (IBAction)rateButtonTouch:(id)sender
{
	[kPDAppDelegate showWaitingSpinner];
	NSInteger rating = [sender tag];
	[self setRating:rating];
	self.serverRate = [[PDServerRatePOIItem alloc] initWithDelegate:self];
	[self.serverRate rateItem:self.poiItem withRating:rating];
}

- (IBAction)reviewInfoButtonTouch:(id)sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://" stringByAppendingString:kPDAppWebPage]]];
}

- (void)fetchData
{
	[super fetchData];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerPOIReviewsLoader alloc] initWithDelegate:self];
	}
	[self.serverExchange loadReviewsForItem:self.poiItem];
}

- (void)refreshUserReview
{
	BOOL needRefetch = YES;
	for (PDReview *review in self.items) {
		if (review.userID == kPDUserID) {
			needRefetch = NO;
			review.rating = self.rating;
			[self.reviewsTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.items indexOfObject:review] inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
			break;
		}
	}
	
	if (needRefetch) {
		[self refetchData];
	}
}

- (NSUInteger)rating
{
	NSInteger rating = 0;
	for (NSInteger i = 1; i <= 5; i++) {
		UIButton *button = (UIButton *) [self.ratingToolbarView viewWithTag:i];
		if (button.isSelected) {
			rating = i;
		}
	}
	return rating;
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleBlack;
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	[kPDAppDelegate hideWaitingSpinner];
	
	if ([serverExchange isKindOfClass:[PDServerPOIReviewsLoader class]]) {
		self.totalPages = [result intForKey:@"total_pages"];
		NSInteger reviewsCount = [result intForKey:@"total_count"];
		if (reviewsCount != self.poiItem.reviewsCount) {
			self.poiItem.reviewsCount = reviewsCount;
			NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:self.poiItem forKey:@"object"];
			[userInfo setObject:@[
			 @{@"value" : @(reviewsCount), @"key" : @"reviewsCount"}] forKey:@"values"];
			[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
																object:self.poiItem
															  userInfo:userInfo];

		}
		self.items = [self loadReviewsFromResult:result[@"rates"]];
		[self refreshView];
		
	} else if ([serverExchange isKindOfClass:[PDServerRatePOIItem class]]) {
		self.poiItem.rating = [result intForKey:@"average_rating"];
		[self refreshUserReview];
	}
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[super serverExchange:serverExchange didFailWithError:error];
	[kPDAppDelegate hideWaitingSpinner];
}

@end
