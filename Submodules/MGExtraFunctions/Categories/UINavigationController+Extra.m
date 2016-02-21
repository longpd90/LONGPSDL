//
//  UINavigationController+Extra.m
//  Vlasne
//
//  Created by Виталий Гоженко on 16/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UINavigationController+Extra.h"

@implementation UINavigationController (Extra)

- (void)pushViewControllerWithName:(NSString *)name animated:(BOOL)animated
{
	id viewController = [[NSClassFromString(name) alloc] initWithNibName:name bundle:nil];
	if (viewController) {
		[self pushViewController:viewController animated:animated];
	}
}

- (id)initWithRootViewControllerName:(NSString *)name
{
	UIViewController *viewController = [[NSClassFromString(name) alloc] initWithNibName:name bundle:nil];
	self = [self initWithRootViewController:viewController];
	if (self) {
		
	}
	return self;
}

- (id)previousViewControllerFor:(UIViewController *)viewController
{
	id previousViewController;
	for (UIViewController *currentViewController in self.viewControllers) {
		if ([currentViewController isEqual:viewController]) {
			return previousViewController;
		}
		previousViewController = currentViewController;
	}
	return nil;
}

- (void)removeViewControllerFromStack:(UIViewController *)viewController
{
	BOOL isInStack = NO;
	for (UIViewController *stackViewController in self.viewControllers) {
		if ([stackViewController isEqual:viewController]) {
			isInStack = YES;
			break;
		}
	}
	
	if (isInStack) {
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.viewControllers];
		[array removeObject:viewController];
		self.viewControllers = array;
	}
}


@end
