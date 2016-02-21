//
//  PDTagViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.04.13.
//
//

#import "PDTagViewController.h"

@interface PDTagViewController ()

- (void)initUsersTable;
- (void)refreshCurrentTable;
- (void)refreshSourceButtons;
@end

@implementation PDTagViewController

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
	[self initUsersTable];
	[self changeSource:self.sourcePhotosButton];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleWhiteAngle];
	if (self.tag) {
		self.tag = self.tag;
	}
	[self applyDefaultStyleToButtons:@[self.sourceFollowersButton, self.sourcePhotosButton]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private

- (void)refreshSourceButtons
{
	self.sourceFollowersButton.selected = (self.sourceType == PDTagViewSourceUsers);
	self.sourcePhotosButton.selected = (self.sourceType == PDTagViewSourcePhotos);
}

- (void)refreshCurrentTable
{
	if (self.sourceType == PDTagViewSourcePhotos) {
		self.itemsTableView = self.photosTableView;
		self.photosTableView.hidden = NO;
		self.usersTableView.hidden = YES;
		
	} else {
		self.itemsTableView = self.usersTableView;
		self.photosTableView.hidden = YES;
		self.usersTableView.hidden = NO;
	}
}

- (void)initUsersTable
{
	self.usersTableView = [[PDUsersTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.usersTableView.itemsTableDelegate = self;
	[self.tablePlaceholderView addSubview:self.usersTableView];
}

#pragma mark - Public

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleBlack;
}

- (NSString *)pageName
{
	if (self.sourceType == PDTagViewSourceUsers) {
		return @"Tag's Users";
	} else {
		return @"Tag's Photos";
	}
}

- (void)setTag:(PDTag *)tag
{
	_tag = tag;
	self.sourceType = PDTagViewSourcePhotos;
	[self refreshCurrentTable];
	[self refetchData];
}

- (IBAction)changeSource:(id)sender
{
	if ([sender isEqual:self.sourcePhotosButton]) {
		if (self.sourceType == PDTagViewSourcePhotos) return;
		self.sourceType = PDTagViewSourcePhotos;
		
	} else if ([sender isEqual:self.sourceFollowersButton]) {
		if (self.sourceType == PDTagViewSourceUsers) return;
		self.sourceType = PDTagViewSourceUsers;
	}
	
	[self refreshCurrentTable];
	[self refetchData];
	[self trackCurrentPage];
}

- (void)refreshView
{
	[super refreshView];
	self.title = self.tag.name;
	[self refreshSourceButtons];
}

- (void)fetchData
{
	[super fetchData];
	if (self.sourceType == PDTagViewSourcePhotos) {
		self.serverExchange = [[PDServerTagPhotosLoader alloc] initWithDelegate:self];
		[self.serverExchange loadTagPhotos:self.tag page:self.currentPage];
	} else {
		self.serverExchange = [[PDServerTagUsersLoader alloc] initWithDelegate:self];
		[self.serverExchange loadTagUsers:self.tag page:self.currentPage];
	}
}


#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if (![serverExchange isEqual:self.serverExchange]) return;
	[super serverExchange:serverExchange didParseResult:result];
		
	if ([serverExchange isKindOfClass:[PDServerTagUsersLoader class]]) {
		self.items = [serverExchange loadUsersFromArray:result[@"users"]];
	} else {
		self.items = [serverExchange loadPhotosFromArray:result[@"photos"]];
	}
	
	self.totalPages = [result intForKey:@"total_pages"];
	[self refreshView];
}

@end
