//
//  PDPlanParticipantsViewController.h
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/25/14.
//
//

#import "PDPhotoUsersViewController.h"
#import "PDPlan.h"

@interface PDPlanParticipantsViewController : PDPhotoUsersViewController
@property (strong, nonatomic) PDPlan *plan;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;

@end
