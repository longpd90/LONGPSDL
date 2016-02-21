//
//  CDatePickerViewEx.h
//  MonthYearDatePicker
//
//  Created by Igor on 18.03.13.
//  Copyright (c) 2013 Igor. All rights reserved.
//

@interface CDatePickerViewEx : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIColor *monthSelectedTextColor;
@property (nonatomic, strong) UIColor *monthTextColor;

@property (nonatomic, strong) UIColor *daySelectedTextColor;
@property (nonatomic, strong) UIColor *dayTextColor;

@property (nonatomic, strong) UIFont *monthSelectedFont;
@property (nonatomic, strong) UIFont *monthFont;

@property (nonatomic, strong) UIFont *daySelectedFont;
@property (nonatomic, strong) UIFont *dayFont;

@property (nonatomic, assign) NSInteger rowHeight;

@property (strong, nonatomic) NSDate *date;

@property (nonatomic, assign) NSInteger monthIndex;
@property (nonatomic, assign) NSInteger dayIndex;


-(void)setupMinDay:(NSInteger)minDay maxDay:(NSInteger)maxDay;
-(void)selectToday;

@end
