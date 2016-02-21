//
//  PDLandmarkAnnotationCalloutView.h
//  Pashadelic
//
//  Created by LTT on 6/19/14.
//
//

#import <UIKit/UIKit.h>
#import "MGLocalizedLabel.h"
#import "PDLocation.h"

@interface PDLandmarkAnnotationCalloutView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *landmarkAvatar;
@property (weak, nonatomic) IBOutlet MGLocalizedLabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *photoCountImage;

@property (weak, nonatomic) IBOutlet MGLocalizedLabel *photosLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userCountImage;
@property (weak, nonatomic) IBOutlet MGLocalizedLabel *usersLabel;
@property (strong, nonatomic) PDLocation *location;
@end
