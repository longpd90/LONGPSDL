//
//  PDMapToolBarView.h
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDButtonMapTools.h"  
#define kPDButtonLocationToolsClickedNotification   @"kPDButtonLocationToolsClickedNotification"
#define kPDButtonSpotToolsClickedNotification       @"kPDButtonSpotToolsClickedNotification"
#define kPDButtonSunMoonClickedNotification         @"kPDButtonSunMoonClickedNotification"

@protocol PDMapToolBarViewDelegate <NSObject>
- (void)changeViewMode:(id)sender;
@end

@interface PDMapToolBarView : UIView 

@property (nonatomic, strong) IBOutlet PDButtonMapTools *btnCurrentLocation;
@property (nonatomic, strong) IBOutlet PDButtonMapTools *btnPhotoSpots;
@property (nonatomic, strong) IBOutlet PDButtonMapTools *btnSunMoon;
@property (nonatomic, strong) IBOutlet PDButtonMapTools *btnSunMoonDateTime;
@property (nonatomic, strong) IBOutlet UIImageView *linkImage;
@property (nonatomic, assign) id<PDMapToolBarViewDelegate> delegate;

- (IBAction)btnCurrentLocationSelected:(id)sender;
- (IBAction)btnPhotoSpotsSelected:(id)sender;
- (IBAction)btnSunMoonSelected:(id)sender;
- (IBAction)btnSunMoonDateTimeSelected:(id)sender;
- (BOOL)isButtonPhotoSpotActived;
@end
