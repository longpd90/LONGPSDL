//
//  PDItemMapView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDItemMapView.h"

@implementation PDItemMapView
@synthesize items, mapView, itemSelectDelegate,titleView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self initialize];
    }
    return self;
}

- (void)reloadMap
{
}

- (void)clearMap
{
}

- (void)releaseMemory
{
	self.mapView.mapType = MKMapTypeStandard;
	self.mapView.showsUserLocation = NO;
	self.mapView.delegate = nil;
	[self.mapView removeFromSuperview];
	self.mapView = nil;
}

- (void)dealloc
{
	self.mapView.delegate = nil;
	[self.mapView removeFromSuperview];
	self.mapView = nil;
}

- (void)initialize
{
	self.autoresizingMask = kFullAutoresizingMask;
	mapView = [[MKMapView alloc] initWithFrame:CGRectMakeWithSize(0, 0, self.frame.size)];
	mapView.delegate = self;
	[self addSubview:mapView];
	mapView.autoresizingMask = kFullAutoresizingMask;

}

- (void)setTitleView:(UIView *)newTitleView
{
	titleView = newTitleView;
	if (titleView) {
		titleView.frame = CGRectMakeWithSize(0, 0, titleView.frame.size);	
		if (![titleView.superview isEqual:self]) {
			[self addSubview:titleView];
		}
		[self bringSubviewToFront:titleView];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	mapView.frame = CGRectWithY(mapView.frame, titleView.height);
	mapView.frame = CGRectWithHeight(mapView.frame, self.height - titleView.height);
}



@end
