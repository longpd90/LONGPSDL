//
//  PDUpcomingPlanViewController.m
//  Pashadelic
//
//  Created by LongPD on 8/26/14.
//
//

#import "PDUpcomingPlanViewController.h"
#import "PDServerUpcomingPlanLoader.h"
#import "PDPlanInfoViewController.h"

enum PDListPlans {
    PDListPlansNew = 0,
	PDListPlansUpComing,
	PDListPlansMyPlans
};
@interface PDUpcomingPlanViewController ()
@property (assign, nonatomic) NSInteger sourceListPlans;
@end

@implementation PDUpcomingPlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString( @"plans", nil);
    [self setLeftButtonToMainMenu];
    [self initInterface];
    [self fetchData];
    [self initPlansTable];
}

- (NSString *)pageName
{
    return @"Upcomming Plans";
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)fetchData
{
	[super fetchData];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerUpcomingPlanLoader alloc] initWithDelegate:self];
	}
    if (self.currentPage == 1) {
        self.items = [[NSArray alloc] init];
    }
    switch (self.sourceListPlans) {
        case PDListPlansNew:
            self.plansTableView.multipleSections = NO;
            [self.serverExchange loadListNewPlans:self.currentPage];
            break;
        case PDListPlansUpComing:
            self.plansTableView.multipleSections = YES;
            [self.serverExchange loadPlansUpcoming:self.currentPage];
            break;
        case PDListPlansMyPlans:
            self.plansTableView.multipleSections = YES;
            [self.serverExchange loadAllPlansOfCurrentUser:self.currentPage];
            break;
        default:
            break;
    }
	
}

#pragma mark - Private

- (void)initPlansTable
{
    self.plansTableView = [[PDUpcomingPlanTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
    self.plansTableView.tableViewMode = PDItemsTableViewModeList;
	self.plansTableView.itemsTableDelegate = self;
	self.plansTableView.upcomingPlanDelegate = self;
	self.itemsTableView = self.plansTableView;
	[self.tablePlaceholderView addSubview:self.itemsTableView];
}

- (void)initInterface
{
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName: kPDGlobalGrayColor};
    [_changeSortButton setFontAwesomeIconForImage:[FAKFontAwesome sortIconWithSize:14.0]
                                         forState:UIControlStateNormal
                                       attributes:grayColorAttribute];
    [self setTitleForChangeSortButton:NSLocalizedString(@" new", nil)];
    _expandView.frame = CGRectMake(0, -150, 320, 150);
    [self.view addSubview:_expandView];
    _expandView.hidden = YES;
    self.navigationItem.titleView = self.navigationBar;

}
- (void)showExpandView
{
    self.expandView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _expandView.frame = CGRectMake(0, 0, 320, 150);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideExpandView
{
    _changeSortButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _expandView.frame = CGRectMake(0, -150, 320, 150);
    } completion:^(BOOL finished) {
        self.expandView.hidden = YES;
    }];
}

- (void)setTitleForChangeSortButton:(NSString *)title
{
    [_changeSortButton setTitle:title forState:UIControlStateNormal];
    [_changeSortButton setTitle:[_changeSortButton titleForState:UIControlStateNormal] forState:UIControlStateHighlighted];
    [_changeSortButton setTitle:[_changeSortButton titleForState:UIControlStateNormal] forState:UIControlStateSelected];
}

#pragma mark - IBAction

- (IBAction)changeSortButton:(id)sender {
    if (!_changeSortButton.selected) {
        _changeSortButton.selected = YES;
        [self showExpandView];
    } else {
        [self hideExpandView];
    }
}

- (IBAction)showNewPlans:(id)sender {
    self.sourceListPlans = PDListPlansNew;
    [self setTitleForChangeSortButton:NSLocalizedString(@" new", nil)];
    self.theNewButton.selected = YES;
    self.upcomingButton.selected = NO;
    self.myPlanButton.selected = NO;
    [self hideExpandView];
    [self refetchData];
}

- (IBAction)showUpcomingPlans:(id)sender {
    self.sourceListPlans = PDListPlansUpComing;
    [self setTitleForChangeSortButton:NSLocalizedString(@" upcoming", nil)];
    self.theNewButton.selected = NO;
    self.upcomingButton.selected = YES;
    self.myPlanButton.selected = NO;
    [self hideExpandView];
    [self refetchData];
}

- (IBAction)showMyPlans:(id)sender {
    self.sourceListPlans = PDListPlansMyPlans;
    [self setTitleForChangeSortButton:NSLocalizedString(@" my plans", nil)];
    self.theNewButton.selected = NO;
    self.upcomingButton.selected = NO;
    self.myPlanButton.selected = YES;
    [self hideExpandView];
    [self refetchData];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	self.items = [serverExchange loadPlansItemsFromArray:result[@"plans"]];
    self.totalPages = [result intForKey:@"total_pages"];
	[self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj setItemDelegate:self];
	}];
	[self refreshView];
}

- (void)didSelectPlan:(PDPlan *)plan
{
    PDPlanInfoViewController *planInfoViewController = [[PDPlanInfoViewController alloc] initForUniversalDevice];
    planInfoViewController.plan = plan;
    [self.navigationController pushViewController:planInfoViewController animated:YES];
}

- (void)itemsTableWillBeginScroll:(PDItemsTableView *)itemsTableView
{
    [super itemsTableWillBeginScroll:itemsTableView];
    [self hideExpandView];
}

@end
