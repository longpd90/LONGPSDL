//
//  PDPhotoUsersViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoUsersViewController.h"

@interface PDPhotoUsersViewController ()
- (void)initUsersTableView;
@end

@implementation PDPhotoUsersViewController
@synthesize usersTypeAndCountButton;
@synthesize tablePlaceholderView, usersTableView, photo;

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
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[self initUsersTableView];
	if (self.photo) {
		self.photo = self.photo;
	}
}

- (void)viewDidUnload
{
    [self setTablePlaceholderView:nil];
	self.usersTableView = nil;
	self.photo = nil;
	[self setUsersTypeAndCountButton:nil];
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)setPhoto:(PDPhoto *)newPhoto
{
	photo = newPhoto;
	if (self.isViewLoaded) {
		self.items = nil;
		self.itemsTotalCount = 0;
		self.currentPage = 1;
		self.totalPages = 1;
		[self fetchData];
		[self refreshView];
	}
}


#pragma mark - Private

- (void)refreshView
{
	[super refreshView];
	self.title = self.photo.title;
}

- (void)initUsersTableView
{
	usersTableView = [[PDUsersTableView alloc] initWithFrame:CGRectMakeWithSize(0, 0, tablePlaceholderView.frame.size)];
	usersTableView.itemsTableDelegate = self;
	[tablePlaceholderView addSubview:usersTableView];
	self.itemsTableView = usersTableView;
}

- (void)refreshViewMode
{
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	self.totalPages = [result intForKey:@"total_pages"];
	self.items = [serverExchange loadUsersFromArray:result[@"users"]];
	self.itemsTotalCount = self.items.count;
	[self refreshView];
}


@end
