//
//  PDUploadPhotoView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 28.05.13.
//
//

@implementation PDUploadPhotoView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.clipsToBounds = YES;
		self.alpha = 0.8;
		self.opaque = YES;
		self.layer.cornerRadius = 3;
		self.layer.borderColor = [UIColor lightGrayColor].CGColor;
		self.layer.borderWidth = 0.5;
		self.overlayView = [[UIView alloc] initWithFrame:self.zeroPositionFrame];
		self.overlayView.backgroundColor = kPDGlobalRedColor;
		self.overlayView.alpha = 0.6;
		[self addSubview:self.overlayView];
		[super setHidden:YES];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.progress = self.progress;
}

- (void)reset
{
	int size = 50;
	self.frame = CGRectMake(self.superview.width - size - 10, 20, size, size);
	self.overlayView.frame = self.zeroPositionFrame;
}

- (void)setHidden:(BOOL)hidden
{
	[self.superview bringSubviewToFront:self];
	[UIView animateWithDuration:0.5 animations:^{
		self.alpha = (hidden) ? 0 : 0.65;
	} completion:^(BOOL finished) {
		[super setHidden:hidden];
	}];
}

- (void)setProgress:(double)progress
{
	progress = MIN(1, progress);
	_progress = progress;
		
	[UIView animateWithDuration:0.1 animations:^{
		self.overlayView.frame = CGRectMake(0, self.height * progress, self.width, self.height - self.height * progress);
	}];	
}

@end
