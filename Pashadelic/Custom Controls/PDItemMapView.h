//
//  PDItemMapView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 12/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PDItem.h"
#import "PDLocationHelper.h"
#import "PDPhotoLocationView.h"

@interface PDItemMapView : UIView
<MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) id <PDItemSelectDelegate> itemSelectDelegate;
@property (weak, nonatomic) UIView *titleView;

- (void)reloadMap;
- (void)clearMap;
- (void)initialize;
- (void)releaseMemory;

@end
