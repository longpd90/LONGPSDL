//
//  PDLocationTableView.m
//  Pashadelic
//
//  Created by LongPD on 6/18/14.
//
//

#import "PDLocationInfoTableView.h"
#import "PDLocationInfoViewCell.h"

@implementation PDLocationInfoTableView

- (void)initTable
{
    [super initTable];
    self.tableViewMode = PDItemsTableViewModeList;
    [self setBackgroundColor:[UIColor colorWithIntRed:249 green:249 blue:249 alpha:1]];
}

- (NSInteger)listCellHeightForIndex:(NSInteger)index
{
	return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PDLocationViewCellIdentifier = @"PDLocationInfoViewCell";
	PDLocationInfoViewCell *cell = (PDLocationInfoViewCell *) [tableView dequeueReusableCellWithIdentifier:PDLocationViewCellIdentifier];
	if (!cell) {
		cell = [UIView loadFromNibNamed:PDLocationViewCellIdentifier];
	}
    cell.locationItem = [self.items objectAtIndex:indexPath.row];
    return cell;
}

@end
