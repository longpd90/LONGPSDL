//
//  PDHelpView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 27.05.13.
//
//

#define kHelpViewTag 61345

@implementation PDHelpView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.foregroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width - 40, self.width - 40)];
		self.foregroundImageView.center = self.centerOfView;
		self.foregroundImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.foregroundImageView.image = [UIImage imageNamed:@"help_foreground.png"];
		self.foregroundImageView.userInteractionEnabled = YES;
		[self addSubview:self.foregroundImageView];
		
		self.helpImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.foregroundImageView.width - 150) / 2, 25, 150, 60)];
		[self.foregroundImageView addSubview:self.helpImageView];
		
		self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake((self.foregroundImageView.width - 125) / 2, 210, 125, 50)];
		[self.nextButton setTitle:NSLocalizedString(@"Got It!", nil) forState:UIControlStateNormal];
		[self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		self.nextButton.titleLabel.font = [UIFont fontWithName:PDGlobalBoldFontName size:17];
		[self.nextButton addTarget:self action:@selector(showNextHelpItem) forControlEvents:UIControlEventTouchUpInside];
		[self.nextButton setBackgroundImage:[UIImage imageNamed:@"help_next_button.png"] forState:UIControlStateNormal];
		[self.foregroundImageView addSubview:self.nextButton];
		
		self.helpLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.foregroundImageView.width - 240) / 2, 85, 240, 110)];
		[self.helpLabel clearBackgroundColor];
		self.helpLabel.numberOfLines = 5;
		self.helpLabel.textColor = [UIColor whiteColor];
		self.helpLabel.shadowColor = [UIColor blackColor];
		self.helpLabel.shadowOffset = CGSizeMake(0, -1);
		self.helpLabel.font = [UIFont systemFontOfSize:15];
		self.helpLabel.textAlignment = NSTextAlignmentCenter;
		self.helpLabel.lineBreakMode = NSLineBreakByWordWrapping;
		[self.foregroundImageView addSubview:self.helpLabel];
		
		self.tag = kHelpViewTag;
		self.hidden = YES;
		self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
		[kPDAppDelegate.window addSubview:self];
	}
	
	return self;
}

- (void)showHelp
{
	if (self.items.count == 0) return;
	
	currentItemIndex = 0;
	[self showHelpForIndex:currentItemIndex];
	[kPDAppDelegate.window bringSubviewToFront:self];
	
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	bounceAnimation.values = @[@0.1, @0.6, @1.15, @1.0];
	bounceAnimation.duration = 0.35;
	bounceAnimation.removedOnCompletion = YES;
	
	[self.foregroundImageView.layer addAnimation:bounceAnimation forKey:@"bounceShow"];
	self.alpha = 0;
	self.hidden = NO;
	[UIView animateWithDuration:bounceAnimation.duration animations:^{
		self.alpha = 1;
	}];
}

- (void)hideHelp
{
	CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
	bounceAnimation.values = @[@1.0, @1.15, @0.6, @0.1];
	bounceAnimation.duration = 0.35;
	bounceAnimation.removedOnCompletion = NO;
	bounceAnimation.delegate = self;
	bounceAnimation.fillMode = kCAFillModeForwards;
	
	[self.foregroundImageView.layer addAnimation:bounceAnimation forKey:@"bounceHide"];
	
	[UIView animateWithDuration:bounceAnimation.duration animations:^{
		self.alpha = 0;
	} completion:^(BOOL finished) {
		self.hidden = YES;
	}];
}

- (void)showNextHelpItem
{
	currentItemIndex++;
	if (currentItemIndex >= self.items.count) {
		[self hideHelp];
	} else {
		[UIView transitionWithView:self.foregroundImageView duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
			[self showHelpForIndex:currentItemIndex];
		} completion:^(BOOL finished) {
			
		}];
	}
}

- (void)showHelpForIndex:(NSUInteger)index
{
	if (currentItemIndex >= self.items.count) return;
	
	self.helpImageView.image = [UIImage imageNamed:self.items[currentItemIndex][@"Image"]];
	self.helpLabel.text = self.items[currentItemIndex][@"Text"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	self.hidden = YES;
	[self.foregroundImageView.layer removeAllAnimations];
}

@end
