//
//  PDProfileNotificationsViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 05.01.13.
//
//

#import "PDViewController.h"
#import "PDServerNotificationSettings.h"
#import "PDSwitch.h"

enum kNotificationSections {
	kNotificationSectionFollow = 0,
	kNotificationSectionPin,
	kNotificationSectionLike,
	kNotificationSectionComment,
	kNotificationSectionsCount
};


@interface PDProfileNotificationsViewController : PDViewController
<MGServerExchangeDelegate, UITableViewDataSource, UITableViewDelegate>
{
	BOOL notificationSettings[4][2];
}
@property (strong, nonatomic) IBOutlet UIView *finishView;
@property (strong, nonatomic) IBOutlet UITableView *settingsTable;
@property (weak, nonatomic) IBOutlet PDGradientButton *finishButton;

- (IBAction)finish:(id)sender;
- (IBAction)switchValueChanged:(id)sender;

@end
