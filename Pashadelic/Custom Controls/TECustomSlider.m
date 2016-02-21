//
// TECustomSlider.m
//
// Created by Tuấn Nguyễn Anh on 6/3/13.
// Copyright (c) 2013 Tuấn Nguyễn Anh. All rights reserved.
//

#import "TECustomSlider.h"

NSInteger numberDate[] = {31,28,31,30,31,30,31,31,30,31,30,31};
float spaceToMiniSlider;

@implementation TECustomSlider
@synthesize popupMenu, ratioZoom, labelButton, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        date = [NSDate date];
        spaceToMiniSlider = 5;
    }
    return self;
}

- (void) setType:(TypeSlider)newType{
    type = newType;
}

- (void) setDate:(NSDate *)newDate{
    date = newDate;
}

- (NSDate *) date
{
    return date;
}

//Khởi tạo Slider
- (void)initValue {
    date = [NSDate date];
    [self getDateComponent:date];
    //Đặt giá trị max, min cho slider
    switch (type) {
        case sldDate:
            [self setMinimumValue:1];
            if([self isLeapYear]){
                [self setMaximumValue:366];
            }else{
                [self setMaximumValue:365];
            }
            break;
        case sldTime:
            [self setMinimumValue:0];
            [self setMaximumValue:1439];
        default:
            break;
    }
    //Đặt giá trị là thời điểm hiện tại
    [self setValue:[self getValueFromTime]];
    previousValue = self.value;
    [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void) initButtonContainTime
{
    float coorX = self.frame.origin.x;
    CGRect frameButton = CGRectZero;
    
    labelButton = [[TECustomRoundRectButton alloc] init];
    [labelButton setTitle:[self textForButton] forState:UIControlStateNormal];
    [labelButton addTarget:self action:@selector(showPopup) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchUpInside];
    
    CGFloat fontSize = labelButton.titleLabel.font.pointSize + 5;
    frameButton.size.height = fontSize;
    //Tính toán kích thước, vị trí label
    switch (type) {
        case sldDate:
            frameButton.size.width = 88;
            frameButton.origin.y -= 10;
            coorX += self.value * (self.frame.size.width / (self.maximumValue - self.minimumValue + 38)) - frameButton.size.width + 3;
            break;
        case sldTime:
            frameButton.size.width = 45;
            frameButton.origin.y -= 10;
            coorX += self.value * (self.frame.size.width / (self.maximumValue - self.minimumValue + 155)) - frameButton.size.width + 4;
        default:
            break;
    }
    //Kiểm tra nếu label bị quá slider thì đặt lại label
    if(coorX < self.frame.origin.x){
        coorX += frameButton.size.width + 17;
    }
    frameButton.origin.x = coorX;
    frameButton.origin.y = self.frame.origin.y - 15;
    [labelButton setFrame:frameButton];
    [self.superview addSubview:labelButton];
}

- (void) initPopup
{
    //Khởi tạo popup menu
    
}

//Gọi ra popup khi click vào label
- (void) showPopup
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect frame = CGRectMake(self.frame.origin.x + self.superview.frame.origin.x - spaceToMiniSlider, self.frame.origin.y + self.superview.frame.origin.y + self.frame.size.height - 4, self.frame.size.width + 2*spaceToMiniSlider, 35);
    CGRect popupFrame = [window convertRect:frame fromView:self.superview];

    popupMenu = [[TEPopupView alloc] initWithFrame:popupFrame];
    
    [popupMenu setDelegate:self];
    
    popupMenu.miniSlider.minimumValue = self.minimumValue;
    popupMenu.miniSlider.maximumValue = self.maximumValue;
    popupMenu.originalValue = self.value;
    [popupMenu addSlider];
    popupMenu.spaceToMinislider = spaceToMiniSlider;
    [popupMenu setFrameforTriangular:((self.value-self.minimumValue)/(self.maximumValue-self.minimumValue))*(self.frame.size.width-self.currentThumbImage.size.width) /*+ self.currentThumbImage.size.width/2 */- spaceToMiniSlider/2 -2];
    [popupMenu showPopupView];
    
    popupMenu.midValue = popupMenu.miniSlider.value;
}

//Slider ở popup thay đổi giá trị
- (void) miniSliderChange:(float)value
{
    self.value = popupMenu.originalValue + (value - popupMenu.midValue)/ratioZoom;
    [self valueChanged:self];
}


//Sự kiện khi giá trị thay đổi
- (IBAction) valueChanged:(UISlider *)sender{
    NSInteger progress = lroundf(sender.value);
    [self getDateFromInt:progress];
    [labelButton setTitle:[self textForButton] forState:UIControlStateNormal];
    CGFloat coorX = labelButton.frame.origin.x;
    
    //Tính toán vị trí button dựa vào giá trị của slider
    switch (type) {
        case sldTime:
            coorX += ((sender.value - previousValue) * (self.frame.size.width / (self.maximumValue - self.minimumValue + 155)));
            break;
        case sldDate:
            coorX += ((sender.value - previousValue) * (self.frame.size.width / (self.maximumValue - self.minimumValue + 38)));
            break;
        default:
            break;
    }
    
    //Nếu quá
    if(coorX < self.frame.origin.x){
        coorX += labelButton.frame.size.width + 17;
    }
    if(coorX + labelButton.frame.size.width > self.frame.size.width + self.frame.origin.x){
        coorX -= labelButton.frame.size.width + 17;
    }
    previousValue = sender.value;
    [labelButton setFrame:CGRectMake(coorX, labelButton.frame.origin.y, labelButton.frame.size.width, labelButton.frame.size.height)];
    [popupMenu setFrameforTriangular:((self.value-self.minimumValue)/(self.maximumValue-self.minimumValue))*(self.frame.size.width-self.currentThumbImage.size.width) + /*self.currentThumbImage.size.width/2*/ - spaceToMiniSlider/2 - 2];
    if (delegate && [delegate respondsToSelector:@selector(slider:didChangeValue:)]) {
        [delegate slider:self didChangeValue:[self textForButton]];
    }
}

- (NSString *)textForButton{
    //Text cho button
    switch (type) {
            //Kiểm tra kiểu slider để trả về text phù hợp
        case sldDate:
            return [NSString stringWithFormat:@"%04d/%02d/%02d", year, month, day];
            break;
        case sldTime:
            return [NSString stringWithFormat:@"%02d:%02d", hour, min];
            break;
        default:
            break;
    }
}

- (void) getDateFromInt:(NSInteger)value{
    //Lấy ra các giá trị ngày tháng năm từ value trên slider
    month = 0;
    switch (type) {
        case sldDate:
            while(value > numberDate[month]){
                value -= numberDate[month];
                month++;
            }
            month = month + 1;
            day = value;
            break;
        case sldTime:
            hour = value/60;
            min = value%60;
            break;
        default:
            break;
    }
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *timeComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    [timeComp setMinute:min];
    [timeComp setHour:hour];
    [timeComp setDay:day];
    [timeComp setMonth:month];
    [timeComp setYear:year];
    
    date = [gregorian dateFromComponents:timeComp];
}

- (float)getValueFromTime{
    //Lấy giá trị từ thời gian
    float temp;
    switch (type) {
            //Lấy giá trị ngày
        case sldDate:
            //Kiểm tra năm nhuận
            if([self isLeapYear]){
                numberDate[1] = 29;
            }
            temp = day;
            for (NSInteger i = 0; i < month - 1; i++) {
                temp += numberDate[i];
            }
            break;
            //Lấy giá trị giờ
        case sldTime:
            temp = hour * 60 + min;
            break;
        default:
            break;
    }
    return temp;
}

//Lấy ngày tháng từ đối tượng NSDate
-(void) getDateComponent:(NSDate *)dateValue{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *timeComp = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit |
                                                        NSMonthCalendarUnit | NSYearCalendarUnit)
                                              fromDate:date];
    sec = [timeComp second];
    min = [timeComp minute];
    hour = [timeComp hour];
    day = [timeComp day];
    month = [timeComp month];
    year = [timeComp year];
}

//Kiểm tra năm nhuận
- (bool)isLeapYear{
    if((year%4 == 0 && year%100 != 0) || year%400 == 0){
        return YES;
    }
    return NO;
}

@end