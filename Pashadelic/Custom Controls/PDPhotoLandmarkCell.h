//
//  PDPhotoLandmarkCell.h
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import <UIKit/UIKit.h>
#import "PDPhotoLandMarkItem.h"
#import "PDDynamicFontLabel.h"

@interface PDPhotoLandmarkCell : UITableViewCell
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) id <PDPhotoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) PDPhotoLandMarkItem * landMarkItem;
@property (weak, nonatomic) IBOutlet UIImageView *photoCountImage;
@property (weak, nonatomic) IBOutlet UIImageView *userCountImage;
@property (weak, nonatomic) IBOutlet UIImageView *angleRightImage;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *photoCountLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *userCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLandmarkLabel;

@end
