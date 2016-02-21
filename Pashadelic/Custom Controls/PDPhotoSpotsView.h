//
//  PDPhotoSpotsView.h
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"
#import "PDActionSheetCustomDatePicker.h"

@protocol PDPhotoSpotsViewDelegate <NSObject>
- (void)btnPhotoSpotsViewSelected:(id)sender;
@end

@interface PDPhotoSpotsView : UIView
@property (nonatomic, strong) IBOutlet UILabel *rangeLabel;
@property (nonatomic, strong) IBOutlet UILabel *sortLabel;
@property (nonatomic, strong) IBOutlet UILabel *filterbyDateLabel;
@property (nonatomic, strong) IBOutlet UILabel *filterbyTimeLabel;

@property (nonatomic, strong) IBOutlet UIButton *btnPhotos20;
@property (nonatomic, strong) IBOutlet UIButton *btnPhotos50;
@property (nonatomic, strong) IBOutlet UIButton *btnPhotos100;
@property (nonatomic, strong) IBOutlet UIButton *btnPhotosFavorites;
@property (nonatomic, strong) IBOutlet UIButton *btnPhotosNews;
@property (nonatomic, strong) IBOutlet UIButton *btnDateFromTo;
@property (nonatomic, strong) IBOutlet UIButton *btnDateTo;
@property (nonatomic, strong) IBOutlet UIButton *btnTimeFromTo;
@property (nonatomic, strong) IBOutlet UIButton *btnTimeTo;

@property (nonatomic, weak) UIButton *currentSelected;
@property (nonatomic, strong) PDActionSheetCustomDatePicker *actionSheetPicker;

@property (nonatomic, strong) NSDate *selectedTimeBegin;
@property (nonatomic, strong) NSDate *selectedTimeEnd;
@property (nonatomic, assign) NSInteger selectedMonthBegin;
@property (nonatomic, assign) NSInteger selectedDayBegin;
@property (nonatomic, assign) NSInteger selectedMonthEnd;
@property (nonatomic, assign) NSInteger selectedDayEnd;
@property (nonatomic, assign) double selectedDistance;
@property (nonatomic, assign) NSInteger selectedSorting;
@property (nonatomic, assign) NSInteger date_from;
@property (nonatomic, assign) NSInteger date_to;
@property (nonatomic, assign) NSInteger time_from;
@property (nonatomic, assign) NSInteger time_to;
- (IBAction)btnPhotoNumbersSelected:(id)sender;
- (IBAction)btnPhotoFavoritesAndNewsSelected:(id)sender;
- (IBAction)btnDateFromToSelected:(id)sender;
- (IBAction)btnDateToSelected:(id)sender;
- (IBAction)btnTimeFromToSelected:(id)sender;
- (IBAction)btnTimeToSelected:(id)sender;
- (void)saveDataFilter;
@end
