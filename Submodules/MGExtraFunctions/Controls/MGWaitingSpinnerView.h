//
//  WaitingSpinnerView.h
//  motd App
//
//  Created by Виталий Гоженко on 18/2/12.
//  Copyright (c) 2012 Bootstrap Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGWaitingSpinnerView : UIView

@property (strong, nonatomic)		UIActivityIndicatorView		*spinner;

- (id)initWithStyle:(UIActivityIndicatorViewStyle) style;

- (void)show;
- (void)hide;

@end
