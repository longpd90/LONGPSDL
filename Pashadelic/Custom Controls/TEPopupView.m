//
// TEPopupView.m
//
// Created by Tuấn Nguyễn Anh on 6/3/13.
// Copyright (c) 2013 Tuấn Nguyễn Anh. All rights reserved.
//

#import "TEPopupView.h"

@interface TouchView : UIView {
    TEPopupView *popupView;
}
@property (strong, nonatomic) TEPopupView *popupView;
@end

@implementation TouchView
@synthesize popupView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([popupView shouldBeDismissedFor:touches withEvent:event]) {
        [popupView dismissModal];
    }
}
@end

@implementation TEPopupView
@synthesize miniSlider, originalValue, midValue;
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 0;
        originalValue = 0;
        
//        miniSlider = [[UISlider alloc] initWithFrame: CGRectMake(5, 4, self.frame.size.width - 10, 23)];
        miniSlider = [[UISlider alloc] initWithFrame: CGRectMake(_spaceToMinislider, 6.5, self.frame.size.width - _spaceToMinislider*2, 23)];
        UIImage *minTrackImage = [[UIImage imageNamed:@"image_slider.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        UIImage *thumbImage = [UIImage imageNamed:@"icon_current_point_date_time.png"];
        
        [miniSlider setMinimumTrackImage:minTrackImage forState:UIControlStateNormal];
        [miniSlider setMaximumTrackImage:minTrackImage forState:UIControlStateNormal];
        [miniSlider setThumbImage:thumbImage forState:UIControlStateNormal];
        
//        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_maptools_view.png"]]];
        [self setBackgroundColor:[UIColor clearColor]];
        strokeWidth = 0;
        cornerRadius = 6;
        _triangularFrame = CGRectMake(0, self.frame.size.height, 15, 5);
        
        [miniSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        contentRect = self.frame;
    }
    return self;
}

- (void)addTarget:(id)newTarget action:(SEL)newAction {
	if ([newTarget respondsToSelector:newAction]) {
		target = newTarget;
		action = newAction;
	}
}

- (void)addSlider
{
    miniSlider.value = (miniSlider.maximumValue -  miniSlider.minimumValue)/2;
    [self addSubview:miniSlider];
}

- (IBAction)valueChanged:(UISlider *)sender
{
    [delegate miniSliderChange:sender.value];
}

- (void)setFrameforTriangular:(float)coorX
{
    _triangularFrame = CGRectMake(coorX, 0, 15, 5);
    //Vẽ lại UIView
    [self setNeedsDisplay];
}

#pragma - mark Present modal

- (void)showPopupView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (self.touchView) {
        [self.touchView removeFromSuperview];
        self.touchView = nil;
    }
    self.touchView = [[TouchView alloc] initWithFrame:window.frame];
    self.touchView.popupView = self;
    [window addSubview:self.touchView];
    [self showPopup];
}
- (void)showPopup
{
    [self.touchView addSubview:self];
    miniSlider.value = (miniSlider.maximumValue - miniSlider.minimumValue)/2;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [self setAlpha:1.0];
    [UIView commitAnimations];
}

- (BOOL)shouldBeDismissedFor:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint Point = [touch locationInView:self];
    CGPoint pointInPopupView = [self convertPoint:Point fromView:self.superview];
    return !CGRectContainsPoint(contentRect, pointInPopupView);
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)dismissModal {
	[self.touchView removeFromSuperview];
	[self dismiss];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGFloat minx = CGRectGetMinX(rect) + strokeWidth;
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect) - strokeWidth;
    CGFloat miny = CGRectGetMinY(rect) + strokeWidth + _triangularFrame.size.height;
    CGFloat midy = CGRectGetMidY(rect) + _triangularFrame.size.height/2;
    CGFloat maxy = CGRectGetMaxY(rect) - strokeWidth - _triangularFrame.size.height;
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerRadius);
    
    CGContextAddLineToPoint(context, _triangularFrame.origin.x, miny);
    CGContextAddLineToPoint(context, _triangularFrame.origin.x + _triangularFrame.size.width/2, miny - _triangularFrame.size.height);
    CGContextAddLineToPoint(context, _triangularFrame.origin.x + _triangularFrame.size.width, miny);
    
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerRadius);
    CGContextAddArcToPoint(context, maxx, maxy, _triangularFrame.origin.x + _triangularFrame.size.width, maxy, cornerRadius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerRadius);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

#pragma mark - Override

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if ([self shouldBeDismissedFor:touches withEvent:event] && self.touchView != nil) {
		[self dismissModal];
		return;
	}	
}
@end