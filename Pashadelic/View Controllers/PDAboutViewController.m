//
//  PDAboutViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.11.12.
//
//

#import "PDAboutViewController.h"

@interface PDAboutViewController ()

@end

@implementation PDAboutViewController

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
	self.title = NSLocalizedString(@"About", nil);
	_scrollView.contentSize = _scrollView.frame.size;
	_scrollView.frame = self.view.frame;
	[self.view addSubview:_scrollView];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[_rateButton setRedGradientButtonStyle];
	[_rateButton setTitle:NSLocalizedString(@"Rate Us!", nil) forState:UIControlStateNormal];
	[_facebookButton setRedGradientButtonStyle];
	[_facebookButton setTitle:NSLocalizedString(@"Like us on Facebook", nil) forState:UIControlStateNormal];
	[_twitterButton setRedGradientButtonStyle];
	[_twitterButton setTitle:NSLocalizedString(@"Follow us on Twitter", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)pageName
{
	return @"About";
}

- (IBAction)rateUs:(id)sender
{
	NSURL *rateURL = [NSURL URLWithString:kPDRateAppLink];
	[[UIApplication sharedApplication] openURL:rateURL];
}

- (IBAction)likeUsOnFacebook:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPDFacebookPageNativeURL]];
    } else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPDFacebookPageURL]];
}

- (IBAction)followUsOnTwitter:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPDTwitterPageNativeURL]];
    } else
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPDTwitterPageURL]];
}

- (void)viewDidUnload
{
	[self setScrollView:nil];
    [self setRateButton:nil];
    [self setFacebookButton:nil];
    [self setTwitterButton:nil];
	[super viewDidUnload];
}

@end
