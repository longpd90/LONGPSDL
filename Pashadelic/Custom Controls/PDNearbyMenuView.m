//
//  PDSpotMenuView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDNearbyMenuView.h"


@implementation PDNearbyMenuView
@synthesize rangeLabel;
@synthesize rangeSlider;
@synthesize daytimeSelector;
@synthesize seasonSelector;
@synthesize sortSelector;

- (id)init
{
	self = [UIView loadFromNibNamed:@"PDNearbyMenuView"];
	
	if (self) {
		[self initialize];
	}
	
	return self;
}

- (void)initialize
{
	[super initialize];
	sortSelector.selectedSegmentIndex = kPDDefaultNearbySorting;
	rangeSlider.value = kPDNearbyRange == 0 ? 25 : kPDNearbyRange;
	daytimeSelector.selectedSegmentIndex = kPDNearbyDaytime;
	seasonSelector.selectedSegmentIndex = kPDNearbySeason - 1;
	_seasonSwitch.on = kPDNearbySeasonsEnabled;
	[self rangeValueChanged:rangeSlider];

}

- (IBAction)rangeValueChanged:(id)sender
{
	double value = rangeSlider.value;
	if (value < 1) {
		rangeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Range %zdm", nil), (NSInteger) (value * 1000)];
	} else {
		rangeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Range %.1fkm", nil), value];
	}
	_milesRangeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"(%.1f mi)", nil), value * 0.621371192];
}


- (void)finish:(id)sender
{
	if (kPDDefaultNearbySorting  != sortSelector.selectedSegmentIndex) {
		[kPDUserDefaults setInteger:sortSelector.selectedSegmentIndex 
							 forKey:kPDDefaultNearbySortingKey];
		self.needRefetchData = YES;
	}
	
	if (kPDNearbySeasonsEnabled  != _seasonSwitch.on) {
		[kPDUserDefaults setBool:_seasonSwitch.on
						  forKey:kPDNearbySeasonsEnabledKey];
		self.needRefetchData = YES;
	}
	
	if (kPDNearbySeason - 1 != seasonSelector.selectedSegmentIndex) {
		[kPDUserDefaults setInteger:seasonSelector.selectedSegmentIndex + 1
							 forKey:kPDNearbySeasonKey];
		self.needRefetchData = YES;
	}
	
	if (kPDNearbyDaytime != daytimeSelector.selectedSegmentIndex) {
		[kPDUserDefaults setInteger:daytimeSelector.selectedSegmentIndex 
							 forKey:kPDNearbyDaytimeKey];
		self.needRefetchData = YES;
	}
		
	if (kPDNearbyRange != rangeSlider.value) {
		[kPDUserDefaults setDouble:rangeSlider.value forKey:kPDNearbyRangeKey];
		self.needRefetchData = YES;
	}
	
	[super finish:sender];
}

@end
