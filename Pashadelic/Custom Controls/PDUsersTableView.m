//
//  PDUsersTableView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 8/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDUsersTableView.h"
#import "PDUserCell.h"

@implementation PDUsersTableView

- (NSInteger)listCellHeightForIndex:(NSInteger)index
{
	return 82;
}

- (void)setTableViewMode:(PDItemsTableViewMode)tableViewMode
{
	[super setTableViewMode:PDItemsTableViewModeList];
}

#pragma mark - Table delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *UserCellIdentifier = @"PDUserCell";
	PDUserCell *cell = (PDUserCell *) [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
	if (!cell) {
		cell = [UIView loadFromNibNamed:UserCellIdentifier];
	}
	cell.user = [self.items objectAtIndex:indexPath.row];
	return cell;
}

@end
