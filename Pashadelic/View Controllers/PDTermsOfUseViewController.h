//
//  PDTermsOfUserViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.12.12.
//
//

#import "PDViewController.h"

@interface PDTermsOfUseViewController : PDViewController
<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
