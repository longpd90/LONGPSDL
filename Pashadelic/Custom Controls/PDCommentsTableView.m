//
//  PDCommentsTableView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 31/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDCommentsTableView.h"

@interface PDCommentsTableView (Private) 
@end


@implementation PDCommentsTableView

- (void)initTable
{
	[super initTable];
    self.canReply = YES;
	commentCellExample = [UIView loadFromNibNamed:@"PDCommentCell"];
	self.tableViewMode = PDItemsTableViewModeList;
}

- (void)setItems:(NSArray *)newItems
{
	newItems = [newItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		return [[obj2 date] compare:[obj1 date]];
	}];
	[super setItems:newItems];
}

- (IBAction)addComment:(id)sender 
{

}

#pragma mark - Table delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	commentCellExample.commentTextLabel.text = [[self.items objectAtIndex:indexPath.row] comment];
	CGFloat newHeight = [commentCellExample.commentTextLabel sizeThatFits:
						 CGSizeMake(commentCellExample.commentTextLabel.bounds.size.width, MAXFLOAT)].height;
    return commentCellExample.commentTextLabel.y + newHeight + 27;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CommentCellIdentifier = @"PDCommentCell";
	PDCommentCell *cell = (PDCommentCell *) [tableView dequeueReusableCellWithIdentifier:CommentCellIdentifier];
	if (!cell) {		
		cell = [UIView loadFromNibNamed:CommentCellIdentifier];
		cell.delegate = _commentCellDelegate;
	}
    
    if (!self.canReply) {
        [cell disableReply];
    }

	cell.tag = indexPath.row;
	cell.comment = [self.items objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
