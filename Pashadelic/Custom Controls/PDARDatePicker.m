//
//  PDARDatePicker.m
//  Pashadelic
//
//  Created by LongPD on 2/6/14.
//

#import "PDARDatePicker.h"

@implementation PDARDatePicker

- (id)initWithFrame:(CGRect)frame andDate: (NSDate*)setDate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        
        UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnDone.frame = CGRectMake(260, 100, 60, 30);
        [btnDone addTarget:self action:@selector(clickDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDone];
        
        _datePicker = [[UIDatePicker alloc ] initWithFrame:CGRectMake(0, 120, 320, 180)];
        [self addSubview:_datePicker];
        [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        _datePicker.date = setDate;
        _date = [[NSDate alloc] init];
        _date = setDate;
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
    _datePicker.date = date;
    _date = date;
}

- (void)clickDoneBtn:(id)sender {
    _date = [_datePicker date];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDoneBtnWithDate:)]) {
        [self.delegate clickDoneBtnWithDate:_date];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDoneBtnWithDate:)]) {
        [self.delegate didTouchesScreen];
    }
}

@end
