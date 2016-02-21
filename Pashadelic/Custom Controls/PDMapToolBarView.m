//
//  PDMapToolBarView.m
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import "PDMapToolBarView.h"

@interface PDMapToolBarView (Private)
- (void)changeLayoutForButton:(PDButtonMapTools *)button;
@end

@implementation PDMapToolBarView
@synthesize btnCurrentLocation;
@synthesize btnPhotoSpots;
@synthesize btnSunMoon;
@synthesize btnSunMoonDateTime;
@synthesize linkImage;
@synthesize delegate;

- (id)init
{
    self = [UIView loadFromNibNamed:@"PDMapToolBarView"];
    if (self) {
        // Initialization code
        btnSunMoonDateTime.hidden = btnSunMoon.currentState == PDButtonMapToolsStateOff ? YES : NO;
        linkImage.hidden = btnSunMoon.currentState == PDButtonMapToolsStateOff ? YES : NO;
        btnCurrentLocation.tag = 0;
        btnPhotoSpots.tag = 1;
        btnSunMoon.tag = 2;
        btnSunMoonDateTime.tag = 3;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(buttonMapToolsActived:)
                                                     name:kPDButtonMapToolActivedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(btnCurrentLocationChangeState:)
                                                     name:kPDUserTrackingModeChangedNotification object:nil];
    }
    return self;
}

- (void)changeLayoutForButton:(PDButtonMapTools *)button
{
    switch (button.currentState) {
        case PDButtonMapToolsStateOff:
            if (button.tag == 0) {
                [button layoutForImage:[UIImage imageNamed:@"btn_current_location_off.png"] inView:self];
            } else if (button.tag == 1) {
                [button layoutForImage:[UIImage imageNamed:@"btn_photo_spot_off.png"] inView:self];
            } else if (button.tag == 2) {
                [button layoutForImage:[UIImage imageNamed:@"btn_sun_moon_off.png"] inView:self];
            } else if (button.tag == 3) {
                [button layoutForImage:[UIImage imageNamed:@"btn_date_time_off.png"] inView:self];
            }
            break;
        case PDButtonMapToolsStateOn:
            if (button.tag == 0) {
                [button layoutForImage:[UIImage imageNamed:@"btn_current_location_on.png"] inView:self];
            } else if (button.tag == 1) {
                [button layoutForImage:[UIImage imageNamed:@"btn_photo_spot_on.png"] inView:self];
            } else if (button.tag == 2) {
                [button layoutForImage:[UIImage imageNamed:@"btn_sun_moon_on.png"] inView:self];
            } else if (button.tag == 3) {
                [button layoutForImage:[UIImage imageNamed:@"btn_date_time_on.png"] inView:self];
            }
            break;
        case PDButtonMapToolsStateActive:
            if (button.tag == 0) {
                [button layoutForImage:[UIImage imageNamed:@"btn_current_location_active.png"] inView:self];
            } else if (button.tag == 1) {
                [button layoutForImage:[UIImage imageNamed:@"btn_photo_spot_active.png"] inView:self];
            } else if (button.tag == 2) {
                [button layoutForImage:[UIImage imageNamed:@"btn_sun_moon_active.png"] inView:self];
            } else if (button.tag == 3) {
                [button layoutForImage:[UIImage imageNamed:@"btn_date_time_active.png"] inView:self];
            }
            break;
        default:
            break;
    }
}

- (void)buttonMapToolsActived:(NSNotification *)notification
{
    PDButtonMapTools *button = (PDButtonMapTools *)notification.object;
    if (btnPhotoSpots != button && btnPhotoSpots.currentState == PDButtonMapToolsStateActive) {
        btnPhotoSpots.currentState = PDButtonMapToolsStateOn;
        [self changeLayoutForButton:btnPhotoSpots];
    }
    if (btnSunMoon != button && btnSunMoon.currentState == PDButtonMapToolsStateActive) {
        btnSunMoon.currentState = PDButtonMapToolsStateOn;
        [self changeLayoutForButton:btnSunMoon];
    }
    if (btnSunMoonDateTime != button && btnSunMoonDateTime.currentState == PDButtonMapToolsStateActive) {
        btnSunMoonDateTime.currentState = PDButtonMapToolsStateOn;
        [self changeLayoutForButton:btnSunMoonDateTime];
    }
}

- (IBAction)btnCurrentLocationSelected:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDButtonLocationToolsClickedNotification
                                                        object:btnCurrentLocation];
}

- (void)btnCurrentLocationChangeState:(NSNotification *)notification
{
    NSInteger state = [notification.object integerValue];
    [btnCurrentLocation swicthState:state];
    [self changeLayoutForButton:btnCurrentLocation];
}

- (IBAction)btnPhotoSpotsSelected:(id)sender
{
    [btnPhotoSpots swicthState];
    [self changeLayoutForButton:btnPhotoSpots];
    if (btnPhotoSpots.currentState == PDButtonMapToolsStateActive) {
        if (delegate && [delegate respondsToSelector:@selector(changeViewMode:)]) {
            [delegate changeViewMode:btnPhotoSpots];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDButtonSpotToolsClickedNotification
                                                        object:btnPhotoSpots];
}

- (IBAction)btnSunMoonSelected:(id)sender
{
    [btnSunMoon swicthState];
    btnSunMoonDateTime.hidden = btnSunMoon.currentState == PDButtonMapToolsStateOff ? YES : NO;
    linkImage.hidden = btnSunMoon.currentState == PDButtonMapToolsStateOff ? YES : NO;
    [self changeLayoutForButton:btnSunMoon];
    if (btnSunMoon.currentState == PDButtonMapToolsStateActive) {
        if (delegate && [delegate respondsToSelector:@selector(changeViewMode:)]) {
            [delegate changeViewMode:btnSunMoon];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDButtonSunMoonClickedNotification
                                                        object:btnSunMoon];
}

- (IBAction)btnSunMoonDateTimeSelected:(id)sender
{
    if (btnSunMoonDateTime.enabled) {
        [btnSunMoonDateTime swicthState];
        [self changeLayoutForButton:btnSunMoonDateTime];
        if (btnSunMoonDateTime.currentState == PDButtonMapToolsStateActive) {
            if (delegate && [delegate respondsToSelector:@selector(changeViewMode:)]) {
                [delegate changeViewMode:btnSunMoonDateTime];
            }
        } 
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PDButtonDateTimeClickedNotification"
                                                        object:btnSunMoonDateTime];
}

- (BOOL)isButtonPhotoSpotActived
{
    if (self.btnPhotoSpots.currentState == PDButtonMapToolsStateActive) {
        return YES;
    } else
        return NO;
}

@end
