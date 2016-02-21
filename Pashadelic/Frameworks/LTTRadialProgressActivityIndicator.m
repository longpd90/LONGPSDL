//
//  LTTRadialProgressActivityIndicator.m
//
//  Created by Nguyễn Hữu Anh on 5/16/14.
//  Copyright (c) 2014 Pashadelic. All rights reserved.
//

#import "LTTRadialProgressActivityIndicator.h"
#import "LTTActivitiIndicatorView.h"
#define DEGREES_TO_RADIANS(x) (x)/180.0*M_PI
#define RADIANS_TO_DEGREES(x) (x)/M_PI*180.0

#define PulltoRefreshThreshold 60.0
@interface UzysRadialProgressActivityIndicatorBackgroundLayer : CALayer

@property (nonatomic,assign) CGFloat outlineWidth;
- (id)initWithBorderWidth:(CGFloat)width;

@end
@implementation UzysRadialProgressActivityIndicatorBackgroundLayer
- (id)init
{
    self = [super init];
    if(self) {
        self.outlineWidth=2.0f;
        self.contentsScale = [UIScreen mainScreen].scale;
        [self setNeedsDisplay];
    }
    return self;
}
- (id)initWithBorderWidth:(CGFloat)width
{
    self = [super init];
    if(self) {
        self.outlineWidth=width;
        self.contentsScale = [UIScreen mainScreen].scale;
        [self setNeedsDisplay];
    }
    return self;
}
- (void)drawInContext:(CGContextRef)ctx
{
    //Draw white circle
    CGContextSetFillColor(ctx, CGColorGetComponents([UIColor colorWithWhite:1.0 alpha:0.0].CGColor));
    CGContextFillEllipseInRect(ctx,CGRectInset(self.bounds, self.outlineWidth, self.outlineWidth));
    
    //Draw circle outline
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:1 alpha:0.9].CGColor);
    CGContextSetLineWidth(ctx, self.outlineWidth);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(self.bounds, self.outlineWidth , self.outlineWidth ));
}
- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    _outlineWidth = outlineWidth;
    [self setNeedsDisplay];
}
@end

@interface LTTRadialProgressActivityIndicator()
@property (nonatomic, strong) UzysRadialProgressActivityIndicatorBackgroundLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) LTTActivitiIndicatorView *indicator;
@end

@implementation LTTRadialProgressActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _commonInit];
        self.imageIcon = [UIImage imageNamed:@"Logo_App_1.png"];
        // Initialization code
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, - PulltoRefreshThreshold, 25, 25)];
    if(self) {
        self.imageIcon =image;
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit
{
    self.borderColor = [UIColor colorWithRed:21.0/255.0 green:118.0/255.0 blue:185.0/255.0 alpha:1.0];
    self.borderWidth = 3.0f;
    self.contentMode = UIViewContentModeRedraw;
    self.state = LTTPullToRefreshStateNone;
    self.backgroundColor = [UIColor clearColor];
    //init actitvity indicator
    _indicator = [[LTTActivitiIndicatorView alloc] initWithFrame: self.bounds];
    
    //Add your custom activity indicator to your current view
    [self addSubview:_indicator];
    _indicator.hidden = YES;
    //init background layer
    UzysRadialProgressActivityIndicatorBackgroundLayer *backgroundLayer = [[UzysRadialProgressActivityIndicatorBackgroundLayer alloc] initWithBorderWidth:self.borderWidth];
    backgroundLayer.frame = self.bounds;
    [self.layer addSublayer:backgroundLayer];
    self.backgroundLayer = backgroundLayer;
    
    if(!self.imageIcon)
        self.imageIcon = [UIImage imageNamed:@"centerIcon"];
    
    //init icon layer
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contentsScale = [UIScreen mainScreen].scale;
    imageLayer.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
    imageLayer.contents = (id)self.imageIcon.CGImage;
    [self.layer addSublayer:imageLayer];
    self.imageLayer = imageLayer;
    self.imageLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(180),0,0,1);
    
    //init arc draw layer
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = nil;
    shapeLayer.strokeColor = self.borderColor.CGColor;
    shapeLayer.strokeEnd = 0;
    shapeLayer.shadowColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
    shapeLayer.shadowOpacity = 0.7;
    shapeLayer.shadowRadius = 20;
    shapeLayer.contentsScale = [UIScreen mainScreen].scale;
    shapeLayer.lineWidth = self.borderWidth;
    shapeLayer.lineCap = kCALineCapRound;
    
    [self.layer addSublayer:shapeLayer];
    self.shapeLayer = shapeLayer;
}

- (void)setImageIcon:(UIImage *)imageIcon
{
    _imageIcon = imageIcon;
    _imageLayer.contents = (id)_imageIcon.CGImage;
    _imageLayer.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
    
//    [self setSize:_imageIcon.size];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.shapeLayer.frame = self.bounds;
    [self updatePath];
    
}
- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:(self.bounds.size.width/2 - self.borderWidth)  startAngle:M_PI - DEGREES_TO_RADIANS(-90) endAngle:M_PI -DEGREES_TO_RADIANS(360-90) clockwise:NO];
    
    self.shapeLayer.path = bezierPath.CGPath;
}


- (void)setProgress:(double)progress
{
    static double prevProgress;
    
    if(progress > 1.0)
    {
        progress = 1.0;
    }
    
    self.alpha = 1.0 * progress;
    
    if (progress >= 0 && progress <=1.0) {
        //rotation Animation
        CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animationImage.fromValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180-180*prevProgress)];
        animationImage.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(180-180*progress)];
        animationImage.duration = 0.15;
        animationImage.removedOnCompletion = NO;
        animationImage.fillMode = kCAFillModeForwards;
        [self.imageLayer addAnimation:animationImage forKey:@"animation"];
        
        //strokeAnimation
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.fromValue = [NSNumber numberWithFloat:((CAShapeLayer *)self.shapeLayer.presentationLayer).strokeEnd];
        animation.toValue = [NSNumber numberWithFloat:progress];
        animation.duration = 0.35 + 0.25*(fabs([animation.fromValue doubleValue] - [animation.toValue doubleValue]));
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        //        [self.shapeLayer removeAllAnimations];
        [self.shapeLayer addAnimation:animation forKey:@"animation"];
        
    }
    _progress = progress;
    prevProgress = progress;
}
-(void)setLayerOpacity:(CGFloat)opacity
{
    self.imageLayer.opacity = opacity;
    self.backgroundLayer.opacity = opacity;
    self.shapeLayer.opacity = opacity;
}
-(void)setLayerHidden:(BOOL)hidden
{
    self.imageLayer.hidden = hidden;
    self.shapeLayer.hidden = hidden;
    self.backgroundLayer.hidden = hidden;
}
-(void)setCenter:(CGPoint)center
{
    [super setCenter:center];
}

- (void)setSize:(CGSize) size
{
    CGRect rect = CGRectMake((self.scrollView.bounds.size.width - size.width)/2,
                             -size.height, size.width, size.height);
    
    self.frame=rect;
    self.shapeLayer.frame = self.bounds;
    
    self.imageLayer.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
    self.indicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    self.backgroundLayer.frame = self.bounds;
    [self.backgroundLayer setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    
    _backgroundLayer.outlineWidth = _borderWidth;
    [_backgroundLayer setNeedsDisplay];
    
    _shapeLayer.lineWidth = _borderWidth;
    _imageLayer.frame = CGRectInset(self.bounds, self.borderWidth, self.borderWidth);
    
}
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    _shapeLayer.strokeColor = _borderColor.CGColor;
}

@end
