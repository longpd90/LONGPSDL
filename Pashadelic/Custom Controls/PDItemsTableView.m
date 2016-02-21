//
//  PDItemTableView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDItemsTableView.h"

@interface PDItemsTableView	(Private)
@end

@implementation PDItemsTableView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame style:UITableViewStylePlain];
	if (self) {
		[self initTable];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
	self = [super initWithFrame:frame style:style];
	if (self) {
		[self initTable];
	}
	return self;
}

- (void)initTable
{
	_tableRefreshView = [PDItemsTableRefreshView loadFromNibNamed:@"PDItemsTableRefreshView"];
	_tableRefreshView.autoresizingMask = UIViewAutoresizingNone;
	[_tableRefreshView resetView];
	_tableRefreshView.height = 0;
	[self addSubview:_tableRefreshView];
	[self scrollViewDidScroll:self];
	self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.tableViewMode = kPDDefaultTableViewMode;
	self.dataSource = self;
	self.delegate = self;
	self.backgroundColor = [UIColor clearColor];
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	self.loadingMoreContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 46)];
	[self.loadingMoreContentView clearBackgroundColor];
    self.logoProgressView = [[PDLogoProgressView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.logoProgressView.center = self.loadingMoreContentView.centerOfView;
    self.logoProgressView.y = 0;
    [self.logoProgressView setTypeActivityIndicator];
    [self.loadingMoreContentView addSubview:self.logoProgressView];
	self.tableViewState = PDItemsTableViewStateNormal;
}

- (void)setItems:(NSArray *)items
{
  _items = items;
  [self reloadData];
	self.tableViewState = PDItemsTableViewStateNormal;
}

- (void)setTableViewState:(PDItemsTableViewViewState)tableViewState
{
	_tableViewState = tableViewState;
	
	switch (tableViewState) {
		case PDItemsTableViewStateNormal:
		{
			self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
			self.tableFooterView = nil;
			[self.tableRefreshView setState:PDItemsTableRefreshViewStateNormal animated:YES];
			break;
		}
			
		case PDItemsTableViewStateLoadingMoreContent:
		{
			self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
			self.tableFooterView = self.loadingMoreContentView;
            self.logoProgressView.indicatorImageView.transform = CGAffineTransformMakeRotation(0);
			[self.tableRefreshView setState:PDItemsTableRefreshViewStateNormal animated:YES];
			break;
		}

			
		case PDItemsTableViewStateRefreshing:
		{
			self.tableFooterView = nil;
			[self.tableRefreshView setState:PDItemsTableRefreshViewStateLoading animated:YES];
			break;
		}

			
		case PDItemsTableViewStateReloading:
		{
			self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
			self.tableFooterView = nil;
			[self.tableRefreshView setState:PDItemsTableViewStateNormal animated:YES];
			break;
		}

            
		default:
			break;
	}
}

- (NSInteger)tileCellHeight
{
	return 0;
}

- (NSInteger)listCellHeightForIndex:(NSInteger)index
{
	return 0;
}

#pragma mark - Table delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (section == 0 && self.firstSectionHeader) {
		return self.firstSectionHeader;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section == 0 && self.firstSectionHeader) {
		return self.firstSectionHeader.height;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	if (section == 0 && self.firstSectionFooter) {
		return self.firstSectionFooter;
	}
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	if (section == 0 && self.firstSectionFooter) {
		return self.firstSectionFooter.height;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.tableViewMode == PDItemsTableViewModeTile) {
		return [self tileCellHeight];
	} else {
		return [self listCellHeightForIndex:indexPath.row];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.tableViewMode == PDItemsTableViewModeTile) {
		double count = self.items.count / 3.0;
		if (count > (NSInteger) count) 
			count++;
		return count;
	} else {
		return self.items.count;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{		
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.items[indexPath.row] itemWasSelected];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	if (self.itemsTableDelegate) {
		[self.itemsTableDelegate itemsTableWillBeginScroll:self];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	double yOffset = scrollView.contentOffset.y;
    if (self.itemsTableDelegate) {
        [self.itemsTableDelegate itemsTableDidScroll:self];
    }
	if (yOffset <= 0) {
		CGRect rect = _tableRefreshView.frame;
		rect.size.height = ABS(yOffset);
		rect.origin.y = yOffset;
		_tableRefreshView.frame = rect;
	} else {
		return;
	}
	
	if (_tableRefreshView.state == PDItemsTableRefreshViewStateLoading) return;
	
	if (_tableRefreshView.state == PDItemsTableRefreshViewStateNormal
		&& scrollView.contentOffset.y < -kPDRefreshYOffsetValue) {
		[_tableRefreshView setState:PDItemsTableRefreshViewStateRelease animated:YES];
		
	} else if (_tableRefreshView.state == PDItemsTableRefreshViewStateRelease
			   && scrollView.contentOffset.y > -kPDRefreshYOffsetValue) {
		[_tableRefreshView setState:PDItemsTableRefreshViewStateNormal animated:YES];
        [_tableRefreshView setProgress:(scrollView.contentOffset.y / -kPDRefreshYOffsetValue)];
	} else if (_tableRefreshView.state == PDItemsTableRefreshViewStateNormal)
    {
        [_tableRefreshView setProgress:(scrollView.contentOffset.y / -kPDRefreshYOffsetValue)];
    }
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (_tableRefreshView.state == PDItemsTableRefreshViewStateLoading) return;
	
	if (_tableRefreshView.state == PDItemsTableRefreshViewStateRelease
		&& scrollView.contentOffset.y < -kPDRefreshYOffsetValue) {
		if (self.itemsTableDelegate) {
			self.tableViewState = PDItemsTableViewStateRefreshing;
			[self.itemsTableDelegate itemsTableViewNeedRefetch:self];
			[UIView animateWithDuration:0.2 animations:^{
				self.contentInset = UIEdgeInsetsMake(kPDItemsTableRefreshViewDefaultHeight, 0, 0, 0);
			}];
		}		
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.itemsTableDelegate) {
		if (indexPath.row == [self.dataSource tableView:self numberOfRowsInSection:indexPath.section] - 3) {
			[self.itemsTableDelegate itemsTableWillShowLastCells:self];
		}
	}
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if (self.itemsTableDelegate && [self.itemsTableDelegate respondsToSelector:@selector(itemsTableDidScrollToTop:)]) {
        [self.itemsTableDelegate itemsTableDidScrollToTop:self];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.itemsTableDelegate) {
        [self.itemsTableDelegate itemsTableViewDidEndDecelerating:self];
    }
}

@end
