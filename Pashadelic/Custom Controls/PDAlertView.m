//
//  PDAlertView.m
//  Pashadelic
//
//  Created by TungNT2 on 12/20/13.
//
//

#import "PDAlertView.h"
#import "PDGradientButton.h"

@interface PDAlertView (Private)
- (void)showAnimated;
- (void)dismissAnimatedWithBackgroundView:(BOOL)isDismissBackgroundView;
- (void)removeAlertView;
- (void)removeAll;
@end
@implementation PDAlertView

- (void)initialize
{
    self.clipsToBounds = YES;
	self.layer.cornerRadius = 5;
}

- (void)show
{
    UIWindow *window = kPDAppDelegate.window;
    UIView *backgroundView = [window viewWithTag:kPDWindowBackgroundViewTag];
    if (!backgroundView) {
        backgroundView = [[UIView alloc] initWithFrame:window.frame];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        backgroundView.userInteractionEnabled = YES;
        backgroundView.tag = kPDWindowBackgroundViewTag;
        [window addSubview:backgroundView];
    }
    
    self.x = (window.width - self.width)/2;
    self.y = (window.height - self.height)/2;
	[backgroundView addSubview:self];

    [self showAnimated];
}

- (void)dismissWithBackgroundView:(BOOL)isDismissBackgroundView
{
    [self dismissAnimatedWithBackgroundView:isDismissBackgroundView];
}

#pragma mark - Private

- (void)removeAlertView
{
    [self removeFromSuperview];
}

- (void)removeAll
{
    [self removeFromSuperview];
    if ([kPDAppDelegate.window viewWithTag:kPDWindowBackgroundViewTag]) {
        [[kPDAppDelegate.window viewWithTag:kPDWindowBackgroundViewTag] removeFromSuperview];
    }
}

#pragma mark - transistion animation

- (void)showAnimated
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.3;
    
    [self.layer addAnimation:animation forKey:@"show"];
}

- (void)dismissAnimatedWithBackgroundView:(BOOL)isDismissBackgroundView
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.0, 0.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = 0.2;
    
    [self.layer addAnimation:animation forKey:@"hide"];
    if (isDismissBackgroundView)
        [self performSelector:@selector(removeAll) withObject:nil afterDelay:0.2];
    else
        [self performSelector:@selector(removeAlertView) withObject:nil afterDelay:0.2];
}

@end
