//
//  UIHorizontalImageCarousel.m

#import "PDPhotosView.h"
#import "PDPhotoTableCell.h"

@implementation PDPhotosView

- (void)awakeFromNib
{
	self.backgroundColor = [UIColor clearColor];
	
	self.table = [[UITableView alloc] initWithFrame:self.zeroPositionFrame style:UITableViewStylePlain];
	self.table.delegate = self;
	self.table.dataSource = self;
	self.table.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
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
	[self.table reloadData];
}

#pragma mark - Table delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.images.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier	= @"UIHorizontalImageCarouselCell";
	
	PDPhotoTableCell *cell = (PDPhotoTableCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[PDPhotoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.transform = CGAffineTransformMakeRotation(M_PI_2);
	}

	cell.photoImageView.image = nil;
	id object = self.images[indexPath.row];
    UIImage *placeHolderImage = [UIImage imageNamed:@"tile_shadow.png"];
	if ([object isKindOfClass:[PDUser class]]) {
        [cell.photoImageView sd_setImageWithURL:[object thumbnailURL] placeholderImage:placeHolderImage];
	} else if ([object isKindOfClass:[PDPhoto class]]) {
		[cell.photoImageView sd_setImageWithURL:[object thumbnailURL] placeholderImage:placeHolderImage];
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(itemDidSelectedAtIndex:sender:)]) {
		[self.delegate itemDidSelectedAtIndex:indexPath.row sender:self];
	}
}

@end
