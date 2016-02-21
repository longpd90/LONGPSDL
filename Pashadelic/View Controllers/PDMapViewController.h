//
//  PDMapViewController.h
//  Pashadelic
//
//  Created by TungNT2 on 4/25/13.
//
//

#import "PDViewController.h"
#import "PDPhotoMapToolsView.h"
#import "PDPhotosMapView.h"
#import "PDPhotoTableViewController.h"

enum
{
    PDMapToolStateNormal = 0,
    PDMapToolStateLocationUser,
    PDMapToolStateLocationSearch
} typedef PDMapToolState;

@interface PDMapViewController : PDPhotoTableViewController
<PDItemSelectDelegate, MGServerExchangeDelegate>
{
    NSString *searchText;
}

@property (nonatomic, strong) PDPhotosMapView *photosMapView;
@property (nonatomic, assign) CLLocationCoordinate2D centerMapView;
@property (nonatomic, assign) CLLocationCoordinate2D searchLocation;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) NSArray *items;
@property (nonatomic, assign) BOOL isHiddenPhotoSpot;
@property (nonatomic, assign) BOOL isHiddenSunMoon;
@property (nonatomic, weak) NSDate *date;
@property (nonatomic, strong) UIImageView *iconCompass;
@property (nonatomic, assign) PDMapToolState state;
- (void)initialize;
- (void)resignCurrentResponder;
- (void)changeUserTrackingMode;
- (void)showMapViewForLocation:(CLLocationCoordinate2D)firstLocation andLocation:(CLLocationCoordinate2D)secondLocation;
- (void)loadPhotoSpotsForCoordinate:(CLLocationCoordinate2D)coordinate;
@end
