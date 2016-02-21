//
//  PDActionSheetTimePicker.m
//  Pashadelic
//
//  Created by TungNT2 on 5/11/13.
//
//

#import "PDActionSheetTimePicker.h"
#import <objc/message.h>

@interface PDActionSheetTimePicker()
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSDate *selectedTime;
@end

@implementation PDActionSheetTimePicker
@synthesize selectedTime = _selectedTime;
@synthesize datePickerMode = _datePickerMode;

+ (id)showPickerWithTitle:(NSString *)title
           datePickerMode:(UIDatePickerMode)datePickerMode selectedTime:(NSDate *)selectedTime
                   target:(id)target action:(SEL)action origin:(id)origin {
    PDActionSheetTimePicker *picker = [[PDActionSheetTimePicker alloc] initWithTitle:title datePickerMode:datePickerMode selectedTime:selectedTime target:target action:action origin:origin];
    [picker showActionSheetPicker];
    return picker;
}

- (id)initWithTitle:(NSString *)title datePickerMode:(UIDatePickerMode)datePickerMode selectedTime:(NSDate *)selectedTime target:(id)target action:(SEL)action origin:(id)origin {
    self = [super initWithTarget:target successAction:action cancelAction:nil origin:origin];
    if (self) {
        self.title = title;
        self.datePickerMode = datePickerMode;
        self.selectedTime = selectedTime;
    }
    return self;
}


- (UIView *)configuredPickerView {
    CGRect datePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    datePicker.datePickerMode = self.datePickerMode;
    [datePicker setDate:self.selectedTime animated:NO];
    [datePicker addTarget:self action:@selector(eventForTimePicker:) forControlEvents:UIControlEventValueChanged];
    
    //need to keep a reference to the picker so we can clear the DataSource / Delegate when dismissing (not used in this picker, but just in case somebody uses this as a template for another picker)
    self.pickerView = datePicker;
    
    return datePicker;
}

- (void)notifyTarget:(id)target didSucceedWithAction:(SEL)action origin:(id)origin {
    if ([target respondsToSelector:action])
//        objc_msgSend(target, action, self.selectedTime, origin);
         objc_msgSend();
    else
        NSAssert(NO, @"Invalid target/action ( %s / %s ) combination used for ActionSheetPicker", object_getClassName(target), (void *)action);
}

- (void)eventForTimePicker:(id)sender {
    if (!sender || ![sender isKindOfClass:[UIDatePicker class]])
        return;
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    self.selectedTime = datePicker.date;
}

- (void)customButtonPressed:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    NSInteger index = button.tag;
    NSAssert((index >= 0 && index < self.customButtons.count), @"Bad custom button tag: %zd, custom button count: %zd", index, self.customButtons.count);
    NSAssert([self.pickerView respondsToSelector:@selector(setDate:animated:)], @"Bad pickerView for ActionSheetDatePicker, doesn't respond to setDate:animated:");
    NSDictionary *buttonDetails = [self.customButtons objectAtIndex:index];
    NSDate *itemValue = [buttonDetails objectForKey:@"buttonValue"];
    UIDatePicker *picker = (UIDatePicker *)self.pickerView;
    [picker setDate:itemValue animated:YES];
    [self eventForTimePicker:picker];
}

@end
