//
//  PDDatePickerViewController.h
//  Pashadelic
//
//  Created by LongPD on 2/24/14.
//
//

#import "PDViewController.h"
#import "PDActionSheetCustomDatePicker.h"
#import "CDatePickerViewEx.h"
#define kPDUnitConverDateToNumber 31
#define kMonthComponent 1
#define kDayComponent   0

@class PDDynamicFontLabel;

@interface PDDatePickerViewController : PDViewController

@property (weak, nonatomic) IBOutlet UIView *viewFrom;
@property (weak, nonatomic) IBOutlet UIButton *btnDateFromTo;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnResetFrom;

@property (weak, nonatomic) IBOutlet UIView *viewTo;
@property (weak, nonatomic) IBOutlet UIButton *btnDateTo;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *toValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnResetTo;

@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet CDatePickerViewEx *datePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormater;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (strong, nonatomic) NSArray *months;

@property (nonatomic, assign) double selectedDistance;
@property (nonatomic, assign) NSInteger selectedSorting;
@property (nonatomic, assign) NSInteger date_from;
@property (nonatomic, assign) NSInteger date_to;
@property (nonatomic, assign) NSInteger time_from;
@property (nonatomic, assign) NSInteger time_to;


- (id)initWithNibName:(NSString *)nibNameOrNil datePickerMode:(UIDatePickerMode)pickerMode;
- (IBAction)setDate:(id)sender;
- (IBAction)refreshButton:(id)sender;
- (IBAction)closeButton:(id)sender;
- (IBAction)doneButton:(id)sender;
- (IBAction)resetFromTime:(id)sender;
- (IBAction)resetToTime:(id)sender;
- (void)saveDateFilter;
@end
