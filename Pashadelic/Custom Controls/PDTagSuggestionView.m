//
//  PDTagSuggestionView.m
//  Pashadelic
//
//  Created by LongPD on 8/13/13.
//
//

#import "PDTagSuggestionView.h"

@implementation PDTagSuggestionView

- (id)init
{
	self = [UIView loadFromNibNamed:@"PDTagSuggestionView"];
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)reloadData
{
	[self.suggestionsTable reloadData];
	if (self.suggestions.count == 0) {
		[self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[obj setHidden:YES];
		}];
	} else {
		[self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[obj setHidden:NO];
		}];	}
}

#pragma mark - Table delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.suggestions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kPDTagSuggestionCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	static NSString *SuggestionCellIdentifier = @"PDTagSuggestionCell";
	PDTagSuggestionCell *cell = (PDTagSuggestionCell *) [tableView dequeueReusableCellWithIdentifier:SuggestionCellIdentifier];
	if (!cell) {
        cell = [UIView loadFromNibNamed:SuggestionCellIdentifier];
	}
    [cell setcontentForCell:[self.suggestions objectAtIndex:indexPath.row]];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(searchSuggestionDidSelect:)]) {
		[self.delegate searchSuggestionDidSelect:[self.suggestions objectAtIndex:indexPath.row]];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSrollTableView)]) {
        [self.delegate didSrollTableView];
    }
}

@end
