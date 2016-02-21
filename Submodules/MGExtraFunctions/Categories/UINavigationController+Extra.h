//
//  UINavigationController+Extra.h
//  Vlasne
//
//  Created by Виталий Гоженко on 16/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extra)

- (void)pushViewControllerWithName:(NSString *)name animated:(BOOL)animated;
- (id)initWithRootViewControllerName:(NSString *)name;
- (id)previousViewControllerFor:(UIViewController *)viewController;
- (void)removeViewControllerFromStack:(UIViewController *)viewController;


@end
