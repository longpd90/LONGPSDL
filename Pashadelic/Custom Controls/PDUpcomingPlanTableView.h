//
//  PDUpcomingPlanTableView.h
//  Pashadelic
//
//  Created by LongPD on 8/26/14.
//
//

#import "PDItemsTableView.h"
#import "PDPlan.h"
@protocol PDUpcomingPlanDelegate <NSObject>

- (void)didSelectPlan:(PDPlan *)plan;

@end

@interface PDUpcomingPlanTableView : PDItemsTableView
@property (weak, nonatomic) id <PDUpcomingPlanDelegate> upcomingPlanDelegate;
@property (assign, nonatomic) BOOL multipleSections;
@end
