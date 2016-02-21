//
//  PDReviewTableCell.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import "PDReviewTableCell.h"

@implementation PDReviewTableCell

- (void)setReview:(PDReview *)review
{
	_review = review;
	self.reviewTextLabel.text = review.text;
	self.titleLabel.text = review.username;
	self.ratingView.rating = review.rating;
	self.readMoreButton.selected = review.showFullDescription;
	self.dateLabel.text = [review.date stringValueFormattedBy:@"MMMM d, yyyy"];
	[self.userAvatarImageView sd_setImageWithURL:review.thumbnailURL];
	[self layoutCell];
}

- (void)layoutCell
{
	int height = [self.reviewTextLabel sizeThatFits:CGSizeMake(self.width, MAXFLOAT)].height;

	if (height <= 40) {
		self.reviewTextLabel.numberOfLines = 2;
		self.readMoreButton.hidden = YES;
		self.reviewTextLabel.height = height;
		
	} else {
		if (self.review.showFullDescription) {
			self.reviewTextLabel.numberOfLines = 0;
			self.reviewTextLabel.height = height;
			
		} else {
			self.reviewTextLabel.numberOfLines = 2;
			self.reviewTextLabel.height = 40;
		}
		self.readMoreButton.hidden = NO;
		self.readMoreButton.y = self.reviewTextLabel.bottomYPoint - 10;
	}

}

- (IBAction)readMoreButtonTouch:(id)sender
{
	self.review.showFullDescription = !self.review.showFullDescription;
	self.readMoreButton.selected = self.review.showFullDescription;
	UITableView *tableView = (UITableView *) self.superview;
	if (![tableView isKindOfClass:[UITableView class]]) return;
		
	[tableView reloadRowsAtIndexPaths:@[[tableView indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
