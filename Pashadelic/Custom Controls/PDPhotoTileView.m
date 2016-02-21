//
//  PDPhotoTileView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 26/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "PDPhotoTileView.h"
#import "PDServerCheckPhotoUpload.h"
#define kPDPhotoUploadCompletedStatus 5

static UIImage *backgroundImage;

@interface PDPhotoTileView ()

- (void)addProcessingOverlay;
- (void)removeProcessingOverlay;

@end

@implementation PDPhotoTileView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
		if (!backgroundImage) {
			backgroundImage = [UIImage imageNamed:@"tile_shadow.png"];
		}
		self.image = backgroundImage;
		self.userInteractionEnabled = YES;
		
		self.contentMode = UIViewContentModeScaleAspectFill;
		self.clipsToBounds = YES;
	}
  return self;
}

- (void)setPhoto:(PDPhoto *)newPhoto
{
  _photo = newPhoto;

	self.hidden = (_photo == nil);
  if (!_photo.identifier) return;
    
  if (!_photo.spotId) {
    [self addProcessingOverlay];
  } else {
      self.overlayView.hidden = YES;

  }
    [self sd_setImageWithURL:self.photo.thumbnailURL
            placeholderImage:backgroundImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {}];
}

- (void)addProcessingOverlay
{
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:self.frame];
        _overlayView.backgroundColor = [UIColor darkGrayColor];
        _overlayView.alpha = 0.65;
        _inprocessLabel = [[PDDynamicFontLabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _inprocessLabel.text = NSLocalizedString(@"in processing...", nil);
        [_inprocessLabel setTextAlignment:NSTextAlignmentCenter];
        _inprocessLabel.textColor = [UIColor whiteColor];
        _inprocessLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:14];
        [_overlayView addSubview:_inprocessLabel];
        [self addSubview:_overlayView];
    }
    _overlayView.hidden = NO;
}

- (void)removeProcessingOverlay
{
  [UIView animateWithDuration:0.3 animations:^{
    [self.overlayView removeFromSuperview];
    self.overlayView = nil;
  }];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.delegate) {
		UIImage *image = [self.photo cachedFullImage];
		if (!image) {
			image = self.image;
		}
		if (!image) {
			image = backgroundImage;
		}
		if (self.delegate && [self.delegate respondsToSelector:@selector(photo:didSelectInView:image:)] && self.photo.spotId) {
            [self.delegate photo:self.photo didSelectInView:self image:image];
        }
    
	} else {
		[self.photo itemWasSelected];
	}
}



@end
