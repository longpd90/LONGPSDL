//
//  PDSplashViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDViewController.h"

@interface PDSplashViewController : PDViewController

- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;
- (IBAction)learnMoreButtonClicked:(id)sender;
- (void)showChildViewControllerAnimated:(UIViewController *)viewController;
- (void)hideChildViewControllerAnimated;

@end
