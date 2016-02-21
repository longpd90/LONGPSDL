//
//  PDServerUpcomingPlanLoader.h
//  Pashadelic
//
//  Created by LongPD on 8/26/14.
//
//

#import "PDServerExchange.h"

@interface PDServerUpcomingPlanLoader : PDServerExchange

- (void)loadPlansUpcoming:(NSInteger)page;
- (void)loadListNewPlans:(NSInteger)page;
- (void)loadPlansUpcomingOfCurrentUser:(NSInteger)page;
- (void)loadAllPlansOfCurrentUser:(NSInteger)page;

@end
