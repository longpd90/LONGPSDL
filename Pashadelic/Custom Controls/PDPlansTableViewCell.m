//
//  PDPlansTableViewCell.m
//  Pashadelic
//
//  Created by LongPD on 11/7/13.
//
//

#import "PDPlansTableViewCell.h"
#import "PDPlanDetailViewController.h"
#import "Globals.h"
#import "NSDate+Extra.h"
#define MaxHeightLocationLabel 29

@implementation PDPlansTableViewCell

- (void)awakeFromNib
{
	[self setUpInterface];
}

- (IBAction)showPlanDetail:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDShowPlanDetail object:self.plan];
}

- (void)setPlanItem:(PDPlan *)plan
{
    self.plan = plan;
    [self.avatarImageView sd_setImageWithURL:plan.photo.thumbnailURL placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
    self.nameLabel.text = plan.name;
    
    self.localLabel.text = plan.address;
    CGSize localLabelSize = [self.localLabel.text sizeWithFont:self.localLabel.font constrainedToSize:CGSizeMake(self.localLabel.width, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    self.localLabel.height = MIN(localLabelSize.height, MaxHeightLocationLabel);
    NSDate *timePlan = [self localTimeFromUTC:plan.time];
    NSString *montString = [timePlan stringValueFormattedBy:@"MMM"];
    NSString *dayString = [timePlan stringValueFormattedBy:@"dd"];
    NSString *yearString = [timePlan stringValueFormattedBy:@"yyyy"];
    NSString *timeString = [timePlan stringValueFormattedBy:@"HH:mm"];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@, %@ %@",montString,dayString,yearString,timeString];
    self.monthLabel.text = montString;
    self.dayLabel.text = dayString;
}

- (void)setHiddenViewButton:(BOOL)hidden
{
    self.viewPlanButton.hidden = hidden;
}

- (void)setUpInterface
{
    [self.viewPlanButton setTitle:NSLocalizedString(@"View", nil) forState:UIControlStateNormal];
    self.backGroundView.layer.cornerRadius = 4;
	self.backGroundView.layer.shadowOffset = CGSizeMake(1, 1);
	self.backGroundView.layer.shadowOpacity = 0.5;
	self.backGroundView.layer.shadowRadius = 2;
	self.backGroundView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
	self.backGroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.backGroundView.layer.borderWidth = 0.5;
	[self.backGroundView rasterizeLayer];
    
    CAShapeLayer *maskLayerOverView = [CAShapeLayer layer];
	maskLayerOverView.frame = self.overlayView.bounds;
	UIBezierPath *roundedPathOverView =
	[UIBezierPath bezierPathWithRoundedRect:maskLayerOverView.bounds
						  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
								cornerRadii:CGSizeMake(4, 4)];
	maskLayerOverView.path = [roundedPathOverView CGPath];
	
	self.overlayView.layer.mask = maskLayerOverView;
    
    CAShapeLayer *maskLayerBlackView = [CAShapeLayer layer];
	maskLayerBlackView.frame = self.blackView.bounds;
	UIBezierPath *roundedPathBlackView =
	[UIBezierPath bezierPathWithRoundedRect:maskLayerBlackView.bounds
						  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
								cornerRadii:CGSizeMake(4, 4)];
	maskLayerBlackView.path = [roundedPathBlackView CGPath];

	self.blackView.layer.mask = maskLayerBlackView;
    
    self.viewPlanButton.layer.cornerRadius = 4;
    [self.viewPlanButton setBackgroundColor:kPDGlobalRedColor];
}

- (NSDate *)localTimeFromUTC:(NSString *)utcTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter dateFromString:utcTimeString];
}

@end
