//
//  PDSunMoonDateTimeOptionView.m
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import "PDSunMoonDateTimeOptionView.h"

@interface PDSunMoonDateTimeOptionView (Private)

@end

@implementation PDSunMoonDateTimeOptionView
@synthesize dateSlider;
@synthesize timeSlider;
@synthesize dateFormatter;
@synthesize dateString;
@synthesize timeString;
- (id)init
{
    self = [UIView loadFromNibNamed:@"PDSunMoonDateTimeOptionView"];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initSliderBar];
}

- (void)initSliderBar
{
    self.dateLabel.text = NSLocalizedString(@"date", nil);
    self.timeLabel.text = NSLocalizedString(@"time", nil);
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];    
    UIImage *minTrackImage = [[UIImage imageNamed:@"image_slider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    UIImage *thumbImage = [UIImage imageNamed:@"icon_current_point_date_time.png"];
    
    [dateSlider setMinimumTrackImage:minTrackImage forState:UIControlStateNormal];
    [dateSlider setMaximumTrackImage:minTrackImage forState:UIControlStateNormal];
    [dateSlider setThumbImage:thumbImage forState:UIControlStateNormal];

    dateSlider.tag = 0;
    dateSlider.delegate = self;
    [dateSlider setType:sldDate];
    [dateSlider initValue];
    [dateSlider initButtonContainTime];
    dateSlider.ratioZoom = 10;
    dateSlider.delegate = self;
    [dateSlider setDate:[NSDate date]];
    dateString = [dateSlider textForButton];
    
    [timeSlider setMinimumTrackImage:minTrackImage forState:UIControlStateNormal];
    [timeSlider setMaximumTrackImage:minTrackImage forState:UIControlStateNormal];
    [timeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [timeSlider setType:sldTime];
    [timeSlider initValue];
    [timeSlider initButtonContainTime];
    timeSlider.ratioZoom = 40;
    timeSlider.delegate = self;
    [timeSlider setDate:[NSDate date]];
    timeString = [timeSlider textForButton];

    timeSlider.tag = 1;
    timeSlider.delegate = self;
}

- (void)slider:(TECustomSlider *)slider didChangeValue:(NSString *)value
{
    if (slider.tag == 0) {
        dateString = value;
        NSString *currentValue = [NSString stringWithFormat:@"%@ %@:00", dateString, timeString];
        NSDate *currentValueDate = [dateFormatter dateFromString:currentValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDSunMoonDateChangedNotification object:currentValueDate];
    } else {
        timeString = value;
        NSString *currentValue = [NSString stringWithFormat:@"%@ %@:00", dateString, timeString];
        NSDate *currentValueDate = [dateFormatter dateFromString:currentValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDSunMoonDateChangedNotification object:currentValueDate];
    }

}
@end
