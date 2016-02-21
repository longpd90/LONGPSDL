//
//  PDPOIPhotoTableCell.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.06.13.
//
//

#import "PDPhotoTableCell.h"

@implementation PDPhotoTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.backgroundView = [[UIView alloc] initWithFrame:self.zeroPositionFrame];
		self.backgroundView.autoresizingMask = kFullAutoresizingMask;
		self.backgroundView.backgroundColor = [UIColor clearColor];
		self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
		self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
		self.photoImageView.autoresizingMask = kFullAutoresizingMask;
		[self addSubview:self.photoImageView];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.photoImageView.frame = CGRectMake(0, 0, self.width, self.width);
	self.backgroundView.frame = self.zeroPositionFrame;
}

@end
