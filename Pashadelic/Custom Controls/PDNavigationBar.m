//
//  PDNavigationBar.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 29.09.13.
//
//

#import "PDNavigationBar.h"
#import "PDNavigationController.h"
#import "PDTableViewController.h"
#define kNearZero 0.000001f

@interface PDNavigationBar()
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (assign, nonatomic) CGFloat lastContentOffsetY;
@property (strong, nonatomic) UIButton *scrollToTopButton;
@property (assign, nonatomic) BOOL isLinkToTopShowed;

- (void)initialize;
- (void)initScrollToTopButton;
@end

@implementation PDNavigationBar 

@synthesize scrollView = _scrollView,
            scrollState = _scrollState,
            panGesture = _panGesture,
            lastContentOffsetY = _lastContentOffsetY;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
        [self setup];
        self.backgroundColor = [UIColor blueColor];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
        [self setup];
    }
    return self;
}

- (void)initialize
{
	[self setShadowImage:[[UIImage alloc] init]];
	int xPadding = 45, yPadding = self.height - 50;
    _isLinkToTopShowed = NO;
	_scrollToTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
	self.titleLabel = [[PDDynamicFontLabel alloc] initWithFrame:CGRectMake(xPadding, yPadding, self.width - xPadding * 2, self.height - yPadding)];
    [self setBackgroundColor:[UIColor whiteColor]];
	[self.titleLabel clearBackgroundColor];
	self.titleLabel.textAlignment = NSTextAlignmentCenter;
	self.titleLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
	self.titleLabel.font = [UIFont fontWithName:PDGlobalLightFontName size:24];
    self.titleLabel.defaultSize = 24;
	self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	[self addSubview:self.titleLabel];
	
	self.titleButton = [[UIButton alloc] initWithFrame:self.titleLabel.frame];
	self.titleButton.alpha = 0.6;
	self.titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 3, 0);
	self.titleButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
	[self.titleButton setImage:[UIImage imageNamed:@"btn-arrow-down.png"] forState:UIControlStateSelected];
	[self.titleButton setImage:[UIImage imageNamed:@"btn-arrow-up.png"] forState:UIControlStateNormal];
	self.titleButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
	[self.titleButton addTarget:self action:@selector(titleButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:self.titleButton];
    [self setTranslucent:NO];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	int xPadding = 45, yPadding = self.height - 50;
	
	self.titleLabel.frame = CGRectMake(xPadding, yPadding, self.width - xPadding * 2, self.height - yPadding);
	self.titleButton.frame = self.titleLabel.frame;
}

- (void)setCustomBarStyle:(PDNavigationBarStyle)customBarStyle
{
	_customBarStyle = customBarStyle;
	
	if (customBarStyle == PDNavigationBarStyleBlack ) {
        if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
            [self setBarTintColor:[UIColor colorWithRed:64/255.0 green:63/255.0 blue:63/255.0 alpha:1]];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        } else {
            [self setTintColor:[UIColor blackColor]];
        }
		self.titleLabel.textColor = [UIColor whiteColor];
		
	} else if (customBarStyle == PDNavigationBarStyleWhite) {
        if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
            [self setBarTintColor:[UIColor whiteColor]];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        } else {
            [self setTintColor:[UIColor whiteColor]];
        }
		self.titleLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
	} else if (customBarStyle == PDNavigationBarStyleOrange) {
        if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
            [self setBarTintColor:kPDGlobalGoldenrodColor];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        } else {
            [self setTintColor:kPDGlobalGoldenrodColor];
        }
        self.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)titleButtonTouch:(id)sender
{
	PDNavigationController *controller = (PDNavigationController *) self.delegate;
	if (![controller isKindOfClass:[PDNavigationController class]]) {
		NSLog(@"No navigation controller for navigation bar");
		return;
	}
	
	PDViewController *topViewController = (PDViewController *) controller.topViewController;
	if (![topViewController respondsToSelector:@selector(toggleToolbarView:)]) {
		NSLog(@"Top view controller isn't respond to toggle toolbar selector");
		return;
	}
	
	[topViewController performSelector:@selector(toggleToolbarView:) withObject:sender];
}

#pragma mark - setup scroll navigationbar

- (void)setup
{
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePan:)];
    self.panGesture.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationDidChange)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidChangeStatusBarOrientationNotification
                                                  object:nil];
}

- (void)setTableName:(NSString *)tableName
{
    _tableName = tableName;
}

- (void)setScrollView:(UIScrollView*)scrollView
{
    _scrollView = scrollView;
    // remove gesture from current panGesture's view
    if (self.panGesture.view) {
        [self.panGesture.view removeGestureRecognizer:self.panGesture];
    }
    
    if (scrollView) {
        [scrollView addGestureRecognizer:self.panGesture];
    }
    
}

- (void)resetToDefaultPosition:(BOOL)animated
{
    CGRect frame = self.frame;
    frame.origin.y = [self statusBarBottomYPoint];
    [self setFrame:frame alpha:1.0f animated:NO];
    self.linkToTopView.hidden = YES;
}

- (void)linkToTop
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (self.isLinkToTopShowed) {
        [self hideTopButton];
    }
}

#pragma mark - notifications

- (void)statusBarOrientationDidChange
{
    [self resetToDefaultPosition:NO];
}

- (void)applicationDidBecomeActive
{
    [self resetToDefaultPosition:NO];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - panGesture handler

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{

    if (!self.scrollView || gesture.view != self.scrollView) {
        return;
    }
    
    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    if (contentOffsetY < -self.scrollView.contentInset.top) {
        return;
    }

    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.scrollState = GTScrollNavigationBarNone;
        self.lastContentOffsetY = contentOffsetY;
        return;
    }
    
    CGFloat deltaY = contentOffsetY - self.lastContentOffsetY;
    if (deltaY < 0.0f) {
        
        self.scrollState = GTScrollNavigationBarScrollingDown;
        if (self.scrollView.contentOffset.y > self.scrollView.height * 2) {
            
            if (!self.linkToTopView) {
                [self initScrollToTopButton];
            }
            [self showTopButton];
            [self.scrollView.superview bringSubviewToFront:self.linkToTopView];
            
        } else {
            [self hideTopButton];
        }
    } else if (deltaY > 0.0f) {
        self.scrollState = GTScrollNavigationBarScrollingUp;
        [self hideTopButton];
    }
    
    if (self.scrollState == GTScrollNavigationBarScrollingUp) {
        if (self.scrollView.height + (self.height * 2) >= self.scrollView.contentSize.height) {
            return;
        }
    }

    CGRect frame = self.frame;
    CGFloat alpha = 1.0f;
    CGFloat statusBarHeight = [self statusBarBottomYPoint];
    CGFloat maxY = statusBarHeight;
    CGFloat minY = maxY - CGRectGetHeight(frame);

    if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
        minY = maxY - CGRectGetHeight(frame) + 1.0f;
    }
    
    // NOTE: plus 1px to prevent the navigation bar disappears in iOS < 7
    
    bool isScrollingAndGestureEnded = (gesture.state == UIGestureRecognizerStateEnded ||
                                       gesture.state == UIGestureRecognizerStateCancelled) &&
                                      (self.scrollState == GTScrollNavigationBarScrollingUp ||
                                      self.scrollState == GTScrollNavigationBarScrollingDown);
    if (isScrollingAndGestureEnded) {
        CGFloat contentOffsetYDelta = 0.0f;
        if (self.scrollState == GTScrollNavigationBarScrollingDown) {
            contentOffsetYDelta = maxY - frame.origin.y;
            frame.origin.y = maxY;
            alpha = 1.0f;
        }
        else if (self.scrollState == GTScrollNavigationBarScrollingUp) {
            contentOffsetYDelta = minY - frame.origin.y;
            frame.origin.y = minY;
            alpha = kNearZero;
        }
        
        [self setFrame:frame alpha:alpha animated:YES];
        
        if (!self.scrollView.decelerating) {
            CGPoint newContentOffset = CGPointMake(self.scrollView.contentOffset.x,
                                                   contentOffsetY - contentOffsetYDelta);
            [self.scrollView setContentOffset:newContentOffset animated:YES];
        }
    }
    else {
        frame.origin.y -= deltaY;
        frame.origin.y = MIN(maxY, MAX(frame.origin.y, minY));
        alpha = (frame.origin.y - (minY + statusBarHeight)) / (maxY - (minY + statusBarHeight));
        alpha = MAX(kNearZero, alpha);
        [self setFrame:frame alpha:alpha animated:NO];
    }
    
    self.lastContentOffsetY = contentOffsetY;
}

- (void)initScrollToTopButton
{
	self.linkToTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 35)];
	self.linkToTopView.backgroundColor = [UIColor clearColor];
	self.linkToTopView.alpha = 1;
	CGFloat cornerRadius = 13;
	self.scrollToTopButton.layer.cornerRadius = cornerRadius;
	self.scrollToTopButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
	self.scrollToTopButton.clipsToBounds = YES;
    [self.scrollToTopButton setImageEdgeInsets:UIEdgeInsetsMake( cornerRadius * 1.5, 0, 0, 0)];
	self.scrollToTopButton.frame = CGRectMake((self.linkToTopView.width - 50) / 2, - cornerRadius, 50, self.linkToTopView.height + 2 * cornerRadius);
	[self.scrollToTopButton setFontAwesomeIconForImage:[FAKFontAwesome chevronCircleUpIconWithSize:24]
																						forState:UIControlStateNormal
																					attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
	[self.scrollToTopButton addTarget:self action:@selector(linkToTop) forControlEvents:UIControlEventTouchUpInside];
	[self.linkToTopView addSubview:_scrollToTopButton];
	[self.scrollView.superview addSubview:self.linkToTopView];
    self.linkToTopView.hidden = YES;
}

- (void)showTopButton
{
	if (!self.linkToTopView.hidden) return;
    self.linkToTopView.hidden = NO;
    self.scrollToTopButton.y = - self.linkToTopView.height - self.scrollToTopButton.layer.cornerRadius;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
         self.scrollToTopButton.y = - self.scrollToTopButton.layer.cornerRadius - 8;
     } completion:^(BOOL finished) {
         [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
              self.scrollToTopButton.y = - 2 * self.scrollToTopButton.layer.cornerRadius;
          } completion:^(BOOL finished) {
          }];
     }];
    self.isLinkToTopShowed = YES;
}

- (BOOL)isShowed
{
	return (self.y > 0);
}

- (void)hideTopButton
{
	if (self.isLinkToTopShowed) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
            self.scrollToTopButton.y = - self.scrollToTopButton.layer.cornerRadius - 8;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^ {
                self.scrollToTopButton.y = - self.linkToTopView.height - 2 * self.scrollToTopButton.layer.cornerRadius;
            } completion:^(BOOL finished) {
                self.linkToTopView.hidden = YES;
            }];
        }];
        self.isLinkToTopShowed = NO;
    }
}

#pragma mark - helper methods

- (CGFloat)statusBarBottomYPoint
{
    if (SYSTEM_VERSION_GREATER_THAN(@"7.0")) {
        switch ([UIApplication sharedApplication].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                return CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                return CGRectGetWidth([UIApplication sharedApplication].statusBarFrame);
            default:
                break;
        };
        return 0.0f;
    } else {
        return 0.0f;
    }

}

- (void)setFrame:(CGRect)frame alpha:(CGFloat)alpha animated:(BOOL)animated
{
    if (self.hidden) {
        return;
    }
    if (animated) {
        [UIView beginAnimations:@"GTScrollNavigationBarAnimation" context:nil];
    }
    
    CGFloat offsetY = CGRectGetMinY(frame) - CGRectGetMinY(self.frame);
    for (UIView* view in self.subviews) {
        bool isBackgroundView = view == [self.subviews objectAtIndex:0];
        bool isViewHidden = view.hidden || view.alpha == 0.0f;
        if (isBackgroundView || isViewHidden)
            continue;
        view.alpha = alpha;
    }
    self.frame = frame;
    _scrollView.superview.y += offsetY;
    _scrollView.superview.height -= offsetY;

    if (animated) {
        [UIView commitAnimations];
    }
}

@end
