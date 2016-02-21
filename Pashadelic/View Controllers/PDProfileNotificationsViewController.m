//
//  PDProfileNotificationsViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 05.01.13.
//
//

#import "PDProfileNotificationsViewController.h"


@interface PDProfileNotificationsViewController ()
- (PDSwitch *)createSwitch;
@end

@implementation PDProfileNotificationsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_settingsTable.tableFooterView = _finishView;
	self.title = NSLocalizedString(@"Notifications", nil);
	[_finishButton setRedGradientButtonStyle];
	[_finishButton setTitle:NSLocalizedString(@"Finish", nil) forState:UIControlStateNormal];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setSettingsTable:nil];
	[self setFinishView:nil];
    [self setFinishButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[_settingsTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}


#pragma mark - Private

- (PDSwitch *)createSwitch
{
	PDSwitch *switchControl	= [[PDSwitch alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
	[switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
	return switchControl;
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"My Notifications Settings";
}

- (void)refreshView
{
	[_settingsTable reloadData];
}

- (void)fetchData
{
	[kPDAppDelegate showWaitingSpinner];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerNotificationSettings alloc] initWithDelegate:self];
	}
	[self.serverExchange loadNotificationSettings];
}

- (IBAction)finish:(id)sender
{
	[kPDAppDelegate showWaitingSpinner];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerNotificationSettings alloc] initWithDelegate:self];
	}
	[self.serverExchange setNotificationsSettings:notificationSettings];
}

- (void)switchValueChanged:(id)sender
{
	PDSwitch *switchControl = (PDSwitch *)sender;
	notificationSettings[switchControl.indexPath.section][switchControl.indexPath.row] = switchControl.on;
}


#pragma mark - Table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return kNotificationSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ProfileCellIdentifier = @"PDNotificationCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ProfileCellIdentifier];
		cell.accessoryView = [self createSwitch];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:17];
	}
	PDSwitch *switchControl = (PDSwitch *) cell.accessoryView;
	switchControl.on = notificationSettings[indexPath.section][indexPath.row];
	switchControl.indexPath = indexPath;
	
	if (indexPath.row == 0) {
		cell.textLabel.text = NSLocalizedString(@"Push Notification", nil);		
		
	} else if (indexPath.row == 1) {
		cell.textLabel.text = NSLocalizedString(@"Email Notification", nil);
	}
	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == kNotificationSectionFollow) {
		return NSLocalizedString(@"When user follow me", nil);
		
	} else if (section == kNotificationSectionLike) {
		return NSLocalizedString(@"When user like my photo", nil);
		
	} else if (section == kNotificationSectionPin) {
		return NSLocalizedString(@"When user pins my photo", nil);
		
	} else if (section == kNotificationSectionComment) {
		return NSLocalizedString(@"When user comments to my photo", nil);
	}
	
	return nil;
}


#pragma mark - Server exchange delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[kPDAppDelegate hideWaitingSpinner];
	self.loading = NO;
	
	if ([serverExchange isKindOfClass:[PDServerNotificationSettings class]]) {
		if ([serverExchange.functionPath rangeOfString:@"edit_notifications"].location != NSNotFound) {
			notificationSettings[kNotificationSectionFollow][0] = [result [@"notifications"] boolForKey:@"follow_me"];
			notificationSettings[kNotificationSectionFollow][1] = [result [@"email_notifications"] boolForKey:@"follow_me"];
			notificationSettings[kNotificationSectionPin][0] = [result [@"notifications"] boolForKey:@"pins_my_photo"];
			notificationSettings[kNotificationSectionPin][1] = [result [@"email_notifications"] boolForKey:@"pins_my_photo"];
			notificationSettings[kNotificationSectionLike][0] = [result [@"notifications"] boolForKey:@"likes_my_photo"];
			notificationSettings[kNotificationSectionLike][1] = [result [@"email_notifications"] boolForKey:@"likes_my_photo"];
			notificationSettings[kNotificationSectionComment][0] = [result [@"notifications"] boolForKey:@"comments_my_photo"];
			notificationSettings[kNotificationSectionComment][1] = [result [@"email_notifications"] boolForKey:@"comments_my_photo"];
			[self refreshView];
		} else {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	self.loading = NO;	
	[self showErrorMessage:error];
}


@end
