//
//  PDSpotMenuView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIMenuView.h"

@interface PDNearbyMenuView : UIMenuView

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSelector;
@property (weak, nonatomic) IBOutlet UILabel *rangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesRangeLabel;
@property (weak, nonatomic) IBOutlet UISlider *rangeSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *daytimeSelector;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seasonSelector;
@property (weak, nonatomic) IBOutlet UISwitch *seasonSwitch;

- (IBAction)rangeValueChanged:(id)sender;

@end
