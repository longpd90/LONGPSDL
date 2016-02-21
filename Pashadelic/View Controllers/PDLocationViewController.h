//
//  PDLandmarkViewController.h
//  Pashadelic
//
//  Created by TungNT2 on 6/16/14.
//
//

#import "PDViewController.h"
#import "PDPhotoTableViewController.h"
#import "PDPhotosTableView.h"
#import "PDServerLocationLoader.h"
#import "PDLocation.h"
#import "PDPhotosScrollView.h"
#import "PDListLandmarkViewController.h"
#import "PDDrawMoon.h"
#import "PDLocationInfoTableView.h"

@interface PDLocationViewController : PDPhotoTableViewController <PDItemsTableDelegate, MGServerExchangeDelegate, UIScrollViewDelegate,
PDPhotoViewDelegate, PDPhotoScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet PDPhotosScrollView *popularPhotospotsScrollView;
@property (strong, nonatomic) PDLocationInfoTableView *locationTableView;
@property (weak, nonatomic) IBOutlet UIButton *ownerAvatarButton;
@property (weak, nonatomic) IBOutlet UIView *locationInfoView;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *monthButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *timeButton;
@property (weak, nonatomic) IBOutlet MKMapView *locationMapView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunRiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunSetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moonSetImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moonRiseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *angleRightImageView;
@property (weak, nonatomic) IBOutlet UIView *graphicView;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *moonRiseLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *moonSetLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *sunRiseLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet PDDrawMoon *drawMoon;
@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *forecastLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *dateTimeTakenOnLabel;
@property (weak, nonatomic) IBOutlet UIView *previewMapView;
@property (weak, nonatomic) IBOutlet UIView *viewOnMapView;
@property (weak, nonatomic) IBOutlet UIButton *viewOnMapButton;
@property (weak, nonatomic) IBOutlet UIView *landmarksView;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *seeAllLandmarksButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconLandmarksImageView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *numberLandmarksLabel;
@property (weak, nonatomic) IBOutlet UIView *photospotsView;
@property (weak, nonatomic) IBOutlet UIImageView *iconPhotospotsImageView;
@property (weak, nonatomic) IBOutlet UIView *photospotsSubview;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *numberPhotospotsLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *seeAllPhotospotsButton;
@property (weak, nonatomic) IBOutlet UIView *photographersView;
@property (weak, nonatomic) IBOutlet UIImageView *iconPhotographersImageView;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *numberPhotographersLabel;
@property (weak, nonatomic) IBOutlet PDDynamicFontButton *seeAllPhotographersButton;

@property (strong, nonatomic) NSArray *landmarkImages;
@property (strong, nonatomic) NSArray *photospotImages;
@property (strong, nonatomic) NSArray *photographerImages;

@property (strong, nonatomic) PDServerLocationLoader *locationLoader;
@property (strong, nonatomic) PDLocation *location;

@property (weak, nonatomic) id <PDPhotoViewDelegate> photoViewDelegate;

- (IBAction)ownerAvatarButtonDidClicked:(id)sender;
- (IBAction)showGraphicsByMonth:(id)sender;
- (IBAction)showGraphicsByTime:(id)sender;
- (IBAction)forecastWeatherDidClicked:(id)sender;
- (IBAction)goToMap:(id)sender;
- (IBAction)seeAllLandmarksButtonClicked:(id)sender;
- (IBAction)seeAllPhotospotsButtonClicked:(id)sender;
- (IBAction)seeAllPhotographersButtonClicked:(id)sender;

@end
