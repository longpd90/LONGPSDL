//
//  PDDiscoverViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDDiscoverViewController.h"

enum PDHotViewSource {
    PDHotViewSourceNewPhotos = 0,
	PDHotViewSourceUpcoming,
	PDHotViewSourceFeatured
	};

@interface PDDiscoverViewController ()
- (void)refreshSourceButtons;
@end

@implementation PDDiscoverViewController

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
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
	self.title = NSLocalizedString(@"discover", nil);
	self.sourceType = PDHotViewSourceNewPhotos;
	[self.featuredSourceButton setTitle:NSLocalizedString(@"Featured", nil) forState:UIControlStateNormal];
	[self.upcomingSourceButton setTitle:NSLocalizedString(@"Upcoming", nil) forState:UIControlStateNormal];
    [self.photosSourceButton setTitle:NSLocalizedString(@"New photos", nil) forState:UIControlStateNormal];

	[self applyDefaultStyleToButtons:@[self.featuredSourceButton, self.upcomingSourceButton,self.photosSourceButton]];
	[self refreshSourceButtons];
	[self refetchData];
	[self setLeftButtonToMainMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setFeaturedSourceButton:nil];
    [self setUpcomingSourceButton:nil];
    [self setPhotosSourceButton:nil];
    [super viewDidUnload];
}

#pragma mark - Private

- (void)refreshSourceButtons
{
    self.photosSourceButton.selected = (self.sourceType == PDHotViewSourceNewPhotos);
	self.upcomingSourceButton.selected = (self.sourceType == PDHotViewSourceUpcoming);
	self.featuredSourceButton.selected = (self.sourceType == PDHotViewSourceFeatured);
}


#pragma mark - Public

- (NSString *)pageName
{
    if (self.sourceType == PDHotViewSourceNewPhotos) {
		return @"PhotoSpots New Photos";
	} else if (self.sourceType == PDHotViewSourceFeatured) {
		return @"PhotoSpots Featured";
	} else {
		return @"PhotoSpots UpComing";
	}
    
}

- (void)fetchData
{
	[super fetchData];
    if (self.sourceType == PDHotViewSourceNewPhotos) {
        self.serverExchange = [[PDServerUpcomingLoader alloc] initWithDelegate:self];
        if (self.currentPage == 1)
            [self.serverExchange loadUpcomingPage:self.currentPage];
        else
            [self.serverExchange loadUpcomingPage:self.currentPage firstPhotoId:self.firstObjectId];
	} else if (self.sourceType == PDHotViewSourceFeatured) {
		self.serverExchange = [[PDServerFeaturedLoader alloc] initWithDelegate:self];
		[self.serverExchange loadFeaturedPage:self.currentPage];
	} else {
		self.serverExchange = [[PDServerTrendingsLoader alloc] initWithDelegate:self];
		[self.serverExchange loadTrendingsPage:self.currentPage];
	}
}

- (IBAction)sourceChanged:(id)sender
{
        self.itemsTableView.items = nil;
    if ([sender isEqual:self.photosSourceButton]) {
		if (self.sourceType == PDHotViewSourceNewPhotos) return;
		self.sourceType = PDHotViewSourceNewPhotos;
	} else if ([sender isEqual:self.featuredSourceButton]) {
		if (self.sourceType == PDHotViewSourceFeatured) return;
		self.sourceType = PDHotViewSourceFeatured;
	} else if ([sender isEqual:self.upcomingSourceButton]) {
		if (self.sourceType == PDHotViewSourceUpcoming) return;
		self.sourceType = PDHotViewSourceUpcoming;
	}
    self.customNavigationBar.tableName = self.pageName;
	[self refreshSourceButtons];
	[self refetchData];
	[self trackCurrentPage];
}

#pragma mark - Gesture Recongnizer

- (void)swipeLeftGestureHandler
{
    if (self.photosSourceButton.isSelected) {
        [self sourceChanged:self.upcomingSourceButton];
    } else if (self.upcomingSourceButton.isSelected) {
        [self sourceChanged:self.featuredSourceButton];
    } else{
        return;
    }
}

- (void)swipeRightGestureHandler
{
    CGPoint gesturePoint = [self.rightSwipeGesture locationInView:self.view];
    if (gesturePoint.x < 10)
        [self showMainMenu];
    else {
        if (self.featuredSourceButton.isSelected){
            [self sourceChanged:self.upcomingSourceButton];
        }
        else if (self.upcomingSourceButton.isSelected) {
            [self sourceChanged:self.photosSourceButton];
        } else{
            return;
        }
    }
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if (![serverExchange isEqual:self.serverExchange]) return;
	[super serverExchange:serverExchange didParseResult:result];
	
	self.totalPages = [result intForKey:@"total_pages"];
    if ([serverExchange isKindOfClass:[PDServerUpcomingLoader class]] && (self.sourceType == PDHotViewSourceNewPhotos)) {
        self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
    }
    if ([serverExchange isKindOfClass:[PDServerFeaturedLoader class]] && (self.sourceType == PDHotViewSourceFeatured)) {
        self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
    }
    if ([serverExchange isKindOfClass:[PDServerTrendingsLoader class]] && (self.sourceType == PDHotViewSourceUpcoming)) {
        self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
    }
    if ([serverExchange isKindOfClass:[PDServerUpcomingLoader class]]) {
        if (self.items && self.items.count > 0) {
            PDPhoto *firstPhoto = (PDPhoto *)[self.items firstObject];
            self.firstObjectId = firstPhoto.identifier;
        }
    }
	[self refreshView];
}


@end
