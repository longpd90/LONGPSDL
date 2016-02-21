//
//  PDPlansTableViewCell.h
//  Pashadelic
//
//  Created by LongPD on 11/7/13.
//
//

#import "PDPlan.h"

@interface PDPlansTableViewCell : UITableViewCell
@property (weak, nonatomic) id <PDPhotoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewPlanButton;
@property (weak, nonatomic) PDPlan *plan;
@property (strong, nonatomic)PDPhoto *photo;

- (IBAction)showPlanDetail:(id)sender;
- (void)setPlanItem:(PDPlan *)plan;
- (void)setHiddenViewButton:(BOOL)hidden;

@end
