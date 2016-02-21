//
//  PDServerUpcomingPlanLoader.m
//  Pashadelic
//
//  Created by LongPD on 8/26/14.
//
//

#import "PDServerUpcomingPlanLoader.h"

@implementation PDServerUpcomingPlanLoader

- (void)loadPlansUpcoming:(NSInteger)page
{
    self.functionPath = @"plans/upcoming.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?per=15&page=%zd",page]];
}

- (void)loadListNewPlans:(NSInteger)page
{
    self.functionPath = @"plans/upcoming.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?per=15&sort=new&page=%zd", page]];
}

- (void)loadPlansUpcomingOfCurrentUser:(NSInteger)page
{
    self.functionPath = @"plans/upcoming.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?per=15&my_plan=true&page=%zd", page]];
}

- (void)loadAllPlansOfCurrentUser:(NSInteger)page
{
    self.functionPath = @"plans/upcoming.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?per=15&my_plan=all&page=%zd", page]];
}

@end
