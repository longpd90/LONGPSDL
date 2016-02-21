//
//  PDPopupView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.12.13.
//
//

#import "PDPopupView.h"

@interface PDPopupView ()
@property (assign, nonatomic) PDPopupPosition position;
@property (strong, nonatomic) NSTimer *hideTimer;
@end

@implementation PDPopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.alpha = 0.2;
		self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
		self.layer.cornerRadius = 6;
		self.clipsToBounds = YES;
		int yPadding = 4;
		int imageViewHeight = self.height - yPadding * 2;
		
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(yPadding, 4, imageViewHeight, imageViewHeight)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		[self addSubview:self.imageView];
		
		self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.rightXPoint + yPadding, yPadding, self.width - self.imageView.rightXPoint - yPadding * 3, imageViewHeight)];
		self.textLabel.textColor = [UIColor whiteColor];
		self.textLabel.numberOfLines = 0;
		self.textLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:17];
		[self addSubview:self.textLabel];
		
		UITapGestureRecognizer *hideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopup)];
		[self addGestureRecognizer:hideGesture];
		
    }
    return self;
}

+ (PDPopupView *)showPopupWithImage:(UIImage *)image text:(NSString *)text position:(PDPopupPosition)position
{
	UIWindow *window = kPDAppDelegate.window;
	int padding = 10, newYPosition = 0;
	
	PDPopupView *popupView = [[PDPopupView alloc] initWithFrame:CGRectMake(padding, 0, window.width - padding * 2, 80)];
	popupView.imageView.image = image;
	popupView.textLabel.text = text;
	popupView.position = position;
	popupView.hidden = YES;
	[window addSubview:popupView];
	
	switch (position) {
		case PDPopupPositionBottom:
			popupView.y = window.height;
			newYPosition = window.height - popupView.height - padding;
			break;
			
		case PDPopupPositionTop:
			popupView.y = - popupView.height;
			newYPosition = padding;

			break;
	}
	


	popupView.hidden = NO;
	[UIView animateWithDuration:0.4 animations:^{
		popupView.alpha = 1;
		popupView.y = newYPosition;
	} completion:^(BOOL finished) {
		popupView.hideTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:popupView selector:@selector(hidePopup) userInfo:nil repeats:NO];
	}];

	return popupView;
}

- (void)hidePopup
{
	UIWindow *window = kPDAppDelegate.window;
	[self.hideTimer invalidate];
	int newYPosition = 0;
	switch (self.position) {
		case PDPopupPositionBottom:
			newYPosition = window.height;
			break;
			
		case PDPopupPositionTop:
			newYPosition = -self.height;
			break;
	}
	
	
	[UIView animateWithDuration:0.4 animations:^{
		self.alpha = 0.2;
		self.y = newYPosition;
	} completion:^(BOOL finished) {
		[self removeFromSuperview];
	}];
}

@end
