//
//  PDFilterSearchViewController.h
//  Pashadelic
//
//  Created by LongPD on 2/21/14.
//
//

#import "PDDatePickerViewController.h"
#import "PDTextField.h"
#import "PDExploreViewController.h"

@class PDFilterSearchViewController;

@protocol PDFilterSearchViewControllerDelegate <NSObject>

- (void)filterDidFinish;

@end


@interface PDFilterSearchViewController : PDViewController

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconAngleRightDate;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconAngleRightTime;

@property (weak, nonatomic) IBOutlet UILabel *sortbyLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSegemented;
@property (weak, nonatomic) IBOutlet UIImageView *iconCaretDown;

@property (weak, nonatomic) IBOutlet UIView *rangeView;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet PDTextField *distanceTextField;
@property (weak, nonatomic) IBOutlet UIView *distanceUnitView;
@property (weak, nonatomic) IBOutlet UIButton *kmButton;
@property (weak, nonatomic) IBOutlet UIButton *milesButton;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationSpecificLabel;

@property (nonatomic, strong) NSString *locationSpecific;
@property (strong, nonatomic) UIImageView *topbarArrow;
@property (strong, nonatomic) PDDatePickerViewController *datePickerViewController;
@property (nonatomic, assign) BOOL datePickerShowing;
@property (nonatomic, assign) BOOL showingUnitTable;
@property (nonatomic, assign) NSInteger selectedSorting;

@property (weak, nonatomic) id <PDFilterSearchViewControllerDelegate> delegate;

- (IBAction)selectDatePhotographed:(id)sender;
- (IBAction)selectTimePhotographed:(id)sender;
- (IBAction)sortSegmented:(id)sender;
- (IBAction)showDistanceUnit:(id)sender;
- (void)setLocationSpecific:(NSString *)locationSpecific;
@end
