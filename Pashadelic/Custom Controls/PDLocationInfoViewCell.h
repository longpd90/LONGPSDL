//
//  PDLocationViewCell.h
//  Pashadelic
//
//  Created by LongPD on 6/18/14.
//
//

#import <UIKit/UIKit.h>
#import "PDDynamicFontLabel.h"
#import "PDLocation.h"

@interface PDLocationInfoViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *landmarkCountlabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *usercountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *angleRightImageView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *namLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) PDLocation *locationItem;
@end
