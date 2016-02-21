//
//  PDPlansTable.m
//  Pashadelic
//
//  Created by LongPD on 11/7/13.
//
//

#import "PDPlansTableView.h"

@implementation PDPlansTableView

- (void)initTable
{
    [super initTable];
    self.tableViewMode = PDItemsTableViewModeList;
}

- (NSInteger)listCellHeightForIndex:(NSInteger)index
{
	return 99;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PlansTableViewCell = @"PDPlansTableViewCell";
	PDPlansTableViewCell *cell = (PDPlansTableViewCell *) [tableView dequeueReusableCellWithIdentifier:PlansTableViewCell];
	if (!cell) {
		cell = [UIView loadFromNibNamed:PlansTableViewCell];
	}
    cell.delegate = self.photoViewDelegate;
	[cell setPlanItem:[self.items objectAtIndex:indexPath.row]];
    [cell setHiddenViewButton:self.noPlan];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.noPlan) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PDPlansTableViewCell *cell = (PDPlansTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        [cell showPlanDetail:nil];
    }
}

@end
