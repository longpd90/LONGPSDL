//
//  PDARDatePicker.h
//  Pashadelic
//
//  Created by LongPD on 2/6/14.
//

#import <UIKit/UIKit.h>

@protocol PDARDatePickerDelegate <NSObject>
- (void)clickDoneBtnWithDate:(NSDate *)date;
@optional
- (void)didTouchesScreen;
@end

@interface PDARDatePicker : UIView {
    
}

@property (strong, nonatomic) id<PDARDatePickerDelegate> delegate;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UIDatePicker *datePicker;

- (id)initWithFrame:(CGRect)frame andDate:(NSDate *)setDate;

@end
