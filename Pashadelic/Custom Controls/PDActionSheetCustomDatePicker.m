//
//  PDActionSheetDatePicker.m
//  Pashadelic
//
//  Created by TungNT2 on 5/11/13.
//
//

#import "PDActionSheetCustomDatePicker.h"
#import <objc/message.h>

NSInteger numberDay = 31;

@interface PDActionSheetCustomDatePicker ()
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, assign) NSInteger selectedDay;
@property (nonatomic, assign) NSInteger selectedMonth;
- (NSArray *)daysInMonth;
- (NSInteger)numberDaysInMonth:(NSInteger)month;
@end

@implementation PDActionSheetCustomDatePicker
@synthesize selectedDate = _selectedDate;

+ (id)showPickerWithTitle:(NSString *)title selectedDate:(NSString *)selectedDate target:(id)target action:(SEL)action origin:(id)origin
{
    PDActionSheetCustomDatePicker *picker = [[PDActionSheetCustomDatePicker alloc] initWithTitle:title
                                                                                    selectedDate:selectedDate
                                                                                          target:target
                                                                                          action:action
                                                                                          origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title selectedDate:(NSString *)selectedDate target:(id)target action:(SEL)action origin:(id)origin
{
    self = [super initWithTarget:target successAction:action cancelAction:nil origin:origin];
    if (self) {
        self.title = title;
        self.months = [NSArray arrayWithObjects:@"January", @"February", @"March", @"April", @"May", @"June",
                       @"July", @"August", @"September", @"October", @"November", @"December", nil];
        self.daysInMonth = [self daysInMonth];
        [self getDayAndMonthFromString:selectedDate];
    }
    return self;
}

- (void)setSelectedMonth:(NSInteger)selectedMonth
{
    if (1 <= selectedMonth && selectedMonth <= 12) {
        _selectedMonth = selectedMonth;
    } else if (selectedMonth < 1) {
        _selectedMonth = 1;
    } else
        _selectedMonth = 12;
}

- (void)setSelectedDay:(NSInteger)selectedDay
{
    if (selectedDay <= [self numberDaysInMonth:_selectedMonth]) {
        _selectedDay = selectedDay;
    } else {
        _selectedDay = 1;
    }
}

- (UIView *)configuredPickerView {
    CGRect datePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIPickerView *customDatePicker = [[UIPickerView alloc] initWithFrame:datePickerFrame];
    customDatePicker.delegate = self;
    customDatePicker.dataSource = self;
    customDatePicker.showsSelectionIndicator = YES;
    if (self.selectedDay > 0 && self.selectedMonth > 0) {
        [customDatePicker selectRow:self.selectedMonth-1 inComponent:kMonthComponent animated:NO];
        [customDatePicker selectRow:self.selectedDay-1 inComponent:kDayComponent animated:NO];
    }
    self.pickerView = customDatePicker;
    
    return customDatePicker;
}

#pragma mark Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == kDayComponent) {
        return numberDay;
    } else {
        return [self.months count];
    }
}

#pragma mark Picker Delegate Methods

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(component == kDayComponent){
        return self.daysInMonth[row];
    } else{
        return self.months[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(component == kMonthComponent){
        numberDay = [self numberDaysInMonth:row+1];
        [(UIPickerView *)self.pickerView reloadComponent:kDayComponent];
    }
}

- (NSArray *)daysInMonth
{
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 1; i<=31; i++){
        [array addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    return array;
}

- (NSInteger)numberDaysInMonth:(NSInteger)month
{
    switch (month) {
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
            break;
        case 2:
            return 28;
        default:
            return 31;
            break;
    }
}

- (NSInteger)getNumberMonthFromString:(NSString *)month
{
    for (int i = 0; i < [self.months count]; i++) {
        if ([[self.months objectAtIndex:i] isEqualToString:month]) {
            return i+1;
        }
    }
    return 1;
}

- (void)getDayAndMonthFromString:(NSString *)dayAndMonth
{
    if ([dayAndMonth rangeOfString:@"/"].location != NSNotFound) {
        NSArray *array = [dayAndMonth componentsSeparatedByString:@"/"];
        self.selectedMonth = [self getNumberMonthFromString:[array objectAtIndex:0]];
        self.selectedDay = [[array objectAtIndex:1] intValue];
    }
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin {
    if ([target respondsToSelector:action])
//            objc_msgSend(target, action, self.selectedDate, origin);
        objc_msgSend();
    else
        NSAssert(NO, @"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (void *)action);
}

@end
