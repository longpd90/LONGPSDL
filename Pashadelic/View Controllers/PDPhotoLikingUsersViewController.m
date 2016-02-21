//
//  PDPhotoLikesViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 25/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoLikingUsersViewController.h"
#import "PDServerPhotoLikingUsersLoader.h"

@interface PDPhotoLikingUsersViewController ()

@end

@implementation PDPhotoLikingUsersViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.title = NSLocalizedString(@"likes", nil);
}

- (NSString *)pageName
{
	return @"Photo Likes";
}

- (void)fetchData
{
	[super fetchData];
	PDServerPhotoLikingUsersLoader *usersLoader = [[PDServerPhotoLikingUsersLoader alloc] initWithDelegate:self];
	self.serverExchange = usersLoader;
	[usersLoader loadLikingUsersForPhoto:self.photo page:self.currentPage];	
}

- (void)refreshView
{
	[super refreshView];
    if (self.items.count > 1) {
        self.title = NSLocalizedString(@"likes", nil);
    } else {
        self.title = NSLocalizedString(@"like", nil);
    }
}

@end
