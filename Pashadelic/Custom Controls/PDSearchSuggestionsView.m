//
//  PDSearchSuggestionsView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 29.03.13.
//
//

#import "PDSearchSuggestionsView.h"
#import "PDSuggestionCell.h"

@implementation PDSearchSuggestionsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.layer.shadowRadius = 2;
		self.layer.shadowOpacity = 0.25;
		self.layer.shadowOffset = CGSizeZero;
		self.clipsToBounds = NO;
        self.suggestionsTable = [[UITableView alloc] initWithFrame:CGRectMakeWithSize(0, 0, frame.size)
															 style:UITableViewStylePlain];
		self.suggestionsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.suggestionsTable.dataSource = self;
		self.suggestionsTable.delegate = self;
		self.suggestionsTable.separatorColor = [UIColor colorWithWhite:0.82 alpha:1];
		self.suggestionsTable.layer.borderWidth = 1;
		self.suggestionsTable.layer.borderColor = [UIColor colorWithWhite:0.82 alpha:1].CGColor;
		[self addSubview:self.suggestionsTable];
		
    }
    return self;
}

- (void)reloadData
{
	[self.suggestionsTable reloadData];
	self.height = MIN(self.suggestions.count * kPDSuggestionCellHeight, 4 * kPDSuggestionCellHeight);
	[self setNeedsLayout];
	if (self.suggestions.count == 0) {
		[self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[obj setHidden:YES];
		}];
	} else {
		[self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[obj setHidden:NO];
		}];
    }
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
	return kPDSuggestionCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *SuggestionCellIdentifier = @"PDSuggestionCell";
	PDSuggestionCell *cell = (PDSuggestionCell *) [tableView dequeueReusableCellWithIdentifier:SuggestionCellIdentifier];
	if (!cell) {
		cell = [[PDSuggestionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SuggestionCellIdentifier];
	}
	
	cell.textLabel.text = [self.suggestions objectAtIndex:indexPath.row];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (self.delegate) {
		[self.delegate searchSuggestionDidSelect:[self.suggestions objectAtIndex:indexPath.row]];
	}
}

@end
