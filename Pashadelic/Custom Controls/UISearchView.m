//
//  UISearchView.m
//  Pashadelic
//
//  Created by TungNT2 on 2/25/14.
//
//

#import "UISearchView.h"
#import "PDTableViewController.h"

@implementation UISearchView
@synthesize backgroundSearchView, delegate;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize
{
	self.clipsToBounds = NO;
	self.layer.shadowOffset = CGSizeMake(1, 1);
	self.layer.shadowOpacity = 0.25;
	self.layer.shadowRadius = 1;
	self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
}

- (void)showSearchInViewController:(UIViewController *)viewController
{
    [self.firstViewController performSelector:@selector(trackEvent:)
								   withObject:@"Explore search"];
    
	UIWindow *window = viewController.view.window;
	if ([self.superview isEqual:window]) return;
	
	backgroundSearchView = [[UIView alloc] initWithFrame:window.frame];
	backgroundSearchView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    backgroundSearchView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(cancel:)];
    tapGestureRecognizer.delegate = self;
    [backgroundSearchView addGestureRecognizer:tapGestureRecognizer];
	[window addSubview:backgroundSearchView];
	
	self.y = backgroundSearchView.y - self.height;
	[backgroundSearchView addSubview:self];
    
	[UIView animateWithDuration:0.25 animations:^{
		self.y = backgroundSearchView.y;
	}];
}

- (IBAction)search:(id)sender
{
    [self hideSearch];
}

- (IBAction)cancel:(id)sender
{
	if ([delegate respondsToSelector:@selector(searchViewDidCancel:)]) {
		[delegate searchViewDidCancel:self];
	}
	[self hideSearch];
}

- (void)hideSearch
{
	[UIView animateWithDuration:0.25 animations:^{
		self.frame = CGRectWithY(self.frame, backgroundSearchView.y - self.height);
	} completion:^(BOOL finished) {
		[backgroundSearchView removeFromSuperview];
		[self removeFromSuperview];
		backgroundSearchView = nil;
	}];
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint(self.contentView.frame, [touch locationInView:self])) {
        return NO;
    } else
        return YES;
}

@end
