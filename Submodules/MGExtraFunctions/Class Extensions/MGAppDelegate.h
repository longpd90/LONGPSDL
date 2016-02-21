//
//  MGAppDelegate.h
//  Order&Pay
//
//  Created by Виталий Гоженко on 27/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRotatingWaitingSpinner.h"

@interface MGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) int internetActivitiesCount;
@property (strong, nonatomic) MGRotatingWaitingSpinner *waitingSpinnerView;
@property (copy, nonatomic) NSString *cachePath;
@property (copy, nonatomic) NSString *libraryPath;
@property (copy, nonatomic) NSString *documentsPath;

- (void)initialize;
- (void)hideWaitingSpinner;
- (void)showWaitingSpinner;

@end
