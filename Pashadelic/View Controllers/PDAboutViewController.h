//
//  PDAboutViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.11.12.
//
//

#import "PDViewController.h"

@interface PDAboutViewController : PDViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet PDGradientButton *rateButton;
@property (weak, nonatomic) IBOutlet PDGradientButton *facebookButton;
@property (weak, nonatomic) IBOutlet PDGradientButton *twitterButton;

- (IBAction)rateUs:(id)sender;
- (IBAction)likeUsOnFacebook:(id)sender;
- (IBAction)followUsOnTwitter:(id)sender;

@end
