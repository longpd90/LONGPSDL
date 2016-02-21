//
//  PDForegroundWaitingSpinner.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 22/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MGWaitingSpinnerView.h"

@interface MGRotatingWaitingSpinner : MGWaitingSpinnerView

@property (strong, nonatomic) UIView *foreground;

- (void)resetForeground;

@end

