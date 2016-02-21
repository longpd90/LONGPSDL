//
//  PDSunMoonShowHideOptionView.m
//  PhotoMapToolDemo
//
//  Created by TungNT2 on 4/12/13.
//  Copyright (c) 2013 TungNT2. All rights reserved.
//

#import "PDSunMoonShowHideOptionView.h"

@implementation PDSunMoonShowHideOptionView

- (id)init
{
    self = [UIView loadFromNibNamed:@"PDSunMoonShowHideOptionView"];
    if (self) {
        // Initialization code
        self.showHideLabel.text = NSLocalizedString(@"Show/Hide", nil);
        [self.btnSunRise setTitle:NSLocalizedString(@"sunrise", nil) forState:UIControlStateNormal | UIControlStateSelected];
        [self.btnSunSet setTitle:NSLocalizedString(@"sunset", nil) forState:UIControlStateNormal | UIControlStateSelected];
        [self.btnMoonRise setTitle:NSLocalizedString(@"moonrise", nil) forState:UIControlStateNormal | UIControlStateSelected];
        [self.btnMoonSet setTitle:NSLocalizedString(@"moonset", nil) forState:UIControlStateNormal | UIControlStateSelected];
			self.btnMoonRise.layer.cornerRadius = self.btnMoonSet.layer.cornerRadius = self.btnSunRise.layer.cornerRadius = self.btnSunSet.layer.cornerRadius = 3;
			self.btnMoonRise.layer.masksToBounds = self.btnMoonSet.layer.masksToBounds = self.btnSunRise.layer.masksToBounds = self.btnSunSet.layer.masksToBounds = YES;
        self.btnSunRise.selected = !kPDSunRiseHidden;
        self.btnSunSet.selected = !kPDSunSetHidden;
        self.btnMoonRise.selected = !kPDMoonRiseHidden;
        self.btnMoonSet.selected = !kPDMoonSetHidden;
    }
    return self;
}

- (IBAction)btnSunRiseClicked:(id)sender
{
    self.btnSunRise.selected = !self.btnSunRise.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDSunMoonOptionChangedNotification object:self.btnSunRise];
}

- (IBAction)btnSunSetClicked:(id)sender
{
    self.btnSunSet.selected = !self.btnSunSet.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDSunMoonOptionChangedNotification object:self.btnSunSet];
}

- (IBAction)btnMoonRiseClicked:(id)sender
{
    self.btnMoonRise.selected = !self.btnMoonRise.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDSunMoonOptionChangedNotification object:self.btnMoonRise];
}

- (IBAction)btnMoonSetClicked:(id)sender
{
    self.btnMoonSet.selected = !self.btnMoonSet.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDSunMoonOptionChangedNotification object:self.btnMoonSet];
}

@end
