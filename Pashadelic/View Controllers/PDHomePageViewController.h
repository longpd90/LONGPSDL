//
//  PDHomepageViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.09.13.
//
//

#import "PDPhotoTableViewController.h"
#import "PDFeedTableView.h"
#import "PDLinedLabel.h"
#import "PDToolbarButton.h"
#import "PDForeCastWeatherViewController.h"
#import "PDDynamicFontLabel.h"
#import "PDActivitiesTableView.h"
#import "PDServerGetTodaysPhoto.h"

@interface PDHomePageViewController : PDPhotoTableViewController

@property (weak, nonatomic) IBOutlet PDToolbarButton *sourceFeedButton;
@property (weak, nonatomic) IBOutlet PDToolbarButton *sourceActivitiesButton;
@property (strong, nonatomic) IBOutlet UIView *nearbyCollectView;
@property (weak, nonatomic) IBOutlet UIView *nearbyCollectContentView;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UILabel *nearbyCollectLabel;
@property (weak, nonatomic) IBOutlet UIImageView *nearbyCollectImage1;
@property (weak, nonatomic) IBOutlet UIImageView *nearbyCollectImage2;
@property (weak, nonatomic) IBOutlet UIImageView *nearbyCollectImage3;
@property (weak, nonatomic) IBOutlet UIImageView *nearbyCollectDisclosureImage;
@property (strong, nonatomic) IBOutlet UIView *recommendedView;

@property (strong, nonatomic) PDServerGetTodaysPhoto *serverGetTodaysPhoto;

@property (strong, nonatomic) PDActivitiesTableView *activitesTableView;
@property (strong, nonatomic) PDUsersTableView *usersTableView;
@property (strong, nonatomic) PDFeedTableView *feedTableView;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIButton *showMenuButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *upcomingEventTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet PDDynamicFontLabel *upcomingEventLabel;
@property (strong, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIView *moonViewPlaceholder;
@property (weak, nonatomic) IBOutlet UIButton *forecastButton;
@property (weak, nonatomic) IBOutlet UIButton *forecastButtonOverlay;

@property (strong, nonatomic) NSDate *firstActivitiesLoadedDateTime;

- (IBAction)showForecast:(id)sender;
- (IBAction)changeSource:(id)sender;
- (IBAction)showNearbyCollect:(id)sender;

@end
