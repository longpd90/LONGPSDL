//
//  PDReviewTableCell.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.07.13.
//
//

#import <UIKit/UIKit.h>
#import "PDPOIItem.h"
#import "PDRatingView.h"
#import "PDReview.h"
#import "MGLocalizedButton.h"

@interface PDReviewTableCell : UITableViewCell


@property (weak, nonatomic) PDReview *review;
@property (weak, nonatomic) IBOutlet PDRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewTextLabel;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *readMoreButton;

- (IBAction)readMoreButtonTouch:(id)sender;
- (void)layoutCell;

@end
