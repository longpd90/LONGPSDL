//
//  PDPhotoSpotsView.m
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import "PDPhotoSpotsView.h"
#import "PDActionSheetTimePicker.h"
#define  kPDUnitConverDateToNumber 31

@interface PDPhotoSpotsView (Private)
- (void)initInterface;
- (void)dateBeginWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)dateEndWasSelected:(NSDate *)selectedDate element:(id)element;
- (void)timeBeginWasSelected:(NSDate *)selectedTime element:(id)element;
- (void)timeEndWasSelected:(NSDate *)selectedTime element:(id)element;
- (void)dateFilterDidChange;
- (void)timeFilterDidChange;
@end
@implementation PDPhotoSpotsView
@synthesize btnPhotos20;
@synthesize btnPhotos50;
@synthesize btnPhotos100;
@synthesize btnPhotosFavorites;
@synthesize btnPhotosNews;
@synthesize btnDateFromTo;
@synthesize btnDateTo;
@synthesize btnTimeFromTo;
@synthesize btnTimeTo;

- (id)init
{
    self = [UIView loadFromNibNamed:@"PDPhotoSpotsView"];
    if (self) {
        // Initialization code
        [self initInterface];
        self.selectedTimeBegin = [NSDate date];
    }
    return self;
}

- (void)initInterface
{
    self.rangeLabel.text = NSLocalizedString(@"# photos", nil);
    self.sortLabel.text = NSLocalizedString(@"sort by", nil);
    self.filterbyDateLabel.text = NSLocalizedString(@"filter by date", nil);
    self.filterbyTimeLabel.text = NSLocalizedString(@"filter by time", nil);
    [self.btnDateFromTo setTitle:NSLocalizedString(@"from to", nil) forState:UIControlStateNormal];
    [self.btnDateTo setTitle:NSLocalizedString(@"to", nil) forState:UIControlStateNormal];
    [self.btnTimeFromTo setTitle:NSLocalizedString(@"from to", nil) forState:UIControlStateNormal];
    [self.btnTimeTo setTitle:NSLocalizedString(@"to", nil) forState:UIControlStateNormal];
    
    if (kPDPhotoToolsNearbyRange > 0) {
        btnPhotos20.selected = btnPhotos20.tag == (NSInteger)kPDPhotoToolsNearbyRange ? YES : NO;
        btnPhotos50.selected = btnPhotos50.tag == (NSInteger)kPDPhotoToolsNearbyRange ? YES : NO;
        btnPhotos100.selected = btnPhotos100.tag == (NSInteger)kPDPhotoToolsNearbyRange ? YES : NO;
        self.selectedDistance = kPDPhotoToolsNearbyRange;
    } else {
        btnPhotos20.selected = YES;
        self.selectedDistance = (double)btnPhotos20.tag;
        [kPDUserDefaults setObject:[NSNumber numberWithDouble:(double)btnPhotos20.tag]
                            forKey:kPDPhotoToolsNearbyRangeKey];
    }

    if (kPDPhotoToolsNearbySort == 0 || kPDPhotoToolsNearbySort == 1) {
        btnPhotosFavorites.selected = btnPhotosFavorites.tag == kPDPhotoToolsNearbySort ? YES : NO;
        btnPhotosNews.selected = btnPhotosNews.tag == kPDPhotoToolsNearbySort ? YES : NO;
        self.selectedSorting = kPDPhotoToolsNearbySort;
    } else {
        btnPhotosFavorites.selected = YES;
        self.selectedSorting = btnPhotosFavorites.tag;
        [kPDUserDefaults setInteger:btnPhotosFavorites.tag forKey:kPDPhotoToolsNearbySortKey];
    }
}

- (IBAction)btnPhotoNumbersSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 20:
            btnPhotos20.selected = YES;
            btnPhotos50.selected = NO;
            btnPhotos100.selected = NO;
            break;
        case 50:
            btnPhotos20.selected = NO;
            btnPhotos50.selected = YES;
            btnPhotos100.selected = NO;
            break;
        case 100:
            btnPhotos20.selected = NO;
            btnPhotos50.selected = NO;
            btnPhotos100.selected = YES;
            break;
        default:
            break;
    }
    if (self.selectedDistance != (double)button.tag) {
        self.selectedDistance = (double)button.tag;
        [self saveDataFilter];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPhotoSpotsFilterDidChangeNotification object:nil];
    }
}
- (IBAction)btnPhotoFavoritesAndNewsSelected:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 1:
            btnPhotosFavorites.selected = YES;
            btnPhotosNews.selected = NO;
            break;
        case 0:
            btnPhotosFavorites.selected = NO;
            btnPhotosNews.selected = YES;
        default:
            break;
    }
    if (self.selectedSorting != button.tag) {
        self.selectedSorting = button.tag;
        [self saveDataFilter];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPhotoSpotsFilterDidChangeNotification object:nil];
    }
}

- (IBAction)btnDateFromToSelected:(id)sender
{
    self.currentSelected = btnDateFromTo;
    _actionSheetPicker = [[PDActionSheetCustomDatePicker alloc] initWithTitle:nil
                                                                 selectedDate:self.btnDateFromTo.titleLabel.text
                                                                       target:self
                                                                       action:@selector(dateBeginWasSelected:element:)
                                                                       origin:sender];
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)btnDateToSelected:(id)sender
{
    self.currentSelected = btnDateTo;
    _actionSheetPicker = [[PDActionSheetCustomDatePicker alloc] initWithTitle:nil
                                                                 selectedDate:self.btnDateTo.titleLabel.text
                                                                       target:self
                                                                       action:@selector(dateEndWasSelected:element:)
                                                                       origin:sender];
    [self.actionSheetPicker showActionSheetPicker];
}

- (IBAction)btnTimeFromToSelected:(id)sender
{
    self.currentSelected = btnTimeFromTo;
    PDActionSheetTimePicker *picker = [[PDActionSheetTimePicker alloc] initWithTitle:@""
                                                                      datePickerMode:UIDatePickerModeTime
                                                                        selectedTime:self.selectedTimeBegin
                                                                              target:self
                                                                              action:@selector(timeBeginWasSelected:element:) origin:sender];
    [picker showActionSheetPicker];
}

- (IBAction)btnTimeToSelected:(id)sender
{
    self.currentSelected = btnTimeTo;
    if (!_selectedTimeEnd) {
        if (_selectedTimeBegin)
            self.selectedTimeEnd = _selectedTimeBegin;
        else
            self.selectedTimeEnd = [NSDate date];
    }
    PDActionSheetTimePicker *picker = [[PDActionSheetTimePicker alloc] initWithTitle:@""
                                                                      datePickerMode:UIDatePickerModeTime
                                                                        selectedTime:self.selectedTimeEnd
                                                                              target:self
                                                                              action:@selector(timeEndWasSelected:element:)
                                                                              origin:sender];
    [picker showActionSheetPicker];
}

- (void)saveDataFilter
{
    [kPDUserDefaults setDouble:self.selectedDistance forKey:kPDPhotoToolsNearbyRangeKey];
    [kPDUserDefaults setInteger:self.selectedSorting forKey:kPDPhotoToolsNearbySortKey];
    [kPDUserDefaults setInteger:self.date_from forKey:kPDPhotoToolsNearbyDateFromKey];
    [kPDUserDefaults setInteger:self.date_to forKey:kPDPhotoToolsNearbyDateToKey];
    [kPDUserDefaults setInteger:self.time_from forKey:kPDPhotoToolsNearbyTimeFromKey];
    [kPDUserDefaults setInteger:self.time_to forKey:kPDPhotoToolsNearbyTimeToKey];
}

- (void)dateBeginWasSelected:(NSDate *)selectedDate element:(id)element
{
    [self.currentSelected setTitle:[self selectedDateFromPicker:(UIPickerView *)self.actionSheetPicker.pickerView]
                          forState:UIControlStateNormal];
}
- (void)dateEndWasSelected:(NSDate *)selectedDate element:(id)element
{
    [self.currentSelected setTitle:[self selectedDateFromPicker:(UIPickerView *)self.actionSheetPicker.pickerView]
                          forState:UIControlStateNormal];
}
- (void)timeBeginWasSelected:(NSDate *)selectedTime element:(id)element
{
    self.selectedTimeBegin = selectedTime;
    [self.currentSelected setTitle:[self stringFromTime:selectedTime] forState:UIControlStateNormal];
}
- (void)timeEndWasSelected:(NSDate *)selectedTime element:(id)element
{
    self.selectedTimeEnd = selectedTime;
    [self.currentSelected setTitle:[self stringFromTime:selectedTime] forState:UIControlStateNormal];
}

- (NSString *)stringFromTime:(NSDate *)time
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                    fromDate:time];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    if (self.currentSelected == btnTimeFromTo) {
        float  new_time_from = [self timeFromHours:hour minutes:minute];
        if (_time_to > 0 && new_time_from > _time_to) {
            new_time_from = _time_to;
            hour = [self hourFromNumber:new_time_from];
            minute = [self minuteFromNumber:new_time_from];
            [dateComponents setHour:hour];
            [dateComponents setMinute:minute];
            self.selectedTimeBegin = [gregorian dateFromComponents:dateComponents];
        }
        if (_time_from != new_time_from) {
            self.time_from = new_time_from;
            [self timeFilterDidChange];
        }
    } else {
        float new_time_to = [self timeFromHours:hour minutes:minute];
        if (new_time_to < _time_from) {
            new_time_to = _time_from;
            hour = [self hourFromNumber:new_time_to];
            minute = [self minuteFromNumber:new_time_to];
            [dateComponents setHour:hour];
            [dateComponents setMinute:minute];
            self.selectedTimeEnd = [gregorian dateFromComponents:dateComponents];
        }
        if (self.time_to != new_time_to) {
            self.time_to = new_time_to;
            [self timeFilterDidChange];
        }
    }

    NSString *am_OR_pm = @"AM";
    if (hour > 12) {
        hour = hour%12;
        am_OR_pm = @"PM";
    }
    return [NSString stringWithFormat:@"%02ld:%02ld %@", (long)hour, (long)minute, am_OR_pm];
}

- (NSString *)selectedDateFromPicker:(UIPickerView *)picker
{
    NSInteger dayRow = [picker selectedRowInComponent:kDayComponent];
    NSInteger monthRow = [picker selectedRowInComponent:kMonthComponent];
    if (self.currentSelected == btnDateFromTo) {
        float new_date_from = [self convertDateToNumber:monthRow+1 days:dayRow+1];
        if (self.date_to && new_date_from > self.date_to) {
            new_date_from = self.date_to;
            monthRow = [self convertNumberToMonth:new_date_from]-1;
            dayRow = [self convertNumberToDay:new_date_from]-1;
        }
        if (self.date_from != new_date_from) {
            self.date_from = new_date_from;
            [self dateFilterDidChange];
        }
    } else {
        float new_date_to = [self convertDateToNumber:monthRow+1 days:dayRow+1];
        if (self.date_from && new_date_to < self.date_from) {
            new_date_to = self.date_from;
            monthRow = [self convertNumberToMonth:new_date_to]-1;
            dayRow = [self convertNumberToDay:new_date_to]-1;
        }
        if (self.date_to != new_date_to) {
            self.date_to = new_date_to;
            [self dateFilterDidChange];
        }
    }
    return [NSString stringWithFormat:@"%@/%@", self.actionSheetPicker.months[monthRow],
                                                self.actionSheetPicker.daysInMonth[dayRow]];
}

- (NSInteger)convertDateToNumber:(NSInteger)months days:(NSInteger)days
{
    return months * kPDUnitConverDateToNumber + days;
}

- (NSInteger)convertNumberToDay:(NSInteger)number
{
    return (number % kPDUnitConverDateToNumber);
}

- (NSInteger)convertNumberToMonth:(NSInteger)number
{
    return (NSInteger)(number / kPDUnitConverDateToNumber);
}

- (NSInteger)timeFromHours:(NSInteger)hours minutes:(NSInteger)minutes
{
    return (hours*60 + minutes);
}

- (NSInteger)hourFromNumber:(NSInteger)number
{
    return (NSInteger)(number / 60);
}

- (NSInteger)minuteFromNumber:(NSInteger)number
{
    return (number % 60);
}

- (void)dateFilterDidChange
{
    if (self.date_from && self.date_to) {
        [self saveDataFilter];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPhotoSpotsFilterDidChangeNotification object:nil];
    }
}

- (void)timeFilterDidChange
{
    if (self.time_from && self.time_to) {
        [self saveDataFilter];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDPhotoSpotsFilterDidChangeNotification object:nil];
    }
}


@end
