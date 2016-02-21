//
//  PDFeedTableView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.11.12.
//
//

#import "PDFeedTableView.h"

@implementation PDFeedTableView

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

@end
