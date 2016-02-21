//
//  PDActionSheetCustomDatePicker.h
//  Pashadelic
//
//  Created by TungNT2 on 5/11/13.
//
//

#import "AbstractActionSheetPicker.h"
#define kMonthComponent 1
#define kDayComponent   0

@interface PDActionSheetCustomDatePicker : AbstractActionSheetPicker <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSArray *months;
@property (strong, nonatomic) NSArray *daysInMonth;
+ (id)showPickerWithTitle:(NSString *)title selectedDate:(NSString *)selectedDate target:(id)target action:(SEL)action origin:(id)origin;

- (id)initWithTitle:(NSString *)title selectedDate:(NSString *)selectedDate target:(id)target action:(SEL)action origin:(id)origin;
- (NSInteger)getNumberMonthFromString:(NSString *)month;
@end
