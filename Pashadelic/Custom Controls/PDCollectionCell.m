//
//  PDCollectionCell.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.07.13.
//
//

#import "PDCollectionCell.h"
#import "FontAwesomeKit.h"

@implementation PDCollectionCell

- (void)awakeFromNib
{
	self.backgroundView = [[UIView alloc] init];
	[self.backgroundView clearBackgroundColor];
}

- (void)setCollection:(PDPhotoCollection *)collection
{
	_collection = collection;
	self.thumbnailImageView.image = nil;
	if (collection.thumbnailURL.length > 0) {
        [self.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:collection.thumbnailURL] placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
	}
	
	self.titleLabel.text = collection.title;
	if (collection.photosCount > 1)
        self.subtitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%zd photos", nil), collection.photosCount];
    else
        self.subtitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%zd photo", nil), collection.photosCount];
}

@end
