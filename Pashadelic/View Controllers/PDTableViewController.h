//
//  PDModeViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDViewController.h"
#import "PDItemsTableView.h"
#import "NSObject+Extra.h"

@interface PDTableViewController : PDViewController
<PDItemsTableDelegate, PDItemSelectDelegate, MGServerExchangeDelegate>

@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger totalPages;
@property (nonatomic) NSUInteger itemsTotalCount;
@property (nonatomic) NSUInteger firstObjectId;
@property (weak, nonatomic) PDItemsTableView *itemsTableView;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) PDItem *item;
@property (assign, nonatomic) BOOL appendItemsToExisting;

- (void)hideToolbarAnimated:(BOOL)animated;
- (void)showToolbarAnimated:(BOOL)animated;
- (IBAction)toggleToolbarView:(id)sender;
- (void)hideKeyboard;
- (void)itemWasChanged:(NSNotification *)notification;
- (void)refreshWithoutScrollToTop;
- (void)applyDefaultStyleToButtons:(NSArray *)buttons;

@end
