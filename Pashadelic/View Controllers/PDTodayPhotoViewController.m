//
//  PDHomepageViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 06.09.13.
//
//

#import "PDTodayPhotoViewController.h"
#import "PDServerGetTodaysPhoto.h"
#import "PDPhoto.h"
#import "PDForeCastWeatherViewController.h"
#import "NSDate+Extra.h"
#import "PDUserProfile.h"
#import "PDLogoProgressView.h"

@interface PDTodayPhotoViewController ()

@property (assign, nonatomic, getter = isTodayPhotoLoading) BOOL todayPhotoLoading;
@property (strong, nonatomic) PDServerGetTodaysPhoto *serverGetTodaysPhoto;
@property (strong, nonatomic) PDServerFollowItem *serverFollowItem;
@property (strong, nonatomic) CAGradientLayer *gradientLayerHomebutton;
@property (strong, nonatomic) CAGradientLayer *gradientLayerInfoView;
@property (strong, nonatomic) PDCollectionsViewController *collectionsViewController;
- (void)initTodaysPhotoButtons;
- (void)layoutViewForPhotoImageOrientation;
@end

@implementation PDTodayPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initTodaysPhotoButtons];
    [self refreshView];
    self.todaysPhotoLabel.text = NSLocalizedString(@"Today's photo", nil);
	self.loadingLabel.text = NSLocalizedString(@"Loading...", nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshButtonStatus)
                                                 name:kPDPhotoStatusChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (self.isTodayPhotoLoading) {
        self.todayPhotoImageView.hidden = YES;
        self.todaysPhotoInfoView.hidden = YES;
        self.homepageButton.hidden = YES;
        self.loadingLabel.hidden = NO;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
    self.loadingView.center = self.loadingView.superview.centerOfView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


#pragma mark - Private

- (void)layoutViewForPhotoImageOrientation
{
    if (self.todayPhotoImageView.image.size.width > self.todayPhotoImageView.image.size.height) {
        self.todaysPhotoView.transform = CGAffineTransformMakeRotation(0.5 * M_PI);
        self.todaysPhotoView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        self.todaysPhotoInfoView.frame = CGRectMake(0, self.todaysPhotoView.width - self.todaysPhotoInfoView.height,
                                                    self.todaysPhotoView.height, self.todaysPhotoInfoView.height);
        NSUInteger buttonSize = self.todaysPhotoInfoView.height - 20;
        self.homepageButton.transform = CGAffineTransformMakeRotation(-0.5 * M_PI);
        self.homepageButton.frame = CGRectMake(self.todaysPhotoView.height - buttonSize,
                                               self.todaysPhotoView.width - buttonSize,
                                               buttonSize, buttonSize);
        [self.homepageButton setTitle:@"" forState:UIControlStateNormal];
        [self.homepageButton setTitle:@"" forState:UIControlStateHighlighted];
        
    } else {
        self.todaysPhotoInfoView.width = self.todaysPhotoView.width;
        self.todaysPhotoInfoView.center = self.todaysPhotoView.centerOfView;
        self.homepageButton.frame = CGRectMake(0, self.todaysPhotoView.height - self.todaysPhotoInfoView.height,
                                               self.todaysPhotoView.width, self.todaysPhotoInfoView.height);
        [self.homepageButton setTitle:NSLocalizedString(@"Tap to access\nyour homepage", nil) forState:UIControlStateNormal];
        [self.homepageButton setTitle:NSLocalizedString(@"Tap to access\nyour homepage", nil) forState:UIControlStateHighlighted];
        self.homepageButton.transform = self.todaysPhotoView.transform = CGAffineTransformIdentity;
    }
    self.circleExpand.center = self.homepageButton.imageView.centerOfView;
}

- (void)initTodaysPhotoButtons
{
	self.homepageButton.titleLabel.numberOfLines = 0;
    [self.homepageButton setImage:[UIImage imageNamed:@"btn-arrow-circle-down.png"] forState:UIControlStateNormal];
	[self.homepageButton setTitle:[self.homepageButton titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.homepageButton.imageView addSubview:self.circleExpand];
    self.homepageButton.clipsToBounds = NO;
    self.homepageButton.imageView.clipsToBounds = NO;
    
	[self.todaysPhotoPinButton setImage:[UIImage imageNamed:@"icon-pin-large-white.png"] forState:UIControlStateNormal];
	[self.todaysPhotoPinButton setImageForSelectedState:[UIImage imageNamed:@"icon-pin-large-on.png"]];
	
	CGFloat fontSize = 25;
	[self.todaysPhotoLikeButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsOUpIconWithSize:fontSize]
                                                  forState:UIControlStateNormal
                                                attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	[self.todaysPhotoLikeButton setFontAwesomeIconForImage:[FAKFontAwesome thumbsUpIconWithSize:fontSize]
                                                  forState:UIControlStateSelected
                                                attributes:@{NSForegroundColorAttributeName: kPDGlobalGreenColor}];
	
	[self.todaysPhotoPinButton setFontAwesomeIconForImage:[FAKFontAwesome folderOpenOIconWithSize:fontSize]
                                                 forState:UIControlStateNormal
                                               attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	[self.todaysPhotoPinButton setFontAwesomeIconForImage:[FAKFontAwesome folderIconWithSize:fontSize]
                                                 forState:UIControlStateSelected
                                               attributes:@{NSForegroundColorAttributeName: kPDGlobalGreenColor}];
	
	
    self.homepageButton.layer.shadowColor = self.todaysPhotoInfoView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.homepageButton.layer.shadowOffset = self.todaysPhotoInfoView.layer.shadowOffset = CGSizeMake(-1, -1);
    self.homepageButton.layer.shadowOpacity = self.todaysPhotoInfoView.layer.shadowOpacity = 0.7;
    self.todaysPhotoInfoView.layer.shadowRadius = 3;
    self.homepageButton.layer.shadowRadius = 5;
}

- (void)showTodaysPhotoAnimated
{
    [self layoutViewForPhotoImageOrientation];
	self.loadingLabel.hidden = YES;
    self.progressView.hidden = YES;
    [self.progressView setProgress:0];
	self.todayPhotoImageView.alpha = 0;
	self.todayPhotoImageView.hidden = NO;
	self.todaysPhotoInfoView.alpha = 0;
	self.todaysPhotoInfoView.hidden = NO;
	[self.view bringSubviewToFront:self.todaysPhotoInfoView];
	self.homepageButton.alpha = 0;
	self.homepageButton.hidden = NO;
    self.circleExpand.alpha = 0;
	CGFloat animationDuration = 1.0;
	
	[UIView animateWithDuration:animationDuration animations:^{
		self.todayPhotoImageView.alpha = 1;
	} completion:^(BOOL finished) {
        
		[UIView animateWithDuration:animationDuration animations:^{
			self.todaysPhotoInfoView.alpha = 1;
            
		} completion:^(BOOL finished) {
			double delayInSeconds = 3.0;
			dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
			dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
				[UIView animateWithDuration:animationDuration animations:^{
					self.homepageButton.alpha = 1;
                    self.circleExpand.alpha = 1;
                    if (!self.circleExpand.didExpandCircle) {
                        [self.circleExpand circleExpand];
                    }
				}];
			});
		}];
	}];
}

- (void)resetTodayPhotoLayout
{
    self.todaysPhotoView.transform = CGAffineTransformIdentity;
    self.homepageButton.transform = CGAffineTransformIdentity;
    self.todaysPhotoView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.todayPhotoLoading = YES;
	self.todayPhotoImageView.hidden = YES;
	self.todaysPhotoInfoView.hidden = YES;
    self.homepageButton.hidden = YES;
	self.loadingLabel.hidden = NO;
}

#pragma mark - Override

- (NSString *)pageName
{
	return @"Today Photo";
}

- (void)refreshView
{
	[super refreshView];
	self.todayUsernameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"By %@", nil), self.todaysPhoto.user.name];
	if (self.todaysPhoto.user.followStatus) {
		[self.followButton setTitle:NSLocalizedString(@"Following", nil) forState:UIControlStateNormal];
	} else {
		[self.followButton setTitle:NSLocalizedString(@"+ Follow", nil) forState:UIControlStateNormal];
	}
	self.todaysPhotoPinButton.selected = self.todaysPhoto.pinnedStatus;
	self.todaysPhotoLikeButton.selected = self.todaysPhoto.likedStatus;
    if (!self.todaysPhoto.identifier) {
        self.followButton.enabled = NO;
        self.todaysPhotoLikeButton.enabled = NO;
        self.todaysPhotoPinButton.enabled = NO;
        self.todaysPhotoUserButton.enabled = NO;
    }else{
        self.followButton.enabled = YES;
        self.todaysPhotoLikeButton.enabled = YES;
        self.todaysPhotoPinButton.enabled = YES;
        self.todaysPhotoUserButton.enabled = YES;
    }
}

- (void)showMenu:(id)sender
{
    [self refreshUnreadItemsIcon];
	[self showMainMenu];
}

- (void)addPhototoCollection:(PDPhoto *)photo
{
    PDCollectionsViewController *collectionsViewController = [[PDCollectionsViewController alloc] initForUniversalDevice];
    collectionsViewController.photo = photo;
    collectionsViewController.view.frame = [UIApplication sharedApplication].keyWindow.frame;
    CGRect frame = collectionsViewController.view.frame;
    frame.origin.y = frame.size.height;
    collectionsViewController.view.frame = frame;
    [self addChildViewController:collectionsViewController];
    [self.view addSubview:collectionsViewController.view];
    [collectionsViewController viewWillAppear:YES];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = collectionsViewController.view.frame;
        frame.origin.y = 0;
        collectionsViewController.view.frame = frame;
    }];
}

- (void)hideNoInternetButton
{
	[super hideNoInternetButton];
	[self fetchData];
}

- (void)fetchData
{
    if (!self.serverGetTodaysPhoto) {
		self.serverGetTodaysPhoto = [[PDServerGetTodaysPhoto alloc] initWithDelegate:self];
	}
	[self.serverGetTodaysPhoto getTodaysPhoto];
    [self resetTodayPhotoLayout];
}


#pragma mark - Actions

- (IBAction)likeTodaysPhoto:(id)sender
{
    if (self.todaysPhoto.likedStatus) {
        [self trackEvent:@"Unlike"];
    } else{
        [self trackEvent:@"Like"];
    }
    [self.todaysPhoto likePhoto];
}

- (IBAction)followTodaysUser:(id)sender
{
    [self.followButton showActivityWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
	self.serverFollowItem  = [[PDServerFollowItem alloc] initWithDelegate:self];
	if (self.item.followStatus) {
        [self trackEvent:@"Unfollow"];
		[self.serverFollowItem  unfollowItem:self.todaysPhoto.user];
	} else {
        [self trackEvent:@"Follow"];
		[self.serverFollowItem  followItem:self.todaysPhoto.user];
	}
}

- (IBAction)pinTodaysPhoto:(id)sender
{
    if (self.todaysPhoto.pinnedStatus) {
        [self trackEvent:@"Uncollect"];
        [self.todaysPhoto unPinPhoto];
    } else{
        [self trackEvent:@"Collect"];
        [self performSelector:@selector(addPhototoCollection:) withObject:self.todaysPhoto];
    }
}

- (IBAction)showTodaysUserInfo:(id)sender
{
	[self itemDidSelect:self.todaysPhoto.user];
}

- (IBAction)showHomepage:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.window.layer addAnimation:transition forKey:nil];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	if ([serverExchange isEqual:self.serverGetTodaysPhoto]) {
		self.todayPhotoLoading = NO;
		self.todaysPhoto = [PDPhoto new];
		[self.todaysPhoto loadShortDataFromDictionary:result[@"photo"]];
		self.todaysPhoto.user.followStatus = [result[@"photo"] boolForKey:@"follow_status"];
		self.todaysPhoto.fullImageURL = [[result objectForKey:@"photo"] urlForKey:@"image_mobile_url"];
        [kPDUserDefaults setURL:self.todaysPhoto.fullImageURL forKey:kPDTodayPhotoURLKey];
        [kPDUserDefaults synchronize];
        self.progressView.hidden = NO;
        [self.todayPhotoImageView sd_setImageWithURL:self.todaysPhoto.fullImageURL placeholderImage:[UIImage imageNamed:@"placeholder_today_photo.png"] options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            double value = (float) receivedSize / expectedSize;
            [self.progressView setProgress:value];
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                [self showTodaysPhotoAnimated];
                return;
            }
            self.todayPhotoLoading = NO;
            [self refreshView];
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        [self.todayUserImageView sd_setImageWithURL:self.todaysPhoto.user.thumbnailURL];
        [self refreshView];
	} else if ([serverExchange isEqual:self.serverFollowItem]) {
        if (self.todaysPhoto.user.followStatus) {
			self.todaysPhoto.user.followStatus = NO;
			self.todaysPhoto.user.followersCount--;
            kPDAppDelegate.userProfile.followingsCount--;
            [self.followButton setTitle:NSLocalizedString(@"+ Follow", nil) forState:UIControlStateNormal];
		} else {
			self.todaysPhoto.user.followStatus = YES;
			self.todaysPhoto.user.followersCount++;
            kPDAppDelegate.userProfile.followingsCount++;
            [self.followButton setTitle:NSLocalizedString(@"Following", nil) forState:UIControlStateNormal];
		}
		[self.followButton hideActivity];
	}
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	if ([serverExchange isEqual:self.serverFollowItem]) {
		[self.followButton hideActivity];
        self.followButton.enabled = NO;
        
	} else if ([serverExchange isEqual:self.serverGetTodaysPhoto]) {
		self.todayPhotoLoading = NO;
		[self refreshView];
		[self dismissViewControllerAnimated:NO completion:nil];
	}
}


#pragma mark - NSNotification

- (void)refreshButtonStatus
{
	self.todaysPhotoLikeButton.enabled = !(self.todaysPhoto.user.identifier == kPDUserID);
	self.todaysPhotoLikeButton.selected = self.todaysPhoto.likedStatus;
	self.todaysPhotoPinButton.enabled = !(self.todaysPhoto.user.identifier == kPDUserID);
	self.todaysPhotoPinButton.selected = self.todaysPhoto.pinnedStatus;
}

@end
