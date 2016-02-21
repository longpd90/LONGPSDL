//
//  PDNavigationController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 9/10/12.
//
//

#import "PDNavigationController.h"
#import "MWPhotoBrowser.h"

@interface PDNavigationController ()

@end

@implementation PDNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
	self = [super initWithNavigationBarClass:[PDNavigationBar class] toolbarClass:nil];
	if (self) {
		[self setViewControllers:@[rootViewController]];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
	}
}

-(BOOL)shouldAutorotate
{
	if ([self.topViewController isKindOfClass:[MWPhotoBrowser class]]) {
		return YES;
	} else {
		return NO;
	}
}

- (NSUInteger)supportedInterfaceOrientations
{
	if ([self.topViewController isKindOfClass:[MWPhotoBrowser class]]) {
		return UIInterfaceOrientationMaskAll;
	} else {
		return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
	}
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}

@end
