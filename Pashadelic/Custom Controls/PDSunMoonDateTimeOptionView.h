//
//  PDSunMoonDateTimeOptionView.h
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TECustomSlider.h"
@interface PDSunMoonDateTimeOptionView : UIView <TECustomSliderDelegate>
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet TECustomSlider *dateSlider;
@property (nonatomic, strong) IBOutlet TECustomSlider *timeSlider;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *timeString;
- (void)initSliderBar;
@end
