//
//  PDPhotoMapToolsView.h
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import "PDPullableView.h"
#import "PDPhotoSpotsView.h"
#import "PDSunMoonShowHideOptionView.h"
#import "PDSunMoonDateTimeOptionView.h"

#define PDToolBarViewHeight                 31
#define PDPhotoSpotsViewHeight              223
#define PDSunMoonShowHideOptionViewHeight   131
#define PDSunMoonDateTimeOptionViewHeight   146

@interface PDPhotoMapToolsView : PDPullableView <PDMapToolBarViewDelegate>

@property (nonatomic, strong) PDPhotoSpotsView *photoSpotsView;
@property (nonatomic, strong) PDSunMoonShowHideOptionView *sunMoonShowHideOptionView;
@property (nonatomic, strong) PDSunMoonDateTimeOptionView *sunMoonDateTimeOptionView;
@property (nonatomic, assign) NSInteger viewMode;
- (void)finish;
@end
