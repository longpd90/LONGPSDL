//
//  PDUpcomingPlanViewController.h
//  Pashadelic
//
//  Created by LongPD on 8/26/14.
//
//

#import "PDPhotoTableViewController.h"
#import "PDUpcomingPlanTableView.h"

@interface PDUpcomingPlanViewController : PDPhotoTableViewController<PDUpcomingPlanDelegate>

@property (strong, nonatomic) IBOutlet UIView *expandView;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *theNewButton;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *upcomingButton;
@property (weak, nonatomic) IBOutlet MGLocalizedButton *myPlanButton;

@property (strong, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet PDDynamicSizeButton *changeSortButton;

@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;

@property (strong, nonatomic) PDUpcomingPlanTableView *plansTableView;

- (IBAction)changeSortButton:(id)sender;
- (IBAction)showNewPlans:(id)sender;
- (IBAction)showUpcomingPlans:(id)sender;
- (IBAction)showMyPlans:(id)sender;

@end
