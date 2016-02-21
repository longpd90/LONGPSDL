//
//  PDReviewsTableView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDReviewsTableView.h"

@implementation PDReviewsTableView

- (void)setTableViewMode:(PDItemsTableViewMode)tableViewMode
{
	[super setTableViewMode:PDItemsTableViewModeList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.items.count;
}

- (void)setItems:(NSArray *)items
{
	for (PDReview *review in items) {
		review.showFullDescription = NO;
	}
	[super setItems:items];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	PDReview *review = self.items[indexPath.row];
	int height = [review.text sizeWithFont:[UIFont fontWithName:PDGlobalNormalFontName size:14] constrainedToSize:CGSizeMake(304, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail].height;
	if (height <= 40) {
		return 104 + height - 23;
	} else {
		if (review.showFullDescription) {
			return 104 + height;
		} else {
			return 104 + 40;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ReviewTableCell = @"PDReviewTableCell";
	PDReviewTableCell *cell = (PDReviewTableCell *) [tableView dequeueReusableCellWithIdentifier:ReviewTableCell];
	if (!cell) {
		cell = [UIView loadFromNibNamed:ReviewTableCell];
	}
	
	cell.review = self.items[indexPath.row];
	
	return cell;
}

@end
