//
//  PDDatePickerViewController.m
//  Pashadelic
//
//  Created by LongPD on 2/24/14.
//
//

#import "PDDatePickerViewController.h"
#import "PDDynamicFontLabel.h"

@interface PDDatePickerViewController ()
@end

@implementation PDDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil datePickerMode:(UIDatePickerMode)pickerMode
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        self.datePickerMode = pickerMode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleBlack];
    [self initialize];
    [self refreshButton:self.btnDateFromTo];
    [self setModeForDatePicker:_datePickerMode];
    [self showDatePicker];
    [self hiddenResetButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)pageName
{
	if (_datePickerMode == UIDatePickerModeDate)
        return @"Explore Filter Date";
    else
        return @"Explore Filter Time";
}

- (void)initialize
{
    [_btnResetFrom setTitle:NSLocalizedString(@"reset", nil) forState:UIControlStateNormal];
    [_btnResetTo setTitle:NSLocalizedString(@"reset", nil) forState:UIControlStateNormal];
    [_closeButton setTitle:NSLocalizedString(@"close", nil) forState:UIControlStateNormal];
    [_doneButton setTitle:NSLocalizedString(@"done", nil) forState:UIControlStateNormal];
    
    if (_datePickerMode == UIDatePickerModeDate) {
        self.title = NSLocalizedString(@"set date", nil);
        _fromLabel.text = NSLocalizedString(@"from date", nil);
        _toLabel.text = NSLocalizedString(@"to date", nil);
    } else {
        self.title = NSLocalizedString(@"set time", nil);
        _fromLabel.text = NSLocalizedString(@"from time", nil);
        _toLabel.text = NSLocalizedString(@"to date", nil);
    }
    
    _dateFormater = [[NSDateFormatter alloc] init];
    [_dateFormater setDateFormat:@"MM-dd HH:mm"];
    self.months = [NSArray arrayWithObjects:@"January", @"February", @"March", @"April", @"May", @"June",
                   @"July", @"August", @"September", @"October", @"November", @"December", nil];
}

- (void)setModeForDatePicker:(UIDatePickerMode )datePickerMode
{
    if (datePickerMode == UIDatePickerModeDate) {
        [self setTextDateLabel:nil];
        self.datePicker.x = 40;
        self.overlayRightView.hidden = NO;
        self.overlayLeftView.hidden = NO;
    } else {
        [self setTextTimeLabel:nil];
        self.datePicker.x = 0;
        self.overlayRightView.hidden = YES;
        self.overlayLeftView.hidden = YES;    }
    [self.datePicker setDatePickerMode:datePickerMode];
}

- (void)setTextDateLabel:(id)sender
{
    if (kPDFilterNearbyDateFrom != 0){
         _date_from = kPDFilterNearbyDateFrom;
        NSInteger monthFrom = [self convertNumberToMonth:_date_from];
        NSInteger dayFrom = [self convertNumberToDay:_date_from];
        self.fromValueLabel.text = [NSString stringWithFormat:@"%@/%d",self.months[monthFrom - 1], dayFrom];
        if (self.btnDateFromTo.selected) {
            NSDate *date = [_dateFormater dateFromString:[NSString stringWithFormat:@"%d-%d 00:00", monthFrom, dayFrom]];
            [_datePicker setDate:date];
        }
    }
    
    if (kPDFilterNearbyDateTo != 0) {
        self.btnResetTo.hidden = NO;
        _date_to = kPDFilterNearbyDateTo;
        NSInteger monthTo = [self convertNumberToMonth:_date_to];
        NSInteger dayTo = [self convertNumberToDay:_date_to];
        self.toValueLabel.text = [NSString stringWithFormat:@"%@/%d",self.months[monthTo - 1], dayTo];
        if (self.btnDateTo.selected) {
            NSDate *date = [_dateFormater dateFromString:[NSString stringWithFormat:@"%d-%d 00:00", monthTo, dayTo]];
            [_datePicker setDate:date];
        }
    }else{
        self.btnResetTo.hidden = YES;
    }
}

- (void)setTextTimeLabel:(id)sender
{
    if (kPDFilterNearbyTimeFrom != 0){
        self.btnResetFrom.hidden = NO;
        _time_from = kPDFilterNearbyTimeFrom;
        NSInteger minuteFrom = [self minuteFromNumber:_time_from];
        NSInteger hourFrom = [self hourFromNumber:_time_from];
        NSString *aMOrPmFrom = @"AM";
        if (self.btnDateFromTo.selected) {
            NSDate *date = [_dateFormater dateFromString:[NSString stringWithFormat:@"1-1 %d:%d", hourFrom, minuteFrom]];
            [_datePicker setDate:date];
        }
        if (hourFrom > 12) {
            hourFrom = hourFrom % 12;
            aMOrPmFrom = @"PM";
        }
        self.fromValueLabel.text = [NSString stringWithFormat:@"%d:%0.2d %@", hourFrom, minuteFrom, aMOrPmFrom];
    } else {
        self.btnResetFrom.hidden = YES;
    }
    
    if (kPDFilterNearbyTimeTo != 0) {
        self.btnResetTo.hidden = NO;
        _time_to = kPDFilterNearbyTimeTo;
        NSInteger minuteTo = [self minuteFromNumber:_time_to];
        NSInteger hourTo = [self hourFromNumber:_time_to];
        if (self.btnDateTo.selected) {
            NSDate *date = [_dateFormater dateFromString:[NSString stringWithFormat:@"1-1 %d:%d", hourTo, minuteTo]];
            [_datePicker setDate:date];
        }
        NSString *aMOrPmTo = @"AM";
        if (hourTo > 12) {
            hourTo = hourTo % 12;
            aMOrPmTo = @"PM";
        }
        self.toValueLabel.text = [NSString stringWithFormat:@"%d:%0.2d %@", hourTo, minuteTo, aMOrPmTo];

    }else{
        self.btnResetTo.hidden = YES;
    }
}

#pragma mark - action

- (void)hiddenResetButton
{
    if (_datePickerMode == UIDatePickerModeDate) {
        if (self.btnDateFromTo.selected) {
            if (kPDFilterNearbyDateFrom != 0){
                self.btnResetFrom.hidden = NO;
            }
            else{
                self.btnResetFrom.hidden = YES;
            }
        } else {
            if (kPDFilterNearbyDateTo != 0){
                self.btnResetTo.hidden = NO;
            }
            else{
                self.btnResetTo.hidden = YES;
            }
        }
    } else {
        if (self.btnDateFromTo.selected) {
            if (kPDFilterNearbyTimeFrom != 0){
                self.btnResetFrom.hidden = NO;
            }
            else{
                self.btnResetFrom.hidden = YES;
            }
        } else {
            if (kPDFilterNearbyTimeTo != 0){
                self.btnResetTo.hidden = NO;
            }
            else{
                self.btnResetTo.hidden = YES;
            }
        }
    }

}

- (IBAction)setDate:(id)sender {
    if (_datePickerMode == UIDatePickerModeDate) {
        [self setupDate:_datePicker.date];
        [self saveDateFilter];
    } else {
        [self setupTime:_datePicker.date];
        [self saveTimeFilter];
    }
}

- (IBAction)refreshButton:(id)sender {
    [self hiddenDatePicker];
    [self showDatePicker];
    if (sender == self.btnDateFromTo) {
        self.btnDateFromTo.selected = YES;
        self.btnDateTo.selected = NO;
        self.viewFrom.backgroundColor = kPDGlobalGrayColor;
        self.viewTo.backgroundColor = [UIColor whiteColor];

    } else {
        self.btnDateFromTo.selected = NO;
        self.btnDateTo.selected = YES;
        self.viewFrom.backgroundColor = [UIColor whiteColor];
        self.viewTo.backgroundColor = kPDGlobalGrayColor;
    }
    if (_datePickerMode == UIDatePickerModeDate) {
        [self setTextDateLabel:nil];
    } else {
        [self setTextTimeLabel:nil];
    }
}

- (IBAction)closeButton:(id)sender {
    [self hiddenDatePicker];
    self.viewFrom.backgroundColor = [UIColor whiteColor];
    self.viewTo.backgroundColor = [UIColor whiteColor];
}

- (IBAction)doneButton:(id)sender {
    [self hiddenDatePicker];
    self.viewFrom.backgroundColor = [UIColor whiteColor];
    self.viewTo.backgroundColor = [UIColor whiteColor];
    [self setDate:sender];
}

- (IBAction)resetFromTime:(id)sender {
    self.btnResetFrom.hidden = YES;
    _fromValueLabel.text = @"";
    if (_datePickerMode == UIDatePickerModeDate) {
        self.date_from = 0;
        [self saveDateFilter];
    } else {
        self.time_from = 0;
        [self saveTimeFilter];
    }
}

- (IBAction)resetToTime:(id)sender {
    self.btnResetTo.hidden = YES;
    _toValueLabel.text = @"";
    if (_datePickerMode == UIDatePickerModeDate) {
        self.date_to = 0;
        [self saveDateFilter];
    } else {
        self.time_to = 0;
        [self saveTimeFilter];
    }
}

- (void)showDatePicker
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _datePickerView.y = 165;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)hiddenDatePicker
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _datePickerView.y = self.view.height;
                     }
                     completion:^(BOOL finished){
                     }];
}

#pragma mark - save date

- (void)setupTime:(NSDate *)time
{
    NSInteger hour = [[time stringValueFormattedBy:@"HH"] intValue];
    NSInteger minute = [[time stringValueFormattedBy:@"mm"] intValue];
    
    if (self.btnDateFromTo.selected) {
        self.btnResetFrom.hidden = NO;
        float  new_time_from = [self timeFromHours:hour minutes:minute];
        if (_time_to > 0 && new_time_from > _time_to) {
            new_time_from = _time_to;
            hour = [self hourFromNumber:new_time_from];
            minute = [self minuteFromNumber:new_time_from];
        }
        if (_time_from != new_time_from) {
            self.time_from = new_time_from;
        }
        NSString *am_OR_pm = @"AM";
        if (hour > 12) {
            hour = hour%12;
            am_OR_pm = @"PM";
        }
        _fromValueLabel.text  = [NSString stringWithFormat:@"%d:%0.2d %@", hour, minute, am_OR_pm];
    } else {
        self.btnResetTo.hidden = NO;
        float new_time_to = [self timeFromHours:hour minutes:minute];
        if (new_time_to < _time_from) {
            new_time_to = _time_from;
            hour = [self hourFromNumber:new_time_to];
            minute = [self minuteFromNumber:new_time_to];
        }
        if (self.time_to != new_time_to) {
            self.time_to = new_time_to;
        }
        NSString *am_OR_pm = @"AM";
        if (hour > 12) {
            hour = hour%12;
            am_OR_pm = @"PM";
        }
        _toValueLabel.text  = [NSString stringWithFormat:@"%d:%0.2d %@", hour, minute, am_OR_pm];
    }

}

- (void)setupDate:(NSDate *)date
{
    NSInteger dayValue = [[date stringValueFormattedBy:@"dd"] intValue] ;
    NSInteger monthValue = [[date stringValueFormattedBy:@"MM"] intValue] ;
    if (self.btnDateFromTo.selected) {
        self.btnResetFrom.hidden = NO;
        float new_date_from = [self convertDateToNumber:monthValue days:dayValue];
        if (self.date_to && new_date_from > self.date_to) {
            new_date_from = self.date_to;
            monthValue = [self convertNumberToMonth:new_date_from];
            dayValue = [self convertNumberToDay:new_date_from];
        }
        if (self.date_from != new_date_from) {
            self.date_from = new_date_from;
        }
        _fromValueLabel.text  = [NSString stringWithFormat:@"%@/%d",self.months[monthValue -1], dayValue];

    } else {
        self.btnResetTo.hidden = NO;
        float new_date_to = [self convertDateToNumber:monthValue days:dayValue];
        if (self.date_from && new_date_to < self.date_from) {
            new_date_to = self.date_from;
            monthValue = [self convertNumberToMonth:new_date_to];
            dayValue = [self convertNumberToDay:new_date_to];
        }
        if (self.date_to != new_date_to) {
            self.date_to = new_date_to;
        }
        _toValueLabel.text  = [NSString stringWithFormat:@"%@/%d", self.months[monthValue -1], dayValue];
    }
}

- (void)saveDateFilter
{
    if (self.date_from >= 0) {
        [kPDUserDefaults setInteger:self.date_from forKey:kPDFilterNearbyDateFromKey];
    }
    if (self.date_to >= 0) {
        [kPDUserDefaults setInteger:self.date_to forKey:kPDFilterNearbyDateToKey];
    }
}

- (void)saveTimeFilter
{
    if (self.time_from >= 0) {
        [kPDUserDefaults setInteger:self.time_from forKey:kPDFilterNearbyTimeFromKey];
    }
    if (self.time_to >= 0) {
        [kPDUserDefaults setInteger:self.time_to forKey:kPDFilterNearbyTimeToKey];
    }
}

- (void)goBack:(id)sender
{
    [super goBack:sender];
}

#pragma mark - convert date

- (NSInteger)convertDateToNumber:(NSInteger)months days:(NSInteger)days
{
    return months * kPDUnitConverDateToNumber + days;
}

- (NSInteger)timeFromHours:(NSInteger)hours minutes:(NSInteger)minutes
{
    return (hours*60 + minutes);
}

- (NSInteger)convertNumberToDay:(NSInteger)number
{
    return (number % kPDUnitConverDateToNumber);
}

- (NSInteger)convertNumberToMonth:(NSInteger)number
{
    return (int)(number / kPDUnitConverDateToNumber);
}

- (NSInteger)hourFromNumber:(NSInteger)number
{
    return (int)(number / 60);
}

- (NSInteger)minuteFromNumber:(NSInteger)number
{
    return (number % 60);
}

@end
