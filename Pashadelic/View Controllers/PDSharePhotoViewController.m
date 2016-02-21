//
//  PDSharePhotoViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 8/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDSharePhotoViewController.h"
#import <Social/Social.h>


@interface PDSharePhotoViewController ()

@end

@implementation PDSharePhotoViewController
@synthesize photoImageView;
@synthesize photoTitleLabel;
@synthesize locationLabel, photo;

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
	self.title = NSLocalizedString(@"Share Photo", nil);
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[self refreshView];
	_shareTextLabel.text = NSLocalizedString(@"Share", nil);
}

- (void)viewDidUnload
{
    [self setPhotoImageView:nil];
    [self setPhotoTitleLabel:nil];
    [self setLocationLabel:nil];
    [self setShareTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Public

- (NSString *)pageName
{
	return @"Photo Share";
}

- (void)setPhoto:(PDPhoto *)newPhoto
{
	photo = nil;
	photo = newPhoto;
	[self refreshView];
}

- (void)refreshView
{
	self.needRefreshView = NO;
	[self.photoImageView sd_setImageWithURL:photo.thumbnailURL];
	photoTitleLabel.text = photo.title;
	locationLabel.text = photo.location;
}


- (void)shareItemWithTwitterInViewController:(UIViewController *)viewController
{
 }

- (void)shareItemWithFacebookInViewController:(UIViewController *)viewController
{
}

- (IBAction)shareWithFacebook:(id)sender 
{
	SLComposeViewController *facebookController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
	[facebookController setInitialText:self.title];
	NSString *sharePhotoURL = [kPDSharePhotoURL stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.photo.identifier]];
	[facebookController addURL:[NSURL URLWithString:sharePhotoURL]];
	[self presentViewController:facebookController animated:YES completion:nil];

    [self trackEvent:@"Share Facebook"];
}

- (IBAction)shareWithTwitter:(id)sender 
{
	NSString *sharePhotoURL = [kPDSharePhotoURL stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)self.photo.identifier]];
	SLComposeViewController *twitterController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
	[twitterController addImage:self.photoImageView.image];
	[twitterController setInitialText:sharePhotoURL];
	[self presentViewController:twitterController animated:YES completion:nil];

    [self trackEvent:@"Share Twitter"];
}
	 
@end
