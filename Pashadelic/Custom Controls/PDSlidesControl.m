//
//  PDSlidesControl.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 03.02.13.
//
//

#import "PDSlidesControl.h"

@implementation PDSlidesControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor lightGrayColor];
		
		self.currentImage = [[UIImageView alloc] initWithFrame:CGRectMakeWithSize(0, 0, frame.size)];
		[self addSubview:_currentImage];
		self.currentImage.clipsToBounds = YES;
		self.currentImage.contentMode = UIViewContentModeScaleAspectFill;
		
		self.nextImage = [[UIImageView alloc] initWithFrame:CGRectMakeWithSize(0, 0, frame.size)];
		self.nextImage.clipsToBounds = YES;
		_nextImage.hidden = YES;
		self.nextImage.contentMode = UIViewContentModeScaleAspectFill;
		[self addSubview:_nextImage];
		
		self.noPhotosLabel = [[UILabel alloc] initWithFrame:CGRectMakeWithSize(0, 0, frame.size)];
		[_noPhotosLabel clearBackgroundColor];
		_noPhotosLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:19];
		_noPhotosLabel.textAlignment = NSTextAlignmentCenter;
		_noPhotosLabel.textColor = [UIColor grayColor];
		_noPhotosLabel.shadowColor = [UIColor whiteColor];
		_noPhotosLabel.shadowOffset = CGSizeMake(0, 1);
		_noPhotosLabel.text = NSLocalizedString(@"No photo is available", nil);
		[self.currentImage addSubview:_noPhotosLabel];
		
		int buttonWidth = 40;
        self.leftButton = [[UIButton alloc] initWithFrame:
						   CGRectMake(0, 0, buttonWidth, frame.size.height)];
		[_leftButton addTarget:self action:@selector(showPreviousSlide) forControlEvents:UIControlEventTouchUpInside];
		[_leftButton clearBackgroundColor];
		[_leftButton setTitle:@"<" forState:UIControlStateNormal];
		[_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_leftButton.titleLabel.font = [UIFont fontWithName:PDGlobalBoldFontName size:20];
		[self addSubview:_leftButton];
		
		self.rightButton = [[UIButton alloc] initWithFrame:
							CGRectMake(frame.size.width - buttonWidth, 0, buttonWidth, frame.size.height)];
		[_rightButton addTarget:self action:@selector(showNextSlide) forControlEvents:UIControlEventTouchUpInside];
		[_rightButton clearBackgroundColor];
		[_rightButton setTitle:@">" forState:UIControlStateNormal];
		[_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		_rightButton.titleLabel.font = [UIFont fontWithName:PDGlobalBoldFontName size:20];
		[self addSubview:_rightButton];
		
		[self resetView];
    }
    return self;
}

- (void)setItems:(NSArray *)items
{
	_items = items;
	[self resetView];
}

- (void)resetView
{
	_currentIndex = 0;
	_noPhotosLabel.hidden = YES;
	
	if (_items.count == 0) {
		_leftButton.hidden = YES;
		_rightButton.hidden = YES;
		_noPhotosLabel.hidden = NO;
		_currentImage.image = nil;
		_nextImage.image = nil;
		
	} else if (_items.count == 1) {
		_leftButton.hidden = YES;
		_rightButton.hidden = YES;
		[self loadCurrentImage];
		
	} else {
		_leftButton.hidden = NO;
		_rightButton.hidden = NO;
		[self loadCurrentImage];
	}
}

- (void)loadCurrentImage
{
	if (_currentIndex < 0 || _currentIndex >= _items.count) return;
		
	NSString *item = [_items objectAtIndex:_currentIndex];
	[self.currentImage showActivityWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
	__weak UIImageView *weakImageView = self.currentImage;
	[self.currentImage sd_setImageWithURL:[NSURL URLWithString:item] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		[weakImageView hideActivity];
	}];
}

- (void)showNextSlide
{
	if (isAnimating) return;
	
	_currentIndex = (_currentIndex < _items.count - 1) ? _currentIndex + 1 : 0;
	NSString *item = [_items objectAtIndex:_currentIndex];
	__weak UIImageView *weakImageView = self.nextImage;
	[self.nextImage sd_setImageWithURL:[NSURL URLWithString:item] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		[weakImageView hideActivity];
		weakImageView.image = image;
	}];

	_nextImage.x = self.width;
	_nextImage.hidden = NO;
	isAnimating = YES;
	
	[UIView animateWithDuration:0.3 animations:^{
		_currentImage.x = -self.width;
		_nextImage.x = 0;
		
	} completion:^(BOOL finished) {
		isAnimating = NO;
		UIImageView *previousImage = self.currentImage;
		self.currentImage = self.nextImage;
		self.nextImage = previousImage;
	}];
}

- (void)showPreviousSlide
{
	if (isAnimating) return;
	
	_currentIndex = (_currentIndex == 0) ? _items.count - 1 : _currentIndex - 1;
	NSString *item = [_items objectAtIndex:_currentIndex];
	[self.nextImage sd_setImageWithURL:[NSURL URLWithString:item] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
	}];
	_nextImage.x = -self.width;
	_nextImage.hidden = NO;
	isAnimating = YES;
	
	[UIView animateWithDuration:0.3 animations:^{
		_currentImage.x = self.width;
		_nextImage.x = 0;
		
	} completion:^(BOOL finished) {
		isAnimating = NO;
		UIImageView *previousImage = self.currentImage;
		self.currentImage = self.nextImage;
		self.nextImage = previousImage;
	}];
}

@end
