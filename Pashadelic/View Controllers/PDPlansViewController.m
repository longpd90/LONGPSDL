//
//  PDPlansViewController.m
//  Pashadelic
//
//  Created by LongPD on 11/7/13.
//
//

#import "PDPlansViewController.h"
#import "PDServerPlansLoader.h"
#import "PDPlanDetailViewController.h"

@interface PDPlansViewController ()

@end

@implementation PDPlansViewController
@synthesize tablePlaceholderView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photosTableView.scrollsToTop = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPlanDetail:) name:kPDShowPlanDetail object:nil];
	self.title = NSLocalizedString(@"upcoming plans", nil);
    self.creatPlanLabel.text = NSLocalizedString(@"Create your own plan on our website!", nil);
    self.planByOtherLabel.text = NSLocalizedString(@"Plans created by other users:", nil);
    [self initPlansTable];
    [self refetchData];
	[self setLeftButtonToMainMenu];
	[self.calendarImageView setFontAwesomeIconForImage:[FAKFontAwesome calendarIconWithSize:80] withAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}


- (void)viewDidAppear:(BOOL)animated
{
    self.customNavigationBar.titleButton.hidden = YES;
    [self refreshView];
}

- (NSString *)pageName
{
  return @"Upcomming Plans";
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

- (void)initPlansTable
{
    self.plansTableView = [[PDPlansTableView alloc] initWithFrame:self.tablePlaceholderView.zeroPositionFrame];
	self.plansTableView.itemsTableDelegate = self;
	self.plansTableView.photoViewDelegate = self;
	self.itemsTableView = self.plansTableView;
	[self.tablePlaceholderView addSubview:self.itemsTableView];
}

- (void)showPlanDetail:(NSNotification *)notification
{
    if (!self.userHavePlans) return;
    PDPlan *planEntity = (PDPlan *)[notification object];
    PDPlanDetailViewController *detailViewController = [[PDPlanDetailViewController alloc]initWithNibName:@"PDPlanDetailViewController" bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController setPlan:planEntity];
}

- (void)fetchData
{
	[super fetchData];
    self.loading = YES;
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerPlansLoader alloc] initWithDelegate:self];
	}
	[self.serverExchange loadPlansUpcoming:self.currentPage];
}

- (void)refreshView
{
	[super refreshView];
    if (self.isUserHavePlans) {
        [self hideToolbarAnimated:NO];
        self.customNavigationBar.scrollView = self.itemsTableView;
    } else {
        [self showToolbarAnimated:NO];
        self.customNavigationBar.scrollView = nil;
    }
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
    self.userHavePlans = ![result boolForKey:@"no_plan"];
    self.plansTableView.noPlan = !self.userHavePlans;
	self.items = [serverExchange loadPlansItemsFromArray:result[@"jobtypeL"]];
	[self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj setItemDelegate:self];
	}];
	[self refreshView];
}

@end
