//
//  PDSplashViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 9/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDSplashViewController.h"
#import "PDLoginViewController.h"
#import "DDPageControl.h"
#import "PDSignupViewController.h"

@interface PDSplashViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet PDGlobalFontButton *contentLoginButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *signupButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *loginButton;
@property (strong, nonatomic) DDPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *bottomControlsView;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *informationScrollView;
@property (strong, nonatomic) IBOutlet UIView *scrollableBackgroundView;
@property (strong, nonatomic) IBOutlet UIView *scrollableInformationView;
@property (assign, nonatomic) double scrollCoefficient;
@property (weak, nonatomic) IBOutlet UIView *backgroundOverlayView;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *contentSignupButton;

- (void)initPageControl;
- (void)initInterface;
- (void)hideBottomButtonsAnimated;
- (void)showBottomButtonsAnimated;

@end

@implementation PDSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initInterface];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.scrollableBackgroundView.height = self.view.height;
    self.scrollableInformationView.height = self.view.height;
    self.backgroundScrollView.contentSize = self.scrollableBackgroundView.frame.size;
    self.informationScrollView.contentSize = self.scrollableInformationView.frame.size;
    self.scrollCoefficient = self.backgroundScrollView.width / self.informationScrollView.width;
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Private

- (void)showChildViewControllerAnimated:(UIViewController *)viewController
{
    [self addChildViewController:viewController];
    viewController.view.height = self.view.height;
    viewController.view.y = - viewController.view.height;
    [self.view addSubview:viewController.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundOverlayView.alpha = 0.5;
        self.informationScrollView.y = self.view.height;
        self.bottomControlsView.y = self.view.height;
        viewController.view.y = 0;
    }];
}

- (void)hideChildViewControllerAnimated
{
    if (self.childViewControllers.count == 0) return;
    
    UIViewController *viewController = self.childViewControllers.lastObject;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundOverlayView.alpha = 0.05;
        self.informationScrollView.y = 0;
        self.bottomControlsView.y = self.view.height - self.bottomControlsView.height;
        viewController.view.y = -self.view.height;
        
    } completion:^(BOOL finished) {
        [viewController removeFromParentViewController];
        [viewController.view removeFromSuperview];
    }];
}

- (void)initInterface
{
    [self initPageControl];
    [self.backgroundScrollView addSubview:self.scrollableBackgroundView];
    [self.informationScrollView addSubview:self.scrollableInformationView];
    self.signupButton.layer.borderColor = self.loginButton.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    self.signupButton.layer.borderWidth = self.loginButton.layer.borderWidth = 1;
    [self.informationScrollView clearBackgroundColor];
    [self.scrollableInformationView clearBackgroundColor];
    self.backgroundOverlayView.backgroundColor = [UIColor blackColor];
    self.backgroundOverlayView.alpha = 0.2;
    
    NSAttributedString *loginTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Log in", nil)
                                                                     attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                                                                  NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.contentLoginButton setAttributedTitle:loginTitle forState:UIControlStateNormal];
    
    [self.contentSignupButton applyRedStyleToButton];
}

- (void)initPageControl
{
    self.pageControl = [[DDPageControl alloc] initWithType:DDPageControlTypeOnFullOffEmpty];
    self.pageControl.numberOfPages = self.scrollableInformationView.width / self.informationScrollView.width;
    self.pageControl.onColor = [UIColor whiteColor];
    self.pageControl.offColor = [UIColor whiteColor];
    self.pageControl.indicatorDiameter = 15;
    self.pageControl.indicatorSpace = 15;
    self.pageControl.center = self.bottomControlsView.centerOfView;
    self.pageControl.y = self.signupButton.y - 50;
	self.pageControl.userInteractionEnabled = NO;
    [self.bottomControlsView addSubview:self.pageControl];
}

- (void)hideBottomButtonsAnimated
{
    if (self.signupButton.isHidden) return;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.signupButton.y = self.loginButton.y = self.bottomControlsView.height;
    } completion:^(BOOL finished) {
        self.signupButton.hidden = self.loginButton.hidden = YES;
    }];
}

- (void)showBottomButtonsAnimated
{
    if (!self.signupButton.isHidden) return;
    
    self.signupButton.hidden = self.loginButton.hidden = NO;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.signupButton.y = self.loginButton.y = self.bottomControlsView.height - self.signupButton.height + 1;
    }];
}


#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    self.pageControl.currentPage = contentOffset.x / scrollView.width;
	[UIView animateWithDuration:0.05 animations:^{
		[self.backgroundScrollView setContentOffset:CGPointMake(contentOffset.x * self.scrollCoefficient, 0) animated:NO];
	}];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.backgroundOverlayView.alpha == 0.5) return;
    
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundOverlayView.alpha = 0.05;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.pageControl.currentPage == self.pageControl.numberOfPages - 1) {
        [self hideBottomButtonsAnimated];
    } else {
        [self showBottomButtonsAnimated];
    }
    [UIView animateWithDuration:0.15 animations:^{
        self.backgroundOverlayView.alpha = 0.2;
    }];
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Splash View";
}

- (IBAction)login:(id)sender
{
    UIViewController *loginViewController = [[PDLoginViewController alloc] initForUniversalDevice];
    [self showChildViewControllerAnimated:loginViewController];
}

- (IBAction)signup:(id)sender
{
    UIViewController *loginViewController = [[PDSignupViewController alloc] initForUniversalDevice];
    [self showChildViewControllerAnimated:loginViewController];
}

- (IBAction)learnMoreButtonClicked:(id)sender {
    self.pageControl.currentPage = self.pageControl.currentPage + 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundOverlayView.alpha = 0.05;
		[self.informationScrollView setContentOffset:CGPointMake(320, 0) animated:NO];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundOverlayView.alpha = 0.2;
        }];
        
    }];
}

@end
