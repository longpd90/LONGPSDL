//
//  PDMainMenuViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 04.04.13.
//
//

#import "PDMainMenuViewController.h"
#import "PDCameraViewController.h"
#import "UIImage+Extra.h"
#import <CoreImage/CoreImage.h>

@interface PDMainMenuViewController ()
{
	BOOL mainMenuAnimationShowing;
}

@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) CIContext *context;

- (void)initMenuButtons;
- (void)deselectButtons;
- (void)refreshButtons;

@end


@implementation PDMainMenuViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
		self.homeViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDHomePageViewController"];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	self.context = [CIContext contextWithOptions:nil];
	for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
		[self.view removeGestureRecognizer:gesture];
	}
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(userAvatarWasChanged:)
												 name:kPDUserAvatarWasChangedNotification
											   object:nil];
    
	UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu:)];
	leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:leftGesture];
	self.blurView = [[UIImageView alloc] initWithFrame:self.menuContentView.zeroPositionFrame];
	self.blurView.autoresizingMask = self.menuContentView.autoresizingMask;
	self.blurView.clipsToBounds = YES;
	self.blurView.contentMode = UIViewContentModeTopLeft;
	[self.view insertSubview:self.blurView belowSubview:self.menuContentView];
	self.userAvatarImageView.layer.cornerRadius = 3;
	self.userAvatarImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.userAvatarImageView.layer.borderWidth = 1;
	self.userAvatarImageView.clipsToBounds = YES;
	self.shadowView.gradientLayer.startPoint = CGPointMake(0, 0.5);
	self.shadowView.gradientLayer.endPoint = CGPointMake(1.0, 0.5);
	[self.shadowView setGradientFirstColor:self.menuContentView.backgroundColor secondColor:[UIColor clearColor]];
	[self initMenuButtons];
	[self refreshView];
	self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self refreshView];
	UINavigationController *centerController = (UINavigationController *) self.viewDeckController.centerController;
	if ([centerController isKindOfClass:[UINavigationController class]]) {
		[centerController.topViewController.view endEditing:YES];
	}
}

#pragma mark - Private

- (void)userAvatarWasChanged:(NSNotification *)notification
{
    NSDictionary *userAvatar = notification.userInfo;
	UIImage *userAvatarImage = [userAvatar objectForKey:@"userAvatar"];
    self.userAvatarImageView.image = userAvatarImage;
}

- (void)initMenuButtons
{
	self.userInfoButton.titleLabel.numberOfLines = 3;
	self.userAvatarImageView.contentMode = UIViewContentModeScaleAspectFit;
	self.notificationsBadgeView.layer.cornerRadius = self.notificationsBadgeView.width / 2;
	self.notificationsBadgeView.clipsToBounds = YES;
  self.plansBadgeView.layer.cornerRadius = self.plansBadgeView.width / 2;
	self.plansBadgeView.clipsToBounds = YES;
  
	CGFloat fontSize = 22;
	NSDictionary *whiteColorAttribute = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
	NSDictionary *blackColorAttribute = @{NSForegroundColorAttributeName: [UIColor blackColor]};
  
	[self.notificationsButton setFontAwesomeIconForImage:[FAKFontAwesome rssIconWithSize:fontSize] forState:UIControlStateNormal attributes:whiteColorAttribute];
	[self.notificationsButton setFontAwesomeIconForImage:[FAKFontAwesome rssIconWithSize:fontSize] forState:UIControlStateHighlighted attributes:blackColorAttribute];
	[self.notificationsButton setTitle:NSLocalizedString(@"notifications", nil)];
  
	[self.homeButton setFontAwesomeIconForImage:[FAKFontAwesome homeIconWithSize:fontSize] forState:UIControlStateNormal attributes:whiteColorAttribute];
	[self.homeButton setFontAwesomeIconForImage:[FAKFontAwesome homeIconWithSize:fontSize] forState:UIControlStateHighlighted attributes:blackColorAttribute];
    [self.homeButton setTitle:NSLocalizedString(@"home", nil)];
  
	
	[self.searchButton setFontAwesomeIconForImage:[FAKFontAwesome searchIconWithSize:fontSize] forState:UIControlStateNormal attributes:whiteColorAttribute];
	[self.searchButton setFontAwesomeIconForImage:[FAKFontAwesome searchIconWithSize:fontSize] forState:UIControlStateHighlighted attributes:blackColorAttribute];
    [self.searchButton setTitle:NSLocalizedString(@"explore", nil)];
  
	
	[self.popularButton setFontAwesomeIconForImage:[FAKFontAwesome pictureOIconWithSize:fontSize] forState:UIControlStateNormal attributes:whiteColorAttribute];
	[self.popularButton setFontAwesomeIconForImage:[FAKFontAwesome pictureOIconWithSize:fontSize] forState:UIControlStateHighlighted attributes:blackColorAttribute];
    [self.popularButton setTitle:NSLocalizedString(@"discover", nil)];
  
	
	[self.photoToolButton setFontAwesomeIconForImage:[FAKFontAwesome sunOIconWithSize:fontSize] forState:UIControlStateNormal attributes:whiteColorAttribute];
	[self.photoToolButton setFontAwesomeIconForImage:[FAKFontAwesome sunOIconWithSize:fontSize] forState:UIControlStateHighlighted attributes:blackColorAttribute];
    [self.photoToolButton setTitle:NSLocalizedString(@"photo tool", nil)];
	
	[self.plansButton setFontAwesomeIconForImage:[FAKFontAwesome clockOIconWithSize:fontSize] forState:UIControlStateNormal attributes:whiteColorAttribute];
	[self.plansButton setFontAwesomeIconForImage:[FAKFontAwesome clockOIconWithSize:fontSize] forState:UIControlStateHighlighted attributes:blackColorAttribute];
	[self.plansButton setTitle:NSLocalizedString(@"plans", nil)];

	[self.aRButton setFontAwesomeIconForImage:[FAKFontAwesome cameraRetroIconWithSize:fontSize] forState:UIControlStateNormal attributes:whiteColorAttribute];
	[self.aRButton setFontAwesomeIconForImage:[FAKFontAwesome cameraRetroIconWithSize:fontSize] forState:UIControlStateHighlighted attributes:blackColorAttribute];
	[self.aRButton setTitle:NSLocalizedString(@"AR View", nil)];

	[self.settingsButton setFontAwesomeIconForImage:[FAKFontAwesome cogIconWithSize:fontSize] forState:UIControlStateNormal attributes:whiteColorAttribute];
	[self.settingsButton setFontAwesomeIconForImage:[FAKFontAwesome cogIconWithSize:fontSize] forState:UIControlStateHighlighted attributes:blackColorAttribute];
	[self.settingsButton setTitle:NSLocalizedString(@"settings", nil)];
	
	self.buttons = @[self.userInfoButton, self.notificationsButton, self.homeButton, self.searchButton, self.photoToolButton, self.plansButton, self.aRButton ,self.popularButton, self.settingsButton, self.cameraButton];
	UIImage *highlightedBackgroundImage = [[UIImage new] imageWithColor:[UIColor colorWithWhite:1 alpha:0.5]];
  
  
	for (UIButton *button in self.buttons) {
		[button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
		[button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateSelected];
		[button setImage:[button imageForState:UIControlStateHighlighted] forState:UIControlStateSelected];
	}
  
	
  [self.cameraButton setTitle:NSLocalizedString(@"camera", nil)];
  
}

- (void)deselectButtons
{
	for (UIButton *button in self.buttons) {
		[button setSelected:NO];
	}
}

- (void)refreshButtons
{
	[self deselectButtons];
	if ([self.viewDeckController.centerController isEqual:self.meViewController]) {
		self.userInfoButton.selected = YES;
	} else 	if ([self.viewDeckController.centerController isEqual:self.homeViewController]) {
		self.homeButton.selected = YES;
	} else 	if ([self.viewDeckController.centerController isEqual:self.searchViewController]) {
		self.searchButton.selected = YES;
	} else 	if ([self.viewDeckController.centerController isEqual:self.photoToolViewController]) {
		self.photoToolButton.selected = YES;
	} else 	if ([self.viewDeckController.centerController isEqual:self.plansViewController]) {
		self.plansButton.selected = YES;
	} else 	if ([self.viewDeckController.centerController isEqual:self.aRViewController]) {
		self.aRButton.selected = YES;
	} else 	if ([self.viewDeckController.centerController isEqual:self.popularViewController]) {
		self.popularButton.selected = YES;
	} else 	if ([self.viewDeckController.centerController isEqual:self.notificationsViewController]) {
		self.notificationsButton.selected = YES;
	} else 	if ([self.viewDeckController.centerController isEqual:self.settingsViewController]) {
		self.settingsButton.selected = YES;
	}
}


#pragma mark - Public

- (void)refreshView
{
	if (kPDAppDelegate.userProfile.unreadItemsCount == 0) {
		self.notificationsBadgeView.hidden = YES;
	} else {
		self.notificationsBadgeView.hidden = NO;
		self.notificationsBadgeView.text = [NSString stringWithFormat:@"%ld", (long)kPDAppDelegate.userProfile.unreadItemsCount];
	}
  
  if (kPDAppDelegate.userProfile.plansUpcomingCount == 0) {
		self.plansBadgeView.hidden = YES;
	} else {
		self.plansBadgeView.hidden = NO;
		self.plansBadgeView.text =  [NSString stringWithFormat:@"%ld", (long)kPDAppDelegate.userProfile.plansUpcomingCount];
	}
  
	[self.userInfoButton setTitle:kPDAppDelegate.userProfile.name forState:UIControlStateNormal];
	[self refreshButtons];
}

- (IBAction)showSettings:(id)sender
{
	[self deselectButtons];
	self.settingsButton.selected = YES;
	if (!self.settingsViewController) {
		self.settingsViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDProfileSettingsViewController"];
	}
	self.viewDeckController.centerController = self.settingsViewController;
	[self hideMenu:nil];
}

- (IBAction)showUserInfo:(id)sender
{
	[self deselectButtons];
	self.userInfoButton.selected = YES;
  
	if (!self.meViewController) {
		self.meViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDMeViewController"];
	}
	self.viewDeckController.centerController = self.meViewController;
	[self hideMenu:nil];
}

- (void)setLoading:(BOOL)loading
{
	[super setLoading:NO];
}

- (IBAction)showPhotoTool:(id)sender
{
	[self deselectButtons];
	self.photoToolButton.selected = YES;
  
	if (!self.photoToolViewController) {
		self.photoToolViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDPhotoToolsViewController"];
	}
    [self popToRootViewController:self.photoToolViewController];
	self.viewDeckController.centerController = self.photoToolViewController;
	[self hideMenu:nil];
}

- (IBAction)showPlans:(id)sender
{
  
  [self deselectButtons];
	self.plansButton.selected = YES;
  
//	if (!self.plansViewController) {
//		self.plansViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDPlansViewController"];
//	}
//    [self popToRootViewController:self.plansViewController];
//	self.viewDeckController.centerController = self.plansViewController;
    if (!self.upcomingPlanViewController) {
        self.upcomingPlanViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDUpcomingPlanViewController"];
    }
    [self popToRootViewController:self.upcomingPlanViewController];
    self.viewDeckController.centerController = self.upcomingPlanViewController;
    [self hideMenu:nil];
}

- (IBAction)showHome:(id)sender
{
	[self deselectButtons];
	self.homeButton.selected = YES;
  
	if (!self.homeViewController) {
		self.homeViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDHomePageViewController"];
	}
    [self popToRootViewController:self.homeViewController];
    self.viewDeckController.centerController = self.homeViewController;
	[self hideMenu:nil];
}

- (IBAction)showNotifications:(id)sender
{
	[self deselectButtons];
	self.notificationsButton.selected = YES;
  
	if (!self.notificationsViewController) {
		self.notificationsViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDNotificationsViewController"];
	}
    [self popToRootViewController:self.notificationsViewController];
	self.viewDeckController.centerController = self.notificationsViewController;
	[self hideMenu:nil];
}

- (IBAction)showSearch:(id)sender
{
	[self deselectButtons];
	self.searchButton.selected = YES;
  
	if (!self.searchViewController) {
		self.searchViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDExploreViewController"];
	}
    [self popToRootViewController:self.searchViewController];
	self.viewDeckController.centerController = self.searchViewController;
	[self hideMenu:nil];
}

- (void)showMainMenu
{
	if (mainMenuAnimationShowing) return;
	
	mainMenuAnimationShowing = YES;
	[self.view.superview bringSubviewToFront:self.view];
  [self refreshView];
//	UIImage *screenshot = [self.viewDeckController.centerController.view captureView];
//	CIImage *inputImage = [CIImage imageWithCGImage:screenshot.CGImage];
//	CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//	[filter setValue:inputImage forKey:kCIInputImageKey];
//	[filter setValue:@(5) forKey:@"inputRadius"];
//	CIImage *outputCIImage = filter.outputImage;
//	CGImageRef outputCGImage = [self.context createCGImage:outputCIImage fromRect:CGRectMakeWithSize(0, 0, screenshot.size)];
//	self.blurView.image = [UIImage imageWithCGImage:outputCGImage];
//  CGImageRelease(outputCGImage);
	self.blurView.x = 0;
	self.blurView.width = 0;
	self.menuContentView.x = -self.menuContentView.width - self.shadowView.width;
	self.shadowView.x = self.menuContentView.rightXPoint;
	self.view.x = 0;
	
	[UIView animateWithDuration:0.3 animations:^{
		self.menuContentView.x = 0;
		self.shadowView.x = self.menuContentView.width;
		self.blurView.width = self.menuContentView.width;
		mainMenuAnimationShowing = NO;
	}];
}

- (IBAction)hideMenu:(id)sender
{
	[self.view.superview bringSubviewToFront:self.view];
	[UIView animateWithDuration:0.4 animations:^{
		self.menuContentView.x = -self.menuContentView.width - self.shadowView.width;
		self.shadowView.x = self.menuContentView.rightXPoint;
		self.blurView.width = 0;
	} completion:^(BOOL finished) {
		self.view.x = self.viewDeckController.centerController.view.x - self.view.width;
	}];
}

- (IBAction)showCamera:(id)sender
{
	if (!self.cameraViewController) {
		self.cameraViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDCameraViewController"];
	}
	
	[self.viewDeckController presentViewController:self.cameraViewController animated:NO completion:nil];
	[self hideMenu:nil];
}

- (void)showPopular:(id)sender
{
	[self deselectButtons];
	self.popularButton.selected = YES;
  
	if (!self.popularViewController) {
		self.popularViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDDiscoverViewController"];
	}
    [self popToRootViewController:self.popularViewController];
	self.viewDeckController.centerController = self.popularViewController;
	[self hideMenu:nil];
}

- (IBAction)showAR:(id)sender
{
	
	[self deselectButtons];
	self.aRButton.selected = YES;
	
	if (!self.aRViewController) {
		self.aRViewController = [[PDNavigationController alloc] initWithRootViewControllerName:@"PDARViewController"];
	}
	self.viewDeckController.centerController = self.aRViewController;
	[self hideMenu:nil];
}

- (void)popToRootViewController:(PDNavigationController*)navigationController
{
    if (![navigationController.topViewController isEqual:navigationController]) {
        [navigationController popToRootViewControllerAnimated:NO];
    }
}

- (void)trackCurrentPage
{
}

- (IIViewDeckController *)viewDeckController
{
	return kPDAppDelegate.viewDeckController;
}

@end
