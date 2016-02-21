//
//  ApplyFilter.h
//  Instagram_Filter
//
//  Created by Jin on 30/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDViewController.h"
#import "GPUImage.h"
#import "PDScrollViewFilter.h"

@class FTImageView;
@class PDFilterViewController;

@protocol PDFilterViewControllerDelegate <NSObject>
- (void)filterDidCancel;
@end

@interface PDFilterViewController : PDViewController <UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) FTImageView *filteredImageView;
@property (nonatomic, strong) PDScrollViewFilter *scrollViewFilter;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, unsafe_unretained) id <PDFilterViewControllerDelegate> delegate;
@property (nonatomic,retain) UIButton *groupFilterButton;
@property (nonatomic,retain) UIImageView *selectedFilterBorder;
@property (nonatomic, strong) PDPhoto *photo;
@property (nonatomic, assign) int rotateImage;

@end

