//
//  PDPhotoMapToolsView.m
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import "PDPhotoMapToolsView.h"

@interface PDPhotoMapToolsView (Private)
- (void)initContentView;
- (void)showContentView:(NSInteger)viewMode;
@end
@implementation PDPhotoMapToolsView

@synthesize photoSpotsView;
@synthesize sunMoonDateTimeOptionView;
@synthesize sunMoonShowHideOptionView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initContentView];
        _viewMode = PDPhotoToolsViewModeSpots;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self showContentView:_viewMode];
}

- (void)initContentView
{
    self.photoSpotsView = [[PDPhotoSpotsView alloc] init];
    [self.contentView addSubview:photoSpotsView];
    
    self.sunMoonShowHideOptionView = [[PDSunMoonShowHideOptionView alloc] init];
    [self.contentView addSubview:self.sunMoonShowHideOptionView];
    
    self.sunMoonDateTimeOptionView = [[PDSunMoonDateTimeOptionView alloc] init];
    [self.contentView addSubview:self.sunMoonDateTimeOptionView];
    
    self.mapToolBarView.delegate = self;
    self.photoSpotsView.hidden = NO;
    self.sunMoonShowHideOptionView.hidden = YES;
    self.sunMoonDateTimeOptionView.hidden = YES;
}

- (void)changeViewMode:(id)sender
{
    self.viewMode = [(UIButton *)sender tag];
    [self showContentView:_viewMode];
    if (![self isOpened]) {
        [self setOpened:YES animated:YES];
    }
}

- (void)showContentView:(NSInteger)viewMode
{
    if (viewMode == PDPhotoToolsViewModeSpots) {
        self.photoSpotsView.hidden = NO;
        self.sunMoonShowHideOptionView.hidden = YES;
        self.sunMoonDateTimeOptionView.hidden = YES;
        self.frame = CGRectMake(0, self.y, self.width, PDPhotoSpotsViewHeight);
        self.openedCenter = CGPointMake(160, self.superview.height - PDPhotoSpotsViewHeight/2 + 1);
        self.closedCenter = CGPointMake(160, self.superview.height + PDPhotoSpotsViewHeight/2 + 1 - PDToolBarViewHeight);
    }
    else if (viewMode == PDPhotoToolsViewModeSunMoon) {
        self.photoSpotsView.hidden = YES;
        self.sunMoonShowHideOptionView.hidden = NO;
        self.sunMoonDateTimeOptionView.hidden = YES;
        self.frame = CGRectMake(0, self.y, self.width, PDSunMoonShowHideOptionViewHeight);
        self.openedCenter = CGPointMake(160, self.superview.height - PDSunMoonShowHideOptionViewHeight/2 + 1);
        self.closedCenter = CGPointMake(160, self.superview.height + PDSunMoonShowHideOptionViewHeight/2 + 1 - PDToolBarViewHeight);
    }
    else if (viewMode == PDPhotoToolsViewModeDateTime) {
        self.photoSpotsView.hidden = YES;
        self.sunMoonShowHideOptionView.hidden = YES;
        self.sunMoonDateTimeOptionView.hidden = NO;
        self.frame = CGRectMake(0, self.y, self.width, PDSunMoonDateTimeOptionViewHeight);
        self.openedCenter = CGPointMake(160, self.superview.height - PDSunMoonDateTimeOptionViewHeight/2 + 1);
        self.closedCenter = CGPointMake(160, self.superview.height + PDSunMoonDateTimeOptionViewHeight/2 + 1 - PDToolBarViewHeight);
    }
    [self changeContentSize];
}

- (void)finish
{
    switch (_viewMode) {
        case PDPhotoToolsViewModeSpots:
            [self.photoSpotsView saveDataFilter];
            break;
        case PDPhotoToolsViewModeSunMoon:
            break;
        case PDPhotoToolsViewModeDateTime:
            break;
        default:
            break;
    }
}
@end
