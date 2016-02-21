//
//  PDActionSheetTimePicker.h
//  Pashadelic
//
//  Created by TungNT2 on 5/11/13.
//
//

#import "AbstractActionSheetPicker.h"

@interface PDActionSheetTimePicker : AbstractActionSheetPicker

+ (id)showPickerWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedTime:(NSDate *)selectedTime target:(id)target action:(SEL)action origin:(id)origin;

- (id)initWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedTime:(NSDate *)selectedTime target:(id)target action:(SEL)action origin:(id)origin;

- (void)eventForTimePicker:(id)sender;

@end
