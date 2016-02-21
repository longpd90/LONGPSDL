//
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 06.09.13.
//
//

#import "PDDrawMoon.h"
#import "PDPhotoTableViewController.h"
#import "PDDynamicFontLabel.h"
#import "PDEffectCircleExpandView.h"

@class PDLogoProgressView;

@interface PDTodayPhotoViewController : PDPhotoTableViewController

@property (strong, nonatomic) PDPhoto *todaysPhoto;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *todayPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *todayUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *todayUsernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIButton *homepageButton;
@property (strong, nonatomic) IBOutlet UIView *todaysPhotoInfoView;
@property (weak, nonatomic) IBOutlet UIButton *todaysPhotoPinButton;
@property (weak, nonatomic) IBOutlet UIButton *todaysPhotoLikeButton;
@property (weak, nonatomic) IBOutlet UIButton *todaysPhotoUserButton;
@property (weak, nonatomic) IBOutlet UIView *todaysPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *todaysPhotoLabel;
@property (weak, nonatomic) IBOutlet PDEffectCircleExpandView *circleExpand;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet PDLogoProgressView *progressView;

- (IBAction)likeTodaysPhoto:(id)sender;
- (IBAction)followTodaysUser:(id)sender;
- (IBAction)pinTodaysPhoto:(id)sender;
- (IBAction)showTodaysUserInfo:(id)sender;
- (IBAction)showHomepage:(id)sender;

@end
