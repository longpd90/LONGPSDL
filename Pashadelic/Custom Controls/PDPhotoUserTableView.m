//
//  PDPhotoUserTableView.m
//  Pashadelic
//
//  Created by LongPD on 12/23/13.
//
//

#import "PDPhotoUserTableView.h"
#define kPDPhotoUserListCellDetailsHeight 30

@implementation PDPhotoUserTableView

#pragma mark - Table delegate

- (NSInteger)listCellHeightForIndex:(NSInteger)index
{
	PDPhoto *photo = [self.items objectAtIndex:index];
	return kPDPhotoUserListCellDetailsHeight + photo.photoListImageSize.height;
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
		int count = 3;
		if (indexPath.row == self.items.count / 3)
			count = self.items.count % 3;
		cell.photos = [self.items subarrayWithRange:NSMakeRange(indexPath.row * 3, count)];
        
		return cell;
		
	} else {
        NSString *PDPhotoUserCellIdentifier = @"PDPhotoUserCell";
		PDPhotoListCell *cell = (PDPhotoListCell *) [tableView dequeueReusableCellWithIdentifier:PDPhotoUserCellIdentifier];
		if (!cell) {
			cell = [UIView loadFromNibNamed:PDPhotoUserCellIdentifier];
		}
		PDPhoto *photo = (PDPhoto *)[self.items  objectAtIndex:indexPath.row];
        [cell setItem:photo];
		if (!photo.spotId) {
            cell.overlayView.hidden = NO;
        } else cell.overlayView.hidden = YES;
		return cell;
	}
}

@end
