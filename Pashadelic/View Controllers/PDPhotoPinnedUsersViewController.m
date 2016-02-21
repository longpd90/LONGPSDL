//
//  PDPhotoPinnedUsersViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoPinnedUsersViewController.h"
#import "PDServerPhotoPinnedUsersLoader.h"
@interface PDPhotoPinnedUsersViewController ()

@end

@implementation PDPhotoPinnedUsersViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = NSLocalizedString(@"collects", nil);
}

- (NSString *)pageName
{
	return @"Photo Pins";
}

- (void)fetchData
{
	[super fetchData];
	PDServerPhotoPinnedUsersLoader *usersLoader = [[PDServerPhotoPinnedUsersLoader alloc] initWithDelegate:self];
	self.serverExchange = usersLoader;
	[usersLoader loadPinnedUsersForPhoto:self.photo page:self.currentPage];	
}

- (void)refreshView
{
	[super refreshView];
    if (self.items.count > 1) {
        self.title = NSLocalizedString(@"collects", nil);
    } else {
        self.title = NSLocalizedString(@"collect", nil);
    }
}

@end
