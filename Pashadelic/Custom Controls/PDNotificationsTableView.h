//
//  PDFeedTableView.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.11.12.
//
//

#import "PDItemsTableView.h"
#import "PDNotificationTableViewCell.h"

@interface PDNotificationsTableView : PDItemsTableView

@property (weak, nonatomic) id <PDPhotoViewDelegate> photoViewDelegate;
@property (weak, nonatomic) id <PDPlanDelegate> planViewDelegate;
@end
