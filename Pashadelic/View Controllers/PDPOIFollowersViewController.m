//
//  PDPOIFollowersViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDPOIFollowersViewController.h"
#import "PDPOIItem.h"

@interface PDPOIFollowersViewController ()

@end

@implementation PDPOIFollowersViewController

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
	self.usersTableView = [[PDUsersTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.usersTableView.itemsTableDelegate = self;
	[self.tablePlaceholderView addSubview:self.usersTableView];
	self.itemsTableView = self.usersTableView;
	if (self.poiItem) {
		self.poiItem = self.poiItem;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)pageName
{
	return @"POI Followers";
}

- (void)setPoiItem:(PDPOIItem *)poiItem
{
	_poiItem = poiItem;
	if (self.isViewLoaded) {
		[self refreshView];
		[self fetchData];
	}
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleBlack;
}


- (void)fetchData
{
	[super fetchData];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerExchange alloc] initWithDelegate:self];
	}
	[self.serverExchange setFunctionPath:[NSString stringWithFormat:@"gtags/%zd/followers.json", self.poiItem.identifier]];
	[self.serverExchange requestToGetFunctionWithString:nil];
}


- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	self.totalPages = [result intForKey:@"total_pages"];
	self.items = [serverExchange loadUsersFromArray:result[@"users"]];
	self.itemsTotalCount = self.items.count;
	[self refreshView];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[super serverExchange:serverExchange didFailWithError:error];
	[kPDAppDelegate hideWaitingSpinner];
}



@end
