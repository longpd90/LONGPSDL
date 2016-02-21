//
//  PDFeedTableViewCell.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.11.12.
//
//

#import "PDNotificationItem.h"
#import "PDServerCheckNotificaiton.h"

@interface PDNotificationTableViewCell : UITableViewCell
<MGServerExchangeDelegate>
{
	PDServerCheckNotificaiton *serverExchange;
}

@property (strong, nonatomic) PDUser *user;
@property (strong, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) PDNotificationItem *notificationItem;
@property (weak, nonatomic) IBOutlet UIButton *targetButton;
@property (weak, nonatomic) IBOutlet UIImageView *targetIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *sourceButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) id <PDPhotoViewDelegate> delegate;
@property (weak, nonatomic) id <PDPlanDelegate> planDelegate;
- (IBAction)showTarget:(id)sender;
- (IBAction)showSource:(id)sender;

@end
