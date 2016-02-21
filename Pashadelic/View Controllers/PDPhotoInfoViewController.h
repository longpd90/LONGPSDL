//
//  PDPhotoInfoViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.06.13.
//
//

#import "PDViewController.h"
#import "PDServerDeletePhoto.h"
#import "PDServerPhotoReport.h"

@class PDPhotoSpotViewController;

@interface PDPhotoInfoViewController : PDViewController
<MGServerExchangeDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollBackgroundView;
@property (strong, nonatomic) PDPhotoSpotViewController *ownerViewController;
@property (strong, nonatomic) id serverExchange;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) PDPhoto *photo;
@property (assign, nonatomic) int tipsCount;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *sourceButton;
@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (weak, nonatomic) IBOutlet UIView *viewForReportButton;
@property (weak, nonatomic) IBOutlet UIView *viewForDeleteButton;

- (IBAction)closeView:(id)sender;
- (IBAction)sourceButtonTouch:(id)sender;
- (IBAction)report:(id)sender;

@end
