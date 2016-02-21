//
//  PDItemTableView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDItem.h"
#import "UIView+Extra.h"
#import "PDItemsTableRefreshView.h"
#import "PDLogoProgressView.h"

typedef enum : NSUInteger {
	PDItemsTableViewStateNormal = 0,
	PDItemsTableViewStateReloading,
	PDItemsTableViewStateRefreshing,
	PDItemsTableViewStateLoadingMoreContent
} PDItemsTableViewViewState;

typedef enum : NSUInteger {
	PDItemsTableViewModeList = 0,
	PDItemsTableViewModeTile
} PDItemsTableViewMode;

@class PDItemsTableView;
@protocol PDItemsTableDelegate <NSObject>
- (void)itemsTableWillShowLastCells:(PDItemsTableView *)itemsTableView;
- (void)itemsTableViewNeedRefetch:(PDItemsTableView *)itemsTableView;
- (void)itemsTableWillBeginScroll:(PDItemsTableView *)itemsTableView;
- (void)itemsTableDidScrollToTop:(PDItemsTableView *)itemsTableView;
- (void)itemsTableDidScroll:(PDItemsTableView *)itemsTableView;
- (void)itemsTableViewDidEndDecelerating:(PDItemsTableView *)itemsTableView;
@end


@interface PDItemsTableView : UITableView
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UIView *firstSectionHeader;
@property (weak, nonatomic) UIView *firstSectionFooter;
@property (weak, nonatomic) id <PDItemsTableDelegate> itemsTableDelegate;
@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) PDItemsTableViewViewState tableViewState;
@property (assign, nonatomic) PDItemsTableViewMode tableViewMode;
@property (strong, nonatomic) UIView *loadingMoreContentView;
@property (strong, nonatomic) PDLogoProgressView *logoProgressView;
@property (strong, nonatomic) PDItemsTableRefreshView *tableRefreshView;

- (NSInteger)tileCellHeight;
- (NSInteger)listCellHeightForIndex:(NSInteger)index;
- (void)initTable;

@end