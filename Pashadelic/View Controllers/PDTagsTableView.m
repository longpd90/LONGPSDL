//
//  PDTagsTableView.m
//  Pashadelic
//
//  Created by Linh on 2/18/13.
//
//

@interface PDTagsTableView (Private)
@end

@implementation PDTagsTableView

- (void)initTable
{
	[super initTable];
    //	self.backgroundColor = [UIColor whiteColor];
    //	self.separatorStyle = UITableViewCellSeparatorStyleNone;
    //	self.separatorColor = [UIColor clearColor];
	self.tableViewMode = PDViewModeList;
}

- (void)setTableViewMode:(int)newTableViewMode
{
	[super setTableViewMode:PDViewModeList];
}


- (void)setItems:(NSArray *)newItems
{
	newItems = [newItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [[obj2 date] compare:[obj1 date]];
	}];
	[super setItems:newItems];
}

#pragma mark - Table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *TagCellIdentifier = @"PDTagCell";
	PDTagCell *cell = (PDTagCell *) [tableView dequeueReusableCellWithIdentifier:TagCellIdentifier];
	if (!cell) {
		cell = [UIView loadFromNibNamed:TagCellIdentifier];
		cell.delegate = _tagCellDelegate;
	}
	
	cell.tagName.text = [self.items objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
