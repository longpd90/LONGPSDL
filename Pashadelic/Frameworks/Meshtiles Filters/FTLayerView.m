//
//  FTLayerView.m
//  Pashadelic
//
//  Created by TungNT2 on 1/30/13.
//
//

#import "FTLayerView.h"
@interface FTLayerView (Private)
@property(nonatomic,assign) CGRect holeRect;
@end

@implementation FTLayerView

@synthesize touchPoint1, touchPoint2;
@synthesize isRound, filterMode;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initializtion FTLayerView
        _radius = 80.0f;
        self.opaque = NO;
        self.userInteractionEnabled = NO;
        CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        self.holeRect = CGRectMake(center.x-self.radius, center.y-self.radius, self.radius*2, self.radius*2);
    }
    return self;
}

- (void)setCircleCenter:(CGPoint)circleCenter {
    _circleCenter = circleCenter;
    _holeRect = CGRectMake(self.circleCenter.x-self.radius, self.circleCenter.y-self.radius, self.radius*2, self.radius*2);
    [self setNeedsDisplay];
}
- (void)setRadius:(CGFloat)radius {
    _radius = radius;
    CGPoint center = CGPointMake(CGRectGetMidX(_holeRect), CGRectGetMidY(_holeRect));
    _holeRect = CGRectMake(center.x-self.radius, center.y-self.radius, self.radius*2, self.radius*2);
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing FTLayer
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t numLocations = 2;
    CGFloat locations[2] = {0.0, 0.1};
    CGFloat components[8] = {1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 1.0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, numLocations);
    switch (self.filterMode) {
        case PDImageFilterModeFinger:
        {
            CGPoint center = CGPointMake(CGRectGetMidX(_holeRect), CGRectGetMidY(_holeRect));
            CGContextDrawLinearGradient(context, gradient, CGPointMake(center.x, center.y+1), center, 0);
            CGContextDrawLinearGradient(context, gradient, CGPointMake(center.x+1, center.y), center, 0);
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
            break;
        }
        case PDImageFilterModeTiltShiftCircle:
        {
            CGPoint center = CGPointMake(CGRectGetMidX(_holeRect), CGRectGetMidY(_holeRect));
            CGContextDrawRadialGradient(context, gradient, center, self.radius, center, self.radius*2, kCGGradientDrawsAfterEndLocation);
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
            break;
        }
        case PDImageFilterModeTiltShiftSquare:
        {
            CGContextDrawLinearGradient(context, gradient, self.touchPoint1, CGPointMake(self.touchPoint1.x-0.9*(self.touchPoint2.x-self.touchPoint1.x),
                                                                                     self.touchPoint1.y-0.9*(self.touchPoint2.y-self.touchPoint1.y)), kCGGradientDrawsAfterEndLocation);
            
            CGContextDrawLinearGradient(context, gradient, self.touchPoint2, CGPointMake(self.touchPoint2.x+0.9*(self.touchPoint2.x-self.touchPoint1.x),
                                                                                     self.touchPoint2.y+0.9*(self.touchPoint2.y-self.touchPoint1.y)), kCGGradientDrawsAfterEndLocation);
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
            break;
        }
        default:
            CGColorSpaceRelease(colorSpace);
            CGGradientRelease(gradient);
            break;
    }
}


@end
