//
// TECustomSlider.h
//
// Created by Tuấn Nguyễn Anh on 6/3/13.
// Copyright (c) 2013 Tuấn Nguyễn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEPopupView.h"
#import "TECustomRoundRectButton.h"
@class TECustomSlider;
typedef enum {
    sldDate,
    sldTime
} TypeSlider;

@protocol TECustomSliderDelegate <NSObject>
- (void)slider:(TECustomSlider *)slider didChangeValue:(NSString *)value;
@end

@interface TECustomSlider : UISlider <PopupMenuDelegate>

{
    TypeSlider type;
    TECustomRoundRectButton *labelButton;
    NSDate *date;
    NSInteger min;
    NSInteger hour;
    NSInteger sec;
    NSInteger day;
    NSInteger month;
    NSInteger year;
    float previousValue;
    id<TECustomSliderDelegate> delegate;
}

@property (assign, nonatomic) NSInteger ratioZoom;
@property (retain, nonatomic) TEPopupView *popupMenu;
@property (retain, nonatomic) TECustomRoundRectButton *labelButton;
@property (retain) id<TECustomSliderDelegate> delegate;

- (void)setType:(TypeSlider)newType;
- (void)setDate:(NSDate *)newDate;
- (NSDate *)date;
- (void)initButtonContainTime;
- (void)initPopup;
- (void)initValue;
- (float)getValueFromTime;
- (void)getDateFromInt:(NSInteger)value;
- (void)getDateComponent:(NSDate *)dateValue;
- (bool)isLeapYear;
- (NSString *)textForButton;
- (IBAction)valueChanged:(UISlider *)sender;
- (void)showPopup;

@end