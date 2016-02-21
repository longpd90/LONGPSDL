//
//  PDButtonMapTools.m
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/17/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import "PDButtonMapTools.h"

@interface PDButtonMapTools (Private)
@end

@implementation PDButtonMapTools
@synthesize currentState;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.currentState = PDButtonMapToolsStateOff;
}

- (void)setCurrentState:(NSInteger)newState
{
    currentState = newState;
    if (currentState == PDButtonMapToolsStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kPDButtonMapToolActivedNotification object:self];
    }
}

- (void)layoutForImage:(UIImage *)image inView:(UIView *)view
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height);
    [self setImage:image forState:UIControlStateNormal];
    
    CGFloat heightDifferent = self.frame.size.height - view.frame.size.height;
    if (heightDifferent < 0) {
        self.center = CGPointMake(self.center.x, view.center.y);
    } else {
        CGPoint center = view.center;
        center.y = center.y - heightDifferent/2.0;
        self.center = CGPointMake(self.center.x, center.y);
    }
}

- (void)swicthState
{
    if (currentState == PDButtonMapToolsStateOff) {
        self.currentState = PDButtonMapToolsStateActive;
    } else if (currentState == PDButtonMapToolsStateOn) {
        self.currentState = PDButtonMapToolsStateActive;
    } else if (currentState == PDButtonMapToolsStateActive) {
            self.currentState = PDButtonMapToolsStateOff;
    }
}

- (void)swicthState:(NSInteger)state
{
    self.currentState = state;
}

@end
