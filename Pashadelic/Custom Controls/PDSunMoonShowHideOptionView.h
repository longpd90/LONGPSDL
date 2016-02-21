//
//  PDSunMoonShowHideOptionView.h
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import <UIKit/UIKit.h>
enum
{
    PDSunMoonOptionSunRise = 0,
    PDSunMoonOptionSunSet,
    PDSunMoonOptionMoonRise,
    PDSunMoonOptionMoonSet
};

@interface PDSunMoonShowHideOptionView : UIView

@property (strong, nonatomic) IBOutlet UILabel *showHideLabel;
@property (strong, nonatomic) IBOutlet UIButton *btnSunRise;
@property (strong, nonatomic) IBOutlet UIButton *btnSunSet;
@property (strong, nonatomic) IBOutlet UIButton *btnMoonRise;
@property (strong, nonatomic) IBOutlet UIButton *btnMoonSet;
@end
