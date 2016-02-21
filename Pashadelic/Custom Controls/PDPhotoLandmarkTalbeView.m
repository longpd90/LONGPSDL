//
//  PDPhotoLandmarkTalbeView.m
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDPhotoLandmarkTalbeView.h"

@implementation PDPhotoLandmarkTalbeView

- (NSInteger)listCellHeightForIndex:(NSInteger)index
{
    return 352;
}

- (void)setTableViewMode:(PDItemsTableViewMode)tableViewMode
{
	[super setTableViewMode:PDItemsTableViewModeList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *PDPhotoLandmarkCellIdentifier = @"PDPhotoLandmarkCell";
	PDPhotoLandmarkCell *cell = (PDPhotoLandmarkCell *) [tableView dequeueReusableCellWithIdentifier:PDPhotoLandmarkCellIdentifier];
	if (!cell) {
		cell = [UIView loadFromNibNamed:PDPhotoLandmarkCellIdentifier];
	}
	cell.delegate = self.photoViewDelegate;
	cell.landMarkItem = [self.items objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row > self.items.count) return;
    PDPhotoLandMarkItem *landmarkItem = (PDPhotoLandMarkItem *)[self.items objectAtIndex:indexPath.row];
    if (landmarkItem.itemDelegate && [landmarkItem.itemDelegate respondsToSelector:@selector(itemDidSelect:)])
        [landmarkItem.itemDelegate itemDidSelect:landmarkItem];
}

@end
