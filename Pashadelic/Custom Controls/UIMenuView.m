//
//  UIMenuView.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIMenuView.h"
#import "PDTableViewController.h"

@implementation UIMenuView
@synthesize backgroundMenuView, delegate, needRefetchData, needRefreshSuperview, parentViewController;

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
	needRefetchData = NO;
	_needFetchData = NO;
	needRefreshSuperview = YES;
	PDGradientButton *helpButton = [[PDGradientButton alloc] initWithFrame:CGRectMake(20, 0, 70, 30)];
	[helpButton applyRedStyleToButton];
	[helpButton setTitle:NSLocalizedString(@"? help", nil) forState:UIControlStateNormal];
	helpButton.titleLabel.font = [UIFont fontWithName:PDGlobalBoldFontName size:13];
	[helpButton addTarget:self action:@selector(showHelp:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:helpButton];
}

- (void)showMenuInViewController:(UIViewController *)viewController
{
	[self.firstViewController performSelector:@selector(trackEvent:)
								   withObject:@"Show menu"];

	UIWindow *window = viewController.view.window;
	if ([self.superview isEqual:window]) return;
	parentViewController = (PDTableViewController *) viewController;
	
	backgroundMenuView = [[UIView alloc] initWithFrame:window.frame];
	backgroundMenuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];		
	backgroundMenuView.userInteractionEnabled = YES;
	[window addSubview:backgroundMenuView];
	
	self.y = backgroundMenuView.height;
	[backgroundMenuView addSubview:self];
		
	[UIView animateWithDuration:0.25 animations:^{
		self.y = backgroundMenuView.height - self.height;
	}];
}

- (void)finish:(id)sender
{	
	if ([delegate respondsToSelector:@selector(menuViewDidFinish:)]) {
		[delegate menuViewDidFinish:self];
	}
	[self hideMenu];
}

- (void)cancel:(id)sender
{
	if ([delegate respondsToSelector:@selector(menuViewDidCancel:)]) {
		[delegate menuViewDidCancel:self];
	}
	[self hideMenu];
}

- (void)showHelp:(id)sender
{
	[self cancel:nil];
	if ([self.delegate respondsToSelector:@selector(showHelp)]) {
		[self.delegate showHelp];
	}
}

- (void)hideMenu
{
	[UIView animateWithDuration:0.25 animations:^{
		self.frame = CGRectWithY(self.frame, backgroundMenuView.height);
	} completion:^(BOOL finished) {		
		[backgroundMenuView removeFromSuperview];
		[self removeFromSuperview];
		backgroundMenuView = nil;
	}];
}

@end
