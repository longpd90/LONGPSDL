//
//  PDUsersView.m
//  Pashadelic
//
//  Created by LongPD on 8/18/14.
//
//

#import "PDUsersView.h"
#import "PDPhotoTableCell.h"
#import "PDUserTableViewCell.h"

@implementation PDUsersView

- (void)awakeFromNib
{
	self.backgroundColor = [UIColor clearColor];
	
	self.table = [[UITableView alloc] initWithFrame:self.zeroPositionFrame style:UITableViewStylePlain];
	self.table.delegate = self;
	self.table.dataSource = self;
	self.table.frame = self.zeroPositionFrame;
	
	self.table.backgroundColor = [UIColor clearColor];
	self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	self.table.separatorColor = [UIColor clearColor];
	self.table.showsVerticalScrollIndicator = NO;
	self.table.showsHorizontalScrollIndicator = NO;
	[self addSubview:self.table];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	
    if (self) {
		[self awakeFromNib];
    }
    return self;
}

- (void)setImages:(NSArray *)newImages
{
	_images = newImages;
    [_table reloadData];
}

#pragma mark - Table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 27;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.images.count / 3;
    if (count * 3 != self.images.count) {
        count++;
    }
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier	= @"PDUserTableViewCell";
	
	PDUserTableViewCell *cell = (PDUserTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[PDUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    int count = 3;
    if (indexPath.row == self.images.count / 3)
        count = self.images.count % 3;
    cell.users = [self.images subarrayWithRange:NSMakeRange(indexPath.row * 3, count)];
    return cell;
}


@end
