//
//  PDLandmarkPhotographersViewController.m
//  Pashadelic
//
//  Created by LTT on 6/19/14.
//
//

#import "PDLandmarkPhotographersViewController.h"
#import "PDServerGetPhotographers.h"
@interface PDLandmarkPhotographersViewController ()

@end

@implementation PDLandmarkPhotographersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil andLocation:(PDLocation *)location
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.location = location;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUsersTable];
	[self refreshView];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    [self fetchData];
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
    return PDNavigationBarStyleWhite;
}

- (void)cancelRefresh
{
	self.itemsTableView.tableViewState = PDItemsTableViewStateNormal;
}

- (NSString *)pageName
{
	return @"Photographers";
}

#pragma mark - Private

- (void)initUsersTable
{
    self.title = NSLocalizedString(@"Photographers", nil);
	_usersTableView = [[PDUsersTableView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.tablePlaceholderView.frame.size)  style:UITableViewStylePlain];
	_usersTableView.itemsTableDelegate = self;
	[self.tablePlaceholderView addSubview:_usersTableView];
	self.itemsTableView = _usersTableView;
}

- (void)initUserViewController
{
	_userViewController = [[PDUserViewController alloc] initWithNibName:@"PDUserViewController" bundle:nil];
}

- (void)fetchData
{
    [super fetchData];
    if (!self.serverExchange) {
        self.serverExchange = [[PDServerGetPhotographers alloc] initWithDelegate:self];
    }
    [self.serverExchange getPhotographersInLocation:self.location andPage:self.currentPage];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Item select delegate

- (void)itemDidSelect:(PDItem *)item
{
	if (!_userViewController) {
		[self initUserViewController];
	}
	_userViewController.user = (PDUser *)item;
	[self.navigationController pushViewController:_userViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Server exchange delegate
- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	self.totalPages = [result intForKey:@"total_page"];
	self.items = [serverExchange loadUsersFromArray:result[@"users"]];
	[self refreshView];
}

@end
