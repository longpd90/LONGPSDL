//
//  PDFeedTableView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.11.12.
//
//

#import "PDNotificationsTableView.h"

@implementation PDNotificationsTableView

- (NSInteger)tileCellHeight
{
	return 66;
}

- (NSInteger)listCellHeightForIndex:(NSInteger)index
{
	return 66;
}

- (void)setTableViewMode:(PDItemsTableViewMode)tableViewMode
{
	[super setTableViewMode:PDItemsTableViewModeList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *NotificationTableViewCell = @"PDNotificationTableViewCell";
	PDNotificationTableViewCell *cell = (PDNotificationTableViewCell *) [tableView dequeueReusableCellWithIdentifier:NotificationTableViewCell];
	if (!cell) {
		cell = [UIView loadFromNibNamed:NotificationTableViewCell];
	}
	
	cell.delegate = self.photoViewDelegate;
    cell.planDelegate = self.planViewDelegate;
	cell.notificationItem = [self.items objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	PDNotificationTableViewCell *cell = (PDNotificationTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
	[cell showTarget:nil];
}

@end
