//
//  CDatePickerViewEx.m
//  MonthYearDatePicker
//
//  Created by Igor on 18.03.13.
//  Copyright (c) 2013 Igor. All rights reserved.
//

#import "CDatePickerViewEx.h"

// Identifiers of components
#define MONTH ( 0 )
#define DAY ( 1 )


// Identifies for component views
#define LABEL_TAG 43


@interface CDatePickerViewEx()

//@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *days;

@property (nonatomic, assign) NSInteger minDay;
@property (nonatomic, assign) NSInteger maxDay;

@end

@implementation CDatePickerViewEx

const NSInteger bigRowCount = 1000;
const NSInteger numberOfComponents = 2;

#pragma mark - Properties

-(void)setMonthFont:(UIFont *)monthFont
{
    if (monthFont)
    {
        _monthFont = monthFont;
    }
}

-(void)setMonthSelectedFont:(UIFont *)monthSelectedFont
{
    if (monthSelectedFont)
    {
        _monthSelectedFont = monthSelectedFont;
    }
}

-(void)setDayFont:(UIFont *)dayFont
{
    if (dayFont)
    {
        _dayFont = dayFont;
    }
}

-(void)setDaySelectedFont:(UIFont *)daySelectedFont
{
    if (daySelectedFont)
    {
        _daySelectedFont = daySelectedFont;
    }
}

#pragma mark - Init

-(instancetype)init
{
    if (self = [super init])
    {
        [self loadDefaultsParameters];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self loadDefaultsParameters];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadDefaultsParameters];
}

#pragma mark - Open methods

//-(NSDate *)date
//{
//    NSInteger monthCount = self.months.count;
//    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
//    
//    NSInteger dayCount = self.days.count;
//    NSString *day = [self.days objectAtIndex:([self selectedRowInComponent:DAY] % dayCount)];
//    
//    NSDateFormatter *formatter = [NSDateFormatter new];
//    [formatter setDateFormat:@"MMMM:dd"];
//    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@:%@", month, day]];
//    return date;
//}

-(void)setupMinDay:(NSInteger)minDay maxDay:(NSInteger)maxDay
{
    self.minDay = minDay;
    
    if (maxDay > minDay)
    {
        self.maxDay = maxDay;
    }
    else
    {
        self.maxDay = minDay + 10;
    }
    
    self.days = [self nameOfDays];
//    self.todayIndexPath = [self todayPath];
}

-(void)selectToday
{
    [self selectRow: self.monthIndex
        inComponent: MONTH
           animated: NO];
    
    [self selectRow: self.dayIndex
        inComponent: DAY
           animated: NO];
    [self reloadAllComponents];
}

#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    BOOL selected = NO;
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
        NSString *currentMonthName = [self currentMonthName];
        if([monthName isEqualToString:currentMonthName] == YES)
        {
            selected = YES;
        }
    }
    else
    {
        NSInteger dayCount = self.days.count;
        NSString *dayName = [self.days objectAtIndex:(row % dayCount)];
        NSString *currenrdayName  = [self currentDayName];
        if([dayName isEqualToString:currenrdayName] == YES)
        {
            selected = YES;
        }
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent:component];
    }
    
    returnView.font =  [self fontForComponent:component];
    returnView.textColor = [self colorForComponent:component];
    
    returnView.text = [self titleForRow:row forComponent:component];
    return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowHeight;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        return [self bigRowMonthCount];
    }
    return [self bigRowDayCount];
}

#pragma mark - Util

-(NSInteger)bigRowMonthCount
{
    return self.months.count  * bigRowCount;
}

-(NSInteger)bigRowDayCount
{
    return self.days.count  * bigRowCount;
}

-(CGFloat)componentWidth
{
    return self.bounds.size.width / numberOfComponents;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == MONTH)
    {
        NSInteger monthCount = self.months.count;
        return [self.months objectAtIndex:(row % monthCount)];
    }
    NSInteger dayCount = self.days.count;
    return [self.days objectAtIndex:(row % dayCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, [self componentWidth], self.rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSArray *)nameOfMonths
{
    return @[NSLocalizedString(@"January", nil),NSLocalizedString(@"February", nil) ,NSLocalizedString(@"March", nil) ,NSLocalizedString( @"April", nil),NSLocalizedString(@"May", nil) ,NSLocalizedString(@"June", nil) ,NSLocalizedString(@"July", nil) ,NSLocalizedString(@"August", nil) ,NSLocalizedString(@"September", nil) , NSLocalizedString(@"October", nil),NSLocalizedString(@"November", nil) ,NSLocalizedString( @"December", nil)];
}

-(NSArray *)nameOfDays
{
    NSMutableArray *days = [NSMutableArray array];
    
    for(NSInteger day = self.minDay; day <= self.maxDay; day++)
    {
        NSString *dayStr = [NSString stringWithFormat:@"%li", (long)day];
        [days addObject:dayStr];
    }
    return days;
}

-(NSIndexPath *)todayPath // row - month ; section - day
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *day  = [self currentDayName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            row = row + [self bigRowMonthCount] / 2;
            break;
        }
    }
    
    for(NSString *cellDay in self.days)
    {
        if([cellDay isEqualToString:day])
        {
            section = [self.days indexOfObject:cellDay];
            section = section + [self bigRowDayCount] / 2;
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:self.date];
}

-(NSString *)currentDayName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:self.date];
}

- (UIColor *)selectedColorForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.monthSelectedTextColor;
    }
    return self.daySelectedTextColor;
}

- (UIColor *)colorForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.monthTextColor;
    }
    return self.dayTextColor;
}

- (UIFont *)selectedFontForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.monthSelectedFont;
    }
    return self.daySelectedFont;
}

- (UIFont *)fontForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.monthFont;
    }
    return self.dayFont;
}

-(void)loadDefaultsParameters
{
    self.minDay = 1;
    self.maxDay = 31;
    self.rowHeight = 31;
    
    self.months = [self nameOfMonths];
    self.days = [self nameOfDays];
//    self.todayIndexPath = [self todayPath];
    self.delegate = self;
    self.dataSource = self;
    
    self.monthSelectedTextColor = [UIColor blueColor];
    self.monthTextColor = [UIColor blackColor];
    
    self.daySelectedTextColor = [UIColor blueColor];
    self.dayTextColor = [UIColor blackColor];
    
    self.monthSelectedFont = [UIFont boldSystemFontOfSize:17];
    self.monthFont = [UIFont boldSystemFontOfSize:17];
    
    self.daySelectedFont = [UIFont boldSystemFontOfSize:17];
    self.dayFont = [UIFont boldSystemFontOfSize:17];
}

@end
