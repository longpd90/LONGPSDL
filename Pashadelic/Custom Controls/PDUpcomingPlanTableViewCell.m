//
//  PDUpcomingPlanTableViewCell.m
//  Pashadelic
//
//  Created by LongPD on 8/26/14.
//
//

#import "PDUpcomingPlanTableViewCell.h"

@implementation PDUpcomingPlanTableViewCell

- (void)awakeFromNib
{
}

- (void)setPlan:(PDPlan *)plan
{
    _plan = plan;
    CAShapeLayer *maskLayerBlackView = [CAShapeLayer layer];
	maskLayerBlackView.frame = self.photoOfPlan.bounds;
	UIBezierPath *roundedPathBlackView =
	[UIBezierPath bezierPathWithRoundedRect:maskLayerBlackView.bounds
						  byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft
								cornerRadii:CGSizeMake(4, 4)];
	maskLayerBlackView.path = [roundedPathBlackView CGPath];
    
    self.numberSpotView.layer.borderColor = [UIColor colorWithWhite:0.96 alpha:1].CGColor;
    self.numberSpotView.layer.borderWidth = 1;
	self.photoOfPlan.layer.mask = maskLayerBlackView;
    self.bgView.layer.borderColor = [UIColor colorWithWhite:0.96 alpha:1].CGColor;
    self.bgView.layer.borderWidth = 1;
    [self.photoOfPlan sd_setImageWithURL:[self urlOfPlanImage]  placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
    
    CGSize textSize = [plan.name sizeWithFont:self.planName.font];
    if (textSize.width < self.planName.width) {
        self.planName.height = 20;
    } else
        self.planName.height = 40;
    self.planName.text = plan.name;
    self.addressLabel.y = self.planName.bottomYPoint;
    self.dateLabel.y = self.addressLabel.bottomYPoint;
    if (self.plan.address == nil || [self.plan.address isEqualToString:@""]) {
        self.addressLabel.text = [NSString stringWithFormat:NSLocalizedString(@"in %f, %f", nil), self.plan.latitude, self.plan.longitude];
    } else
            self.addressLabel.text = [NSString stringWithFormat:NSLocalizedString(@"in %@", nil), plan.address];


    NSDate *timePlan = [self localTimeFromUTC:plan.time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy"];
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Date: %@", nil), [dateFormatter stringFromDate:timePlan]];
    self.joinedLabel.transform = CGAffineTransformMakeRotation(- M_PI/4);
    int spotsLeft = plan.capacity - plan.participantsCount;
    self.numberSpotLeft.text = [NSString stringWithFormat:@"%d",spotsLeft];
    if (spotsLeft < 2) {
        self.spotsLeftLable.text = NSLocalizedString(@"spot left", nil);
    } else {
        self.spotsLeftLable.text = NSLocalizedString(@"spots left", nil);
    }
    
    if (plan.userID == kPDUserID) {
        self.numberSpotView.hidden = YES;
        self.viewLabel.hidden = NO;
        self.joinedLabel.hidden = YES;
    } else {
        self.numberSpotView.hidden = NO;
        self.viewLabel.hidden = YES;
        if (plan.joinStatus == true) {
            self.joinedLabel.hidden = NO;
        } else self.joinedLabel.hidden = YES;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
    
}

- (NSDate *)localTimeFromUTC:(NSString *)utcTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter dateFromString:utcTimeString];
}


- (NSURL *)urlOfPlanImage
{
    if (self.plan.photo.thumbnailURL == nil) {
        NSString *url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?"
                         "center=%f,%f"
                         "&zoom=%zd"
                         "&size=%zdx%zd"
                         "&scale=%zd"
                         "&sensor=false"
                         "&api_key=%@",
                         self.plan.latitude, self.plan.longitude,
                         12,
                         90, 90,
                         (NSInteger)[[UIScreen mainScreen] scale],
                         kPDGoogleMapsAPIToken];
        return [NSURL URLWithString:url];
    } else return self.plan.photo.thumbnailURL;
    
}

@end
