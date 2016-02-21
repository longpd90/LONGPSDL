//
//  PDCategorySelectView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 3/10/12.
//
//

#import "PDCategorySelectView.h"

@implementation PDCategorySelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.rowHeight = 35;
		self.layer.cornerRadius = 10;
		self.layer.borderColor = [UIColor grayColor].CGColor;
		self.layer.borderWidth = 1;
        self.delegate = self;
		self.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfSections
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CategoryCellIdentifier = @"CategoryCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CategoryCellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CategoryCellIdentifier];
	}
	
	cell.textLabel.text = [_categories objectAtIndex:indexPath.row];
	
	if ([cell.textLabel.text isEqualToString:_selectedCategory]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	_selectedCategory = [_categories objectAtIndex:indexPath.row];
	[self reloadData];
	if (_categoryDelegate) {
		[_categoryDelegate categoryDidSelect:_selectedCategory];
	}
}

@end
