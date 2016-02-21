//
//  PDSearchView.m
//  Pashadelic
//
//  Created by TungNT2 on 4/23/14.
//
//

#import "PDSearchView.h"
#import "PDSuggestionCell.h"

@implementation PDSearchView

+ (PDSearchView *)view
{
    return (PDSearchView *)[[UIViewController alloc] initWithNibName:@"PDSearchView" bundle:nil].view;
}

- (void)setSearchController:(PDSearchBarController *)searchController
{
    _searchController = searchController;
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
}

- (IBAction)cancel:(id)sender
{
    self.searchController.active = NO;
}

- (void)refreshView
{
    [self.searchTableView reloadData];
}

#pragma mark - Table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.searchTableView.hidden = self.suggestions.count > 0 ? NO : YES;
	return self.suggestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *SuggestionCellIdentifier = @"PDSuggestionCell";
	PDSuggestionCell *cell = (PDSuggestionCell *) [tableView dequeueReusableCellWithIdentifier:SuggestionCellIdentifier];
	if (!cell) {
		cell = [[PDSuggestionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SuggestionCellIdentifier];
	}
    PDPlace *place = (PDPlace *)[self.suggestions objectAtIndex:indexPath.row];
    cell.textLabel.text = place.description;
    cell.textLabel.textColor = [UIColor whiteColor];
    if ([place.description isEqualToString:NSLocalizedString(@"current location", nil)])
        cell.textLabel.textColor = [UIColor redColor];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchController) {
        PDPlace *selectedPlace = (PDPlace *)[self.suggestions objectAtIndex:indexPath.row];
        [self.searchController searchSuggestionDidSelect:selectedPlace];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchController.searchBar.textField resignFirstResponder];
}

@end
