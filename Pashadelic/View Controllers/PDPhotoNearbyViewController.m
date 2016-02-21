//
//  PDSpotNearbyViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDPhotoNearbyViewController.h"
#import "PDServerPhotoNearbyLoader.h"

@interface PDPhotoNearbyViewController()
@end

@implementation PDPhotoNearbyViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	self.navigationItem.rightBarButtonItem = nil;
	self.title = NSLocalizedString(@"Photo nearby", nil);
	[_captionButton setTitle:NSLocalizedString(@"Photo-spots Near by", nil) forState:UIControlStateNormal];
	if (self.photo) {
		self.photo = self.photo;
	}
	[self applyDefaultStyleToButtons:@[self.sortByDateButton, self.sortByRankingButton]];
}

- (void)setPhoto:(PDPhoto *)photo
{
	_photo = photo;
	
	if (self.isViewLoaded) {
		[self.sourcePhotoImageView sd_setImageWithURL:self.photo.thumbnailURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
			self.sourcePhotoImageView.image = image;
			[self.captionButton sizeToFit];
			self.captionButton.height = self.sourcePhotoImageView.height;
			self.sourcePhotoImageView.x = self.captionButton.rightXPoint + 4;

		}];
		[self refetchData];
	}
}

- (NSString *)pageName
{
	return @"Photo Nearby";
}

- (void)fetchData
{
	if (!self.serverExchange) {
		self.serverExchange = [[PDServerPhotoNearbyLoader alloc] initWithDelegate:self];
	}
	[self.serverExchange loadNearbyForPhoto:_photo page:self.currentPage sorting:self.sorting range:kPDNearbyRange];
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];

	NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
	[array removeObject:self.photo];
	self.items = array;
	self.itemsTotalCount = [result intForKey:@"total_count"] - 1;
	[self refreshView];
}

@end
