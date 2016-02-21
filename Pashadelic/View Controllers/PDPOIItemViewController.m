//
//  PDGeoTagViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.05.13.
//
//

#import "PDPOIItemViewController.h"
#import "UIImage+Extra.h"

@interface PDPOIItemViewController ()
@end

@implementation PDPOIItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[self setRightBarButtonToImage:[UIImage imageNamed:@"btn-info.png"]
                            offset:CGSizeMake(3, -3)
                        withAction:@selector(showMenu:)];
    	UIImage *blackImage = [[[UIImage alloc] init] imageWithColor:[UIColor blackColor]];
	self.reviewsButton.clipsToBounds = YES;
	self.reviewsButton.layer.cornerRadius = 4;
	[self.reviewsButton setBackgroundImage:blackImage forState:UIControlStateSelected];
	[self.reviewsButton setBackgroundImage:blackImage forState:UIControlStateSelected|UIControlStateHighlighted];
	self.followersButton.clipsToBounds = YES;
	self.followersButton.layer.cornerRadius = 4;
	[self.followersButton setBackgroundImage:blackImage forState:UIControlStateSelected];
	[self.followersButton setBackgroundImage:blackImage forState:UIControlStateSelected|UIControlStateHighlighted];
	
	self.locationButton.titleLabel.numberOfLines = 2;
	[self.sortTypeButton setGrayGradientButtonStyle];
    [self.sortTypeButton setTitle:NSLocalizedString(@"popular", nil) forState:UIControlStateNormal];
    [self.sortTypeButton setTitle:NSLocalizedString(@"date", nil) forState:UIControlStateSelected];
	self.sortTypeButton.layer.cornerRadius = 3;
	[self.sortTypeButton setTitleColor:[self.sortTypeButton titleColorForState:UIControlStateSelected] forState:UIControlStateSelected|UIControlStateHighlighted];

	if (self.poiItem) {
		self.poiItem = self.poiItem;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	self.poiItem = nil;
	[self setPhotosCountButton:nil];
	[self setSortTypeButton:nil];
	[self setFollowButton:nil];
	[self setToolbarView:nil];
	[self setLocationButton:nil];
	[self setPoiImageView:nil];
    [self setRatingView:nil];
    [self setReviewsButton:nil];
    [self setFollowersButton:nil];
	[self setBottomBarButton:nil];
	[self setBottomBarContentView:nil];
	[self setBottomBarView:nil];
	[super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.customNavigationBar.titleButton.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	self.viewDeckController.rightController = nil;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self.poiImageView resizeToFitWithImageSize:CGSizeMake(self.poiItem.photo.photoWidth, self.poiItem.photo.photoHeight)
										maxViewSize:CGSizeMake(self.view.width, MAXFLOAT)];
	self.toolbarView.height = self.poiImageView.height + self.sortTypeButton.height + 8;
}


#pragma mark - Override

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleBlack;
}

- (NSString *)pageName
{
	return @"POI";
}

- (void)setPoiItem:(PDPOIItem *)poiItem
{
	_poiItem = poiItem;
	self.followButton.item = poiItem;
	if (self.isViewLoaded) {
		[self viewWillLayoutSubviews];
		[self.poiImageView showActivityWithStyle:UIActivityIndicatorViewStyleWhiteLarge color:[UIColor grayColor]];
		[self.poiImageView sd_setImageWithURL:self.poiItem.photo.fullImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			[self.poiImageView hideActivity];
		}];
		[self refreshView];
		[self refetchData];
		[self hideBottomBarAnimated:NO];
		self.itemsTableView.contentOffset = CGPointZero;
	}
}

- (void)fetchData
{
	[super fetchData];
	NSString *sorting = (self.sortTypeButton.isSelected) ? @"date" : @"popular";
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerGeoTagLoader alloc] initWithDelegate:self];
	}
	
	[self.serverExchange loadGeoTagInfo:self.poiItem sorting:sorting page:self.currentPage];
}

- (void)refreshView
{
	[super refreshView];
	[self.photosCountButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"%d photos", nil), self.poiItem.totalCount]
													   forState:UIControlStateNormal];
	[self.locationButton setTitle:self.poiItem.location forState:UIControlStateNormal];
	[self.followButton refreshButton];
	[self.followersButton setTitle:[self.poiItem countValueInString:self.poiItem.followersCount] forState:UIControlStateNormal];
	[self.reviewsButton setTitle:[self.poiItem countValueInString:self.poiItem.reviewsCount] forState:UIControlStateNormal];

	[self.ratingView setRating:self.poiItem.rating];
	self.title = self.poiItem.title;
}

- (void)showMenu:(id)sender
{
	if (!self.infoViewController) {
		self.infoViewController = [[PDPOIInfoViewController alloc] initWithNibName:@"PDPOIInfoViewController" bundle:nil];
	}
	self.viewDeckController.rightSize = 40;
	self.infoViewController.poiItem = self.poiItem;
	self.viewDeckController.rightController = self.infoViewController;
	[self.viewDeckController toggleRightViewAnimated:YES];
}

- (IBAction)changeSorting:(id)sender
{
	self.sortTypeButton.selected = !self.sortTypeButton.selected;
	[self refetchData];
}

- (IBAction)showReviews:(id)sender
{
	if ([self.childViewControllers.lastObject isKindOfClass:[PDPOIReviewsViewController class]]) return;
	
	self.followersButton.selected = NO;
	self.reviewsButton.selected = YES;
	[[self.childViewControllers.lastObject view] removeFromSuperview];
	[self.childViewControllers.lastObject removeFromParentViewController];
	
	if (!self.reviewsViewController) {
		self.reviewsViewController = [[PDPOIReviewsViewController alloc] initForUniversalDevice];
	}
	self.reviewsViewController.poiItem = self.poiItem;
	[self addChildViewController:self.reviewsViewController];
	[self showBottomBarAnimated:YES];
	self.reviewsViewController.view.frame = self.bottomBarContentView.zeroPositionFrame;
	[self.bottomBarContentView addSubview:self.reviewsViewController.view];
}

- (IBAction)showFollowers:(id)sender
{
	if (self.poiItem.followersCount == 0 || [self.childViewControllers.lastObject isKindOfClass:[PDPOIFollowersViewController class]]) return;
	
	self.followersButton.selected = YES;
	self.reviewsButton.selected = NO;
	[[self.childViewControllers.lastObject view] removeFromSuperview];
	[self.childViewControllers.lastObject removeFromParentViewController];

	if (!self.followersViewController) {
		self.followersViewController = [[PDPOIFollowersViewController alloc] initForUniversalDevice];
	}
	self.followersViewController.poiItem = self.poiItem;
	[self addChildViewController:self.followersViewController];
	[self showBottomBarAnimated:YES];
	self.followersViewController.view.frame = self.bottomBarContentView.zeroPositionFrame;
	[self.bottomBarContentView addSubview:self.followersViewController.view];
}

- (void)itemWasChanged:(NSNotification *)notification
{
	[super itemWasChanged:notification];
	NSDictionary *userInfo = notification.userInfo;
	PDItem *object = [userInfo objectForKey:@"object"];
	
	if ([self.poiItem isEqual:object]) {
		[self.poiItem setValuesFromArray:userInfo[@"values"]];
		self.needRefreshView = YES;
		
	}
	
	if (self.view.window && self.needRefreshView) {
		[self refreshWithoutScrollToTop];
	}
    
}

- (IBAction)toggleBottomBar:(id)sender
{
	if (self.bottomBarButton.isSelected) {
		[self hideBottomBarAnimated:YES];
	} else {
		[self showReviews:nil];
	}
}

- (void)showBottomBarAnimated:(BOOL)animated
{
	self.bottomBarButton.selected = YES;
	self.bottomBarView.height = self.view.height;
	if (animated) {
		[UIView animateWithDuration:0.2 animations:^{
			self.bottomBarView.y = 0;
		}];
	} else {
		self.bottomBarView.y = 0;
	}
}

- (void)hideBottomBarAnimated:(BOOL)animated
{
	self.reviewsButton.selected = NO;
	self.followersButton.selected = NO;
	self.bottomBarButton.selected = NO;
	
	if (animated) {
		[UIView animateWithDuration:0.2 animations:^{
			self.bottomBarView.y = self.view.height - self.bottomBarContentView.y;
		} completion:^(BOOL finished) {
			self.bottomBarView.height = self.bottomBarContentView.y;
			[[self.childViewControllers.lastObject view] removeFromSuperview];
			[self.childViewControllers.lastObject removeFromParentViewController];
			[self viewWillAppear:NO];
		}];
	} else {
		self.bottomBarView.y = self.view.height - self.bottomBarContentView.y;
		self.bottomBarView.height = self.bottomBarContentView.y;
		[[self.childViewControllers.lastObject view] removeFromSuperview];
		[self.childViewControllers.lastObject removeFromParentViewController];
		[self viewWillAppear:NO];
	}
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if ([serverExchange isKindOfClass:[PDServerGeoTagLoader class]]) {
		[self.poiItem loadFullDataFromDictionary:[result objectForKey:@"poi"]];
		self.totalPages = [result[@"poi"] intForKey:@"total_pages"];
		self.items = self.poiItem.photos;
		[super serverExchange:serverExchange didParseResult:result];
		[self refreshView];
	}
}

@end
