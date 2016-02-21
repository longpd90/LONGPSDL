//
//  PDSecondViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDNearbyViewController.h"
#import "PDNearbyMenuView.h"

@interface PDNearbyViewController ()
- (void)initInterface;
- (void)refreshSortButtons;
@end

@implementation PDNearbyViewController
@synthesize sortByDateButton;
@synthesize sortByRankingButton;
@synthesize sorting;

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
	[self initInterface];
	self.title = NSLocalizedString(@"Nearby", nil);
	if (![PDServerExchange isInternetReachable]) {
		[self showNoInternetButton];
	}
    [self initLocationService];
}

- (void)viewDidUnload
{
    [self setPhotosTableView:nil];
    [self setSortByDateButton:nil];
    [self setSortByRankingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}


#pragma mark - Private

- (void)initInterface
{
	[self setLeftButtonToMainMenu];
	[self setRightBarButtonToButton:[self grayBarButtonWithTitle:NSLocalizedString(@"filter", nil)
                                                          action:@selector(showMenu:)]];
	[self refreshSortButtons];
}

- (void)refreshSortButtons
{
	sortByDateButton.selected = (sorting == PDNearbySortTypeByDate);
	sortByRankingButton.selected = (sorting == PDNearbySortTypeByPopularity);
}

#pragma mark - Public

- (NSString *)pageName
{
	if (self.sorting == PDNearbySortTypeByDate) {
		return @"Nearby New";
	} else {
		return @"Nearby Popular";
	}
}

- (void)refreshView
{
	[super refreshView];
	if (self.itemsTotalCount == 0) {
		self.title = NSLocalizedString(@"Nearby", nil);
	} else {
		self.title = [NSString stringWithFormat:NSLocalizedString(@"Nearby (%d)", nil), self.itemsTotalCount];
	}
}

- (void)fetchData
{
	[super fetchData];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerNearbyLoader alloc] initWithDelegate:self];
	}
	[self.serverExchange loadNearbyPage:self.currentPage sorting:sorting range:kPDNearbyRange];
}

- (void)refetchData
{
	[self refreshSortButtons];
	[super refetchData];
}

- (IBAction)sortTypeChanged:(id)sender 
{
	if ([sender isEqual:sortByDateButton]) {
		if (sorting == PDNearbySortTypeByDate) return;
		sorting = PDNearbySortTypeByDate;
		
	} else {
		if (sorting == PDNearbySortTypeByPopularity) return;
		sorting = PDNearbySortTypeByPopularity;

	}
	[self refetchData];
	[self refreshSortButtons];
}

- (void)showMenu:(id)sender
{
	PDNearbyMenuView *nearbyMenuView = [[PDNearbyMenuView alloc] init];
	nearbyMenuView.delegate = self;
	[nearbyMenuView showMenuInViewController:self];
}

- (NSArray *)helpID
{
	return [[super helpID] arrayByAddingObject:@"NearbyView"];
}

#pragma mark - Override

- (void)initLocationService
{
    [super initLocationService];
    if (!isLocationReceived) return;
    [self fetchData];
}

- (void)updateLocation
{
    [super updateLocation];
    [[PDLocationHelper sharedInstance] updateLocation:^(NSError *error, CLLocation *location){
        if (error) {
            [self updateLocationDidFailWithError:error];
        }
        isLocationReceived = YES;
        [self fetchData];
    }];
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if (![serverExchange isEqual:self.serverExchange]) return;
	[super serverExchange:serverExchange didParseResult:result];
	
	self.itemsTotalCount = [result intForKey:@"total_count"];
	self.totalPages = [result intForKey:@"total_pages"];	
	self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
	[self refreshView];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	if (self.noInternetButton.hidden == NO) return;
	
	self.itemsTotalCount = 0;
	[super serverExchange:serverExchange didFailWithError:error];
}

@end
