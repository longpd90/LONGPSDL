//
//  PDSearchUsersViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 17/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDSearchUsersViewController.h"

@interface PDSearchUsersViewController ()
- (void)cancelRefresh;
@end

@implementation PDSearchUsersViewController
@synthesize tablePlaceholderView, usersTableView, userViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosTableView.scrollsToTop = NO;
	self.title = NSLocalizedString(@"Search Users", nil);
	[self initUsersTable];
	[self refreshView];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	self.toolbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_search.png"]];
	self.searchTextField.placeholder = NSLocalizedString(@"Enter a name to begin ...", nil);
	[self.searchTextField.rightClearButton addTarget:self action:@selector(cancelSearch:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [self setTablePlaceholderView:nil];
	[self setSearchTextField:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Private

- (void)initUsersTable
{
	usersTableView = [[PDUsersTableView alloc] initWithFrame:CGRectMakeWithSize(0, 0, tablePlaceholderView.frame.size)
													   style:UITableViewStylePlain];
	usersTableView.itemsTableDelegate = self;
	[tablePlaceholderView addSubview:usersTableView];
	self.itemsTableView = usersTableView;
}

- (void)initUserViewController
{
	userViewController = [[PDUserViewController alloc] initWithNibName:@"PDUserViewController" bundle:nil];
}

- (void)cancelRefresh
{
	self.itemsTableView.tableViewState = PDItemsTableViewStateNormal;
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Search Users";
}

- (void)hideKeyboard
{
	[_searchTextField resignFirstResponder];
}

- (IBAction)cancelSearch:(id)sender
{
	_searchTextField.text = @"";
	[_searchTextField resignFirstResponder];
}

- (IBAction)search:(id)sender
{
	if (_searchTextField.text.length == 0) return;
    if (![_searchTextField validateTextSearch]) return;
	searchText = _searchTextField.text;
	[self refetchData];
	[_searchTextField resignFirstResponder];
}

- (void)fetchData
{	
	if (searchText.length == 0) {
		[self performSelector:@selector(cancelRefresh) withObject:nil afterDelay:1];
		return;
	};
	
	[self trackEvent:@"Search user"];
	self.title = NSLocalizedString(@"Search Users Result", nil);
	[super fetchData];
	PDServerUsersSearch *serverUsersSearch = [[PDServerUsersSearch alloc] initWithDelegate:self];
	[serverUsersSearch searchUsers:searchText page:self.currentPage];
}

- (void)showUser:(PDUser *)user
{
	if (!self.userViewController) {
		self.userViewController = [[PDUserViewController alloc] initWithNibName:@"PDUserViewController" bundle:nil];
	}
	self.userViewController.user = user;
	[self.navigationController pushViewController:self.userViewController animated:YES];
}


#pragma mark - Item select delegate

- (void)itemDidSelect:(PDItem *)item
{
	if (!userViewController) {
		[self initUserViewController];
	}
	userViewController.user = (PDUser *)item;
	[self.navigationController pushViewController:userViewController animated:YES];
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	self.totalPages = [result intForKey:@"total_pages"];
	self.items = [serverExchange loadUsersFromArray:result[@"users"]];
	[self refreshView];	
}


@end
