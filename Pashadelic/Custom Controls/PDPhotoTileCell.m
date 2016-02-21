//
//  PDPhotoTileCell.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 26/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoTileCell.h"

@implementation PDPhotoTileCell
@synthesize photos, photoViews;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
  }
  return self;
}

- (void)initCell
{
    [self clearBackgroundColor];
    [self.contentView clearBackgroundColor];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	int x = 0;
	int width = kPDPhotoTileViewWidth;
	int height = kPDPhotoTileViewHeight;
	NSMutableArray *views = [NSMutableArray array];
	
	for (int i = 0; i < 3; i++) {
		PDPhotoTileView *photoView = [[PDPhotoTileView alloc] initWithFrame:CGRectMake(x, 0, width, height)];
		photoView.delegate = _photoViewDelegate;
		[views addObject:photoView];
		[self addSubview:photoView];
		x += width + 1;
	}
	photoViews = views;
}

- (void)setPhotos:(NSArray *)newPhotos
{
	photos = newPhotos;
	for (int i = 0; i < 3; i++) {
		PDPhotoTileView *photoView = [photoViews objectAtIndex:i];
		if (i < photos.count) {
			photoView.delegate = _photoViewDelegate;
			photoView.photo = [photos objectAtIndex:i];
		} else {
			photoView.photo = nil;
		}
	}
}

@end
