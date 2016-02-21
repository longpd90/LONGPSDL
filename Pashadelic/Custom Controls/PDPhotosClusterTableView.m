//
//  PDPhotosClusterTableView.m
//  Pashadelic
//
//  Created by TungNT2 on 3/10/14.
//
//

#import "PDPhotosClusterTableView.h"

@implementation PDPhotosClusterTableView

- (void)initTable
{
    [super initTable];
    self.tableRefreshView.hidden = YES;
    self.tableViewMode = PDItemsTableViewModeTile;
}

- (void)setTableViewMode:(PDItemsTableViewMode)tableViewMode
{
    [super setTableViewMode:PDItemsTableViewModeTile];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{}

@end
