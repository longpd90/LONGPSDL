//
//  PDStateSelectViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.12.12.
//
//

#import "PDStateSelectViewController.h"

@interface PDStateSelectViewController ()

@end

@implementation PDStateSelectViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = NSLocalizedString(@"Select state", nil);
	
}

- (NSString *)pageName
{
	return @"Edit My State";
}

- (void)fetchData
{
	[kPDAppDelegate showWaitingSpinner];
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerStatesLoader alloc] initWithDelegate:self];
	}
	[self.serverExchange loadStatesForCountryWithID:self.countryID];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ProfileCellIdentifier = @"PDStateSelectCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProfileCellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ProfileCellIdentifier];
	}
	
	NSDictionary *item = [self.filteredItems objectAtIndex:indexPath.row];
	
	if ([item[@"id"] intValue] == self.stateID) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	cell.textLabel.text = item[@"name"];
	
	return cell;
}


@end
