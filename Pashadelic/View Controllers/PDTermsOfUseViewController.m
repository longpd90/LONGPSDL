//
//  PDTermsOfUserViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.12.12.
//
//

#import "PDTermsOfUseViewController.h"

@interface PDTermsOfUseViewController ()

@end

@implementation PDTermsOfUseViewController

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
	self.title = NSLocalizedString(@"Terms Of Use", nil);
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[kPDAppDelegate showWaitingSpinner];
	[self.webView loadRequest:
	 [NSURLRequest requestWithURL:
	  [NSURL URLWithString:NSLocalizedString(@"http://api.pashadelic.com/pages/term_of_use", nil)]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
}

- (BOOL)prefersStatusBarHidden
{
	return YES;
}


- (void)goBack:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Web view delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[kPDAppDelegate hideWaitingSpinner];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	[UIAlertView showAlertWithTitle:nil message:error.localizedDescription];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
