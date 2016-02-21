//
//  PDUpcomingPlanTableViewCell.h
//  Pashadelic
//
//  Created by LongPD on 8/26/14.
//
//

#import <UIKit/UIKit.h>
#import "PDDynamicFontButton.h"
#import "PDDynamicFontLabel.h"
#import "PDPlan.h"

@interface PDUpcomingPlanTableViewCell : UITableViewCell

@property (strong, nonatomic) PDPlan *plan;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *photoOfPlan;
@property (weak, nonatomic) IBOutlet UILabel *planName;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *numberSpotView;
@property (weak, nonatomic) IBOutlet UILabel *numberSpotLeft;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *joinedLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *viewLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *spotsLeftLable;

@end
