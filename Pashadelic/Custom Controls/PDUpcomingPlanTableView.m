//
//  PDUpcomingPlanTableView.m
//  Pashadelic
//
//  Created by LongPD on 8/26/14.
//
//

#import "PDUpcomingPlanTableView.h"
#import "PDUpcomingPlanTableViewCell.h"
#import "NSString+Date.h"

@interface PDUpcomingPlanTableView ()

@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;

@end

@implementation PDUpcomingPlanTableView

- (void)initTable
{
    [super initTable];
    self.tableViewMode = PDItemsTableViewModeList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.multipleSections) {
        return [self.sections count];
    } else return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.multipleSections) {
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
        return [NSString stringSuffixDateWithDate: dateRepresentingThisDay dateFormatter:@"MMM d., yyy"];
    } else return @"";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.multipleSections) {
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
        NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        return [eventsOnThisDay count];
    } else
        return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.multipleSections) {
        return 30;
    } else return 0;
	
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor colorWithRed:249.0/255 green:249.0/255 blue:249.0/255 alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PlansTableViewCell = @"PDUpcomingPlanTableViewCell";
	PDUpcomingPlanTableViewCell *cell = (PDUpcomingPlanTableViewCell *) [tableView dequeueReusableCellWithIdentifier:PlansTableViewCell];
	if (!cell) {
		cell = [UIView loadFromNibNamed:PlansTableViewCell];
	}
    if (self.multipleSections) {
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSArray *plansOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        cell.plan = (PDPlan *)plansOnThisDay[indexPath.row];
    } else {
        cell.plan = (PDPlan *)self.items[indexPath.row];
    }
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  99;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.multipleSections) {
        NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
        NSArray *plansOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        [self.upcomingPlanDelegate didSelectPlan:(PDPlan *)plansOnThisDay[indexPath.row]];
    } else
        [self.upcomingPlanDelegate didSelectPlan:(PDPlan *)self.items[indexPath.row]];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadData
{
    self.sections = [NSMutableDictionary dictionary];
    for (PDPlan *plan in self.items) {
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:[self localTimeFromUTC:plan.time]];
        NSMutableArray *planOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (planOnThisDay == nil) {
            planOnThisDay = [NSMutableArray array];
            [self.sections setObject:planOnThisDay forKey:dateRepresentingThisDay];
        }
        
        [planOnThisDay addObject:plan];
    }
    
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    [super reloadData];
}

#pragma mark - Date Calculations

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}

- (NSDate *)localTimeFromUTC:(NSString *)utcTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [dateFormatter dateFromString:utcTimeString];
}

@end
