//
//  PDNotificationsViewController.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 20.04.13.
//
//

#import "PDPhotoTableViewController.h"
#import "PDNotificationsTableView.h"
#import "PDServerNotificationsLoader.h"
#import "PDUserViewController.h"

@interface PDNotificationsViewController : PDPhotoTableViewController<PDPlanDelegate>

@property (strong, nonatomic) PDNotificationsTableView *notificationTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleFirstLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationsCountLabel;
@property (strong, nonatomic) PDUserViewController *userViewController;
@property (assign, nonatomic) NSInteger unreadItemsCount;
@property (strong, nonatomic) PDPhoto *selectedPhoto;

@end
