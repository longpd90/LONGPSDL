//
//  PDTipsViewViewController.h
//  Pashadelic
//
//  Created by LongPD on 3/5/14.
//
//

#import "PDViewController.h"
#import "PDDynamicFontButton.h"

@interface PDPhotoTipsViewController : PDViewController

@property (weak, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *tipTitleLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *tripodLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *tripodYesButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *tripodNoButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *crowededLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *crowededYesButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *crowededNoButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *nearbyLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *nearbyYesButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *nearbyNoButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *dangerousLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *dangerousYesButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *dangerousNoButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *indoorLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *indoorYesButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *indoorNoButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *permissionLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *permissionYesButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *permissionNoButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *payLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *payYesButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *payNoButton;

@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegment;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

- (IBAction)selectedTips:(UIButton *)sender;

@end
