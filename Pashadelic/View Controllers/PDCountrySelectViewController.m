//
//  PDCountrySelectViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.12.12.
//
//

#import "PDCountrySelectViewController.h"

@interface PDCountrySelectViewController ()
@end

@implementation PDCountrySelectViewController

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
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
    self.contentScrollView = _itemsTableView;
	[self fetchData];
	self.title = NSLocalizedString(@"Select country", nil);
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(search:)
												 name:UITextFieldTextDidChangeNotification
											   object:_searchTextField];
	[self.searchTextField.rightClearButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[self setItems:nil];
	[self setFilteredItems:nil];
	[self setItemsTableView:nil];
	[self setSearchTextField:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Edit My Country";
}

- (IBAction)cancel:(id)sender
{
	_searchTextField.text = @"";
	[_searchTextField resignFirstResponder];
	[self refreshView];
}

- (IBAction)search:(id)sender
{
	[self refreshView];
}

- (void)fetchData
{
	[kPDAppDelegate showWaitingSpinner];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerCountriesLoader alloc] initWithDelegate:self];
	}
	[self.serverExchange loadCountries];
}

- (void)refreshView
{
	self.needRefreshView = NO;
	if (_searchTextField.text.length == 0) {
		self.filteredItems = self.items;
	} else {
		self.filteredItems = [self.items filteredArrayUsingPredicate:
							  [NSPredicate predicateWithFormat:@"name contains[c] %@", _searchTextField.text]];
	}
	[self.itemsTableView reloadData];
}


#pragma mark - Table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _filteredItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ProfileCellIdentifier = @"PDCountrySelectCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ProfileCellIdentifier];
	}
	
	NSDictionary *item = [_filteredItems objectAtIndex:indexPath.row];
	
	if ([item[@"id"] intValue] == self.countryID) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.textLabel.text = item[@"name"];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(countryDidSelect:viewController:)]) {
		[self.delegate countryDidSelect:[_filteredItems objectAtIndex:indexPath.row] viewController:self];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (self.isKeyboardShown) {
		[_searchTextField resignFirstResponder];
	}
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	self.items = (NSArray *)result;
	[self refreshView];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	[self showErrorMessage:error];
}

@end
