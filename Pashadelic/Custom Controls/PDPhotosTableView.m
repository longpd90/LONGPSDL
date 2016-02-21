//
//  PDPhotosTableView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 26/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotosTableView.h"

const NSUInteger PDPhotoTileCellViewsCount = 3;

@interface PDPhotosTableView (Private)
- (void)loadImageForVisibleRows;
@end

@implementation PDPhotosTableView

- (void)initTable
{
	[super initTable];
	UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
	gesture.delaysTouchesEnded = YES;
	[self addGestureRecognizer:gesture];
  [self clearBackgroundColor];
	
}

- (NSInteger)tileCellHeight
{
	return kPDPhotoTileCellHeight;
}

- (NSInteger)listCellHeightForIndex:(NSInteger)index
{
	PDPhoto *photo = [self.items objectAtIndex:index];
	return kPDPhotoListCellDetailsHeight + photo.photoListImageSize.height;
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)sender
{
	
	if (sender.scale > 1.7 && self.tableViewMode == PDItemsTableViewModeTile) {
		self.tableViewMode = PDItemsTableViewModeList;
		
		CGPoint location = [sender locationInView:self];
		NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
		
		NSUInteger index = indexPath.row * 3;
		if (!indexPath) {
			index = 0;
			
		} else {
			if (location.x > self.width * 0.66) {
				index += 2;
				if (index > self.items.count - 1) {
					index = self.items.count - 1;
				}
			} else if (location.x > self.width * 0.33) {
				index += 1;
				if (index > self.items.count - 1) {
					index = self.items.count - 1;
				}
			}
		}
		
		[self reloadData];
		if ((index == 0 && indexPath.section == 0) || [self numberOfRowsInSection:indexPath.section] == 0) {
			[self setContentOffset:CGPointZero animated:NO];
		} else {
			while (index > [self numberOfRowsInSection:indexPath.section] - 1) {
				index--;
			}
			[self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]
									atScrollPosition:UITableViewScrollPositionMiddle
													animated:NO];
		}
		
	} else if (sender.scale < 0.6 && self.tableViewMode == PDItemsTableViewModeList) {
		self.tableViewMode = PDItemsTableViewModeTile;
		
		CGPoint location = [sender locationInView:self];
		NSIndexPath *indexPath = [self indexPathForRowAtPoint:location];
		indexPath = [NSIndexPath indexPathForRow:indexPath.row / 3 inSection:indexPath.section];
		
		[self reloadData];
		if ((indexPath.row == 0 && indexPath.section == 0) || [self numberOfRowsInSection:indexPath.section] == 0) {
			[self setContentOffset:CGPointZero animated:NO];
		} else {
			[self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
		}
	}
}

- (UIImageView *)photoImageViewForPhoto:(PDPhoto *)photo
{
  NSUInteger index = [self.items indexOfObject:photo];
  if (index == NSNotFound) return nil;
  
  if (self.tableViewMode == PDItemsTableViewModeList) {
    PDPhotoListCell *cell = (PDPhotoListCell *) [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    return cell.photoImage;
    
  } else {
    NSUInteger modulo = index % PDPhotoTileCellViewsCount;
    NSUInteger cellIndex = index / PDPhotoTileCellViewsCount;
    
    PDPhotoTileCell *cell = (PDPhotoTileCell *) [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cellIndex inSection:0]];
    return cell.photoViews[modulo];
  }
}

- (void)scrollToPhoto:(PDPhoto *)photo animated:(BOOL)animated
{
  NSUInteger index = [self.items indexOfObject:photo];
  if (index == NSNotFound) return;
  
  if (self.tableViewMode == PDItemsTableViewModeList) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (![self.indexPathsForVisibleRows containsObject:indexPath] && !([self numberOfRowsInSection:indexPath.section] <= index)) {
      [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    }
    
  } else {
    NSUInteger modulo = index % PDPhotoTileCellViewsCount;
    NSUInteger cellIndex = index / PDPhotoTileCellViewsCount;
    if (modulo > 0) {
      cellIndex++;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0] ;
    if (!([self numberOfRowsInSection:indexPath.section] <= cellIndex)) {
      [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    }
  }
}


#pragma mark - Table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (self.tableViewMode != PDItemsTableViewModeList) return;
	
	if (self.photoViewDelegate) {
		PDPhotoListCell *listCell = (PDPhotoListCell *) [self cellForRowAtIndexPath:indexPath];
		[self.photoViewDelegate photo:[self.items objectAtIndex:indexPath.row]
									didSelectInView:listCell.photoImage
														image:listCell.photoImage.image];
		
	} else {
		[self.items[indexPath.row] itemWasSelected];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.tableViewMode == PDItemsTableViewModeTile) {
		return [self tileCellHeight];
	} else {
		return [self listCellHeightForIndex:indexPath.row];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (self.tableViewMode == PDItemsTableViewModeTile) {
		static NSString *TileCellIdentifier = @"PDPhotoTileCell";
		PDPhotoTileCell *cell = (PDPhotoTileCell *) [tableView dequeueReusableCellWithIdentifier:TileCellIdentifier];
		if (!cell) {
			cell = [[PDPhotoTileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TileCellIdentifier];
			[cell initCell];
			cell.photoViewDelegate = self.photoViewDelegate;
		}
		
		int count = PDPhotoTileCellViewsCount;
		if (indexPath.row == self.items.count / PDPhotoTileCellViewsCount)
			count = self.items.count % PDPhotoTileCellViewsCount;
		cell.photos = [self.items subarrayWithRange:NSMakeRange(indexPath.row * PDPhotoTileCellViewsCount, count)];
		return cell;
		
	} else {
		NSString *ListCellIdentifier = @"PDPhotoListCell";
		PDPhotoListCell *cell = (PDPhotoListCell *) [tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
		if (!cell) {
			cell = [UIView loadFromNibNamed:ListCellIdentifier];
		}
        [cell setItem:self.items[indexPath.row]];
		
		return cell;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.tableViewMode == PDItemsTableViewModeList) {
		return self.items.count;
	} else {
		NSInteger count = self.items.count / PDPhotoTileCellViewsCount;
		if (count * PDPhotoTileCellViewsCount != self.items.count) {
			count++;
		}
		return count;
	}
}

@end
