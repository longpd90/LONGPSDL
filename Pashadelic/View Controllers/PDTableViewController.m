//
//  PDModeViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDTableViewController.h"
#import "UIImage+Extra.h"
#import "PDComment.h"
#import "PDPhotosTableView.h"

@interface PDTableViewController ()

- (void)alertViewDismiss;

@end

@implementation PDTableViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.currentPage = 1;
    self.firstObjectId = 0;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(itemWasChanged:)
												 name:kPDItemWasChangedNotification
											   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewDismiss) name:kPDDismissSingleErrorAlertView object:nil];
	[self.tablePlaceholderView clearBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (self.isNeedRefreshView) {
		[self refreshWithoutScrollToTop];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.fullscreenMode = self.navigationController.navigationBarHidden;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)toggleToolbarView:(id)sender
{
	if (!self.toolbarView) return;
	
	if (self.itemsTableView.tableHeaderView == nil) {
		[self showToolbarAnimated:YES];
	} else {
		[self hideToolbarAnimated:YES];
	}
}

#pragma mark - Public

- (void)hideToolbarAnimated:(BOOL)animated
{
	self.toolbarView.clipsToBounds = YES;
	self.customNavigationBar.titleButton.selected = YES;
	self.tablePlaceholderView.height = self.view.height;
	if (animated) {
		NSUInteger toolbarHeight = self.itemsTableView.tableHeaderView.height;
		[UIView animateWithDuration:0.3 animations:^{
			self.itemsTableView.tableHeaderView.height = 0;
			self.itemsTableView.tableHeaderView = self.itemsTableView.tableHeaderView;
		} completion:^(BOOL finished) {
			self.itemsTableView.tableHeaderView = nil;
			self.toolbarView.height = toolbarHeight;
			[self.toolbarView removeFromSuperview];
		}];
		
	} else {
		self.itemsTableView.tableHeaderView = nil;
		[self.toolbarView removeFromSuperview];
	}
}

- (void)showToolbarAnimated:(BOOL)animated
{
	self.toolbarView.clipsToBounds = YES;
	self.customNavigationBar.titleButton.selected = NO;
	self.toolbarView.hidden = NO;
	if (animated) {
	NSUInteger toolbarHeight = self.toolbarView.height;
	self.toolbarView.height = 0;
		[UIView animateWithDuration:0.3 animations:^{
			self.toolbarView.height = toolbarHeight;
			self.itemsTableView.tableHeaderView = self.toolbarView;
		}];
	} else {
		self.itemsTableView.tableHeaderView = self.toolbarView;
	}
}

- (void)trackCurrentPage
{
	NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![bundleIdentifier isEqualToString:kPDAppProductionBundleID]) return;
		
	NSString *mode = @"";
	switch (self.itemsTableView.tableViewMode) {
		case PDItemsTableViewModeList:
			mode = @"/List";
			break;
						
		case PDItemsTableViewModeTile:
			mode = @"/Tile";
			break;
	}
	
	[[PDGoogleAnalytics sharedInstance] trackPage:[self.pageName stringByAppendingString:mode]];
}

- (void)trackEvent:(NSString *)event
{
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	if (![bundleIdentifier isEqualToString:kPDAppProductionBundleID]) return;
    
    NSString *mode = @"";
    if (self.itemsTableView.tableViewMode == PDItemsTableViewModeList)
        mode = @"/List";
    
    [[Mixpanel sharedInstance] track:event properties:@{@"Page" : [self.pageName stringByAppendingString:mode]}];
	[[PDGoogleAnalytics sharedInstance] trackAction:event atPage:self.pageName];
}

- (void)itemWasChanged:(NSNotification *)notification
{
	if (self.view.window) return;
	
	NSDictionary *userInfo = notification.userInfo;
	PDItem *object = [userInfo objectForKey:@"object"];
	
	if ([self.item isEqual:object]) {
		[self.item setValuesFromArray:userInfo[@"values"]];
		self.needRefreshView = YES;
		return;		
	}
	
	for (PDItem *item in self.items) {
		if ([item isEqual:object] ) {
			[item setValuesFromArray:userInfo[@"values"]];
			self.needRefreshView = YES;
			return;
		}
	}
}

- (NSString *)pageName
{
	NSLog(@"No page name for %@", NSStringFromClass([self class]));
	return @"Table View";
}

- (NSArray *)helpItems
{
	NSArray *array = [super helpItems];
	for (NSString *helpID in self.helpID) {
		NSArray *helpItems = [kPDAppDelegate.helpItems objectForKey:helpID];
		if (helpItems) {
			array = [array arrayByAddingObjectsFromArray:helpItems];
		}
	}
	return array;
}

- (NSArray *)helpID
{
	return [[super helpID] arrayByAddingObject:@"TableView"];
}

- (void)setItems:(NSArray *)newItems
{
  if (self.appendItemsToExisting) {
    self.appendItemsToExisting = NO;
    
    if (_items.count == 0) {
      _items = newItems;
      
    } else {
      _items = [_items arrayByAddingObjectsFromArray:newItems];
    }
    
  } else {
    _items = newItems;
  }
  
	[_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([obj isKindOfClass:[PDItem class]]) {
			[obj setItemDelegate:self];
		}
	}];
}

- (void)applyDefaultStyleToButtons:(NSArray *)buttons
{
	UIColor *grayColor = [UIColor colorWithRed:0.4 green:0.475 blue:0.514 alpha:1];
	UIImage *backgroundImage = [[[UIImage alloc] init] imageWithColor:grayColor];
	for (UIButton *button in buttons) {
    [button setBackgroundImage:backgroundImage forState:UIControlStateSelected];
		[button setBackgroundImage:backgroundImage forState:UIControlStateSelected|UIControlStateHighlighted];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected|UIControlStateHighlighted];
		[button setTitleColor:grayColor forState:UIControlStateNormal];
		button.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
		button.layer.borderWidth = 1;
	}
}

- (void)refetchData
{
	self.loading = YES;
	self.currentPage = 1;
    self.firstObjectId = 0;
	[self fetchData];
}

- (void)refreshView
{
	[super refreshView];
	self.itemsTableView.items = self.items;
}

- (void)hideKeyboard
{
	[self.view endEditing:YES];
}

- (void)refreshWithoutScrollToTop
{
	CGPoint scrollOffset = self.itemsTableView.contentOffset;
	self.items = self.itemsTableView.items;
	[self refreshView];
	self.itemsTableView.contentOffset = scrollOffset;
}

#pragma mark - Items table delegate

- (void)itemsTableViewNeedRefetch:(PDItemsTableView *)itemsTableView
{
	if (self.loading) return;
	[self refetchData];
}

- (void)itemsTableWillBeginScroll:(PDItemsTableView *)itemsTableView
{
	if (self.isKeyboardShown) {
		[self hideKeyboard];
	}
}

- (void)itemsTableWillShowLastCells:(PDItemsTableView *)itemsTableView
{
	if (itemsTableView.tableViewState != PDItemsTableViewStateNormal) return;
	
	if (self.currentPage < self.totalPages) {
		self.currentPage++;
    self.appendItemsToExisting = YES;
		[self fetchData];
		itemsTableView.tableViewState = PDItemsTableViewStateLoadingMoreContent;
	}
}

- (void)itemsTableDidScrollToTop:(PDItemsTableView *)itemsTableView
{
    
}

- (void)itemsTableDidScroll:(PDItemsTableView *)itemsTableView
{
    
}

- (void)itemsTableViewDidEndDecelerating:(PDItemsTableView *)itemsTableView
{
    
}

#pragma mark - alert view dismiss

- (void)alertViewDismiss
{
    self.itemsTableView.tableViewState = PDItemsTableViewStateNormal;
}

#pragma mark - Item select delegate

- (void)itemDidSelect:(PDItem *)item
{
	if ([item isKindOfClass:[PDPhoto class]]) {
		[self showPhoto:(PDPhoto *)item];
		
	} else if ([item isKindOfClass:[PDUser class]]) {
		[self showUser:(PDUser *)item];
				
	} else if ([item isKindOfClass:[PDComment class]]) {
		[self showUser:[(PDComment *)item user]];	
	}
}

#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    [kPDAppDelegate hideWaitingSpinner];
	self.loading = NO;
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	self.loading = NO;
	if (serverExchange.HTTPStatusCode == -1) {
		[self showNoInternetButton];
	} else if (self.view.window) {
		[self showErrorMessage:error];
	}
}

@end
