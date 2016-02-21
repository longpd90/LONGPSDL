//
//  PDActivitiesTableView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 04.03.14.
//
//

#import "PDActivitiesTableView.h"
#import "PDActivityItem.h"

@implementation PDActivitiesTableView

- (void)setTableViewMode:(PDItemsTableViewMode)tableViewMode
{
	[super setTableViewMode:PDItemsTableViewModeList];
}

- (void)initTable
{
	[super initTable];
	self.tableViewMode = PDItemsTableViewModeList;
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)sender
{
}

- (UIImageView *)photoImageViewForPhoto:(PDPhoto *)photo
{
  NSUInteger index = [self.items indexOfObject:photo];
  if (index == NSNotFound) return nil;
  
  PDPhotoListCell *cell = (PDPhotoListCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
  return cell.photoImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self listCellHeightForIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"PDPhotoListCell";
	PDPhotoListCell *cell = (PDPhotoListCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [UIView loadFromNibNamed:CellIdentifier];
	}
	
	PDActivityItem *activity = self.items[indexPath.row];
	[cell setItem:activity];
	cell.usernameLabel.width = cell.width - cell.usernameLabel.x;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	PDPhotoListCell *cell = (PDPhotoListCell *) [tableView cellForRowAtIndexPath:indexPath];
	id <PDPhotoViewDelegate> viewController = (id<PDPhotoViewDelegate>) self.firstViewController;
	if ([viewController respondsToSelector:@selector(photo:didSelectInView:image:)]) {
		[viewController photo:cell.photo didSelectInView:cell.photoImage image:cell.photoImage.image];
	}
}


@end
