//
//  PDEffectCircleExpandView.m
//
//  Created by LongPD on 12/06/13.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "PDEffectCircleExpandView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PDEffectCircleExpandView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)circleExpand
{
    self.didExpandCircle = YES;
    CALayer *waveLayer=[CALayer layer];
    waveLayer.frame = CGRectMake(self.centerOfView.x - 20, self.centerOfView.y - 20, 40, 40);
    waveLayer.borderColor =[UIColor colorWithWhite:1 alpha:1].CGColor;
    waveLayer.borderWidth = 1.5;
    waveLayer.cornerRadius = 20.0;
    [self.layer addSublayer:waveLayer];
    [self scaleBegin:waveLayer];
}

- (void)scaleBegin:(CALayer *)aLayer
{
    const float maxScale = 2.2;
    if (aLayer.transform.m11 < maxScale) {
        if (aLayer.transform.m11 == 1.0) {
            [aLayer setTransform:CATransform3DMakeScale( 1.05, 1.05, 1.0)];
            
        }else{
            [aLayer setTransform:CATransform3DScale(aLayer.transform, 1.05, 1.05, 1.0)];
        }
        aLayer.borderColor =[UIColor colorWithWhite:1 alpha:1 / (aLayer.transform.m11 * aLayer.transform.m11 * aLayer.transform.m11)].CGColor;
        [self performSelector:_cmd withObject:aLayer afterDelay:0.05];
    }else
    {
        [aLayer removeFromSuperlayer];
        [self circleExpand];
    }
}

@end
