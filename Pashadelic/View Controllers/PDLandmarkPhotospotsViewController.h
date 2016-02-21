//
//  PDLandmarkPhotospotsViewController.h
//  Pashadelic
//
//  Created by LTT on 6/19/14.
//
//

#import "PDPhotoTableViewController.h"
#import "PDLocation.h"

@interface PDLandmarkPhotospotsViewController : PDPhotoTableViewController
<MGServerExchangeDelegate>
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *changeSortView;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *popularButton;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *newestButton;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *nextDaysButton;
@property (strong, nonatomic) IBOutlet UIView *navigationbarView;
@property (weak, nonatomic) IBOutlet MGLocalizedLabel *titleNavigationBar;
@property (weak, nonatomic) IBOutlet PDDynamicSizeButton *changeSortButton;
@property (strong, nonatomic) PDLocation *location;

- (id)initWithNibName:(NSString *)nibNameOrNil location:(PDLocation *)location;
- (IBAction)clickChangeSortButton:(id)sender;
- (IBAction)clickPopularButton:(id)sender;
- (IBAction)clickNewestButton:(id)sender;
- (IBAction)clickNextDaysButton:(id)sender;
- (IBAction)clickButtonMap:(id)sender;

@end
