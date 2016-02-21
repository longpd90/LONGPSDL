//
//  PDReviewCell.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDUserCell.h"

@implementation PDUserCell 
@synthesize user;
@synthesize userAvatarImageView;
@synthesize username;
@synthesize followButton;

- (void)awakeFromNib
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
	for (int i = 1; i <= 4; i++) {
		[array addObject:[self viewWithTag:i]];
	}
	self.userImages = array;
		
	self.userAvatarImageView.layer.cornerRadius = 4;
	self.userAvatarImageView.clipsToBounds = YES;
	[self.userAvatarImageView rasterizeLayer];
}

- (void)setUser:(PDUser *)newUser
{
	if (![newUser isKindOfClass:[PDUser class]]) return;
	user = newUser;
	userAvatarImageView.image = nil;
	for (UIImageView *userImage in _userImages) {
		userImage.image = nil;
	}
	
	if (user.fullImageURL.absoluteString.length == 0) {
		[self.userAvatarImageView sd_setImageWithURL:user.thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			self.userAvatarImageView.image = image;
		}];
	} else {
		[self.userAvatarImageView sd_setImageWithURL:user.fullImageURL];
	}
	
	[self loadUserPhotos];
	[self refreshCell];
}

- (void)loadUserPhotos
{
	for (int i = 0; i < self.userImages.count; i++) {
		UIImageView *photoImageView = self.userImages[i];
		if (i < self.user.userPhotoThumbnails.count) {
			[photoImageView sd_setImageWithURL:[NSURL URLWithString:self.user.userPhotoThumbnails[i]] placeholderImage:[UIImage imageNamed:@"tile_shadow.png"]];
		} else {
			photoImageView.image = nil;
		}
	}
}

- (void)refreshCell
{
	username.text = user.name;
	_locationLabel.text = user.location;
	followButton.item = user;
}


@end
