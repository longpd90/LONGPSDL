//
//  PDPlansViewController.h
//  Pashadelic
//
//  Created by LongPD on 11/7/13.
//
//

#import "PDPhotoTableViewController.h"
#import "PDPlansTableView.h"
#import "PDPhotoTableViewController.h"

@interface PDPlansViewController : PDPhotoTableViewController
@property (strong, nonatomic) PDPlansTableView *plansTableView;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UILabel *creatPlanLabel;
@property (weak, nonatomic) IBOutlet UILabel *planByOtherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *calendarImageView;
@property (assign, nonatomic, getter = isUserHavePlans) BOOL userHavePlans;
@end
