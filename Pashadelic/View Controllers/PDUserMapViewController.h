//
//  PDUserMapViewController.h
//  Pashadelic
//
//  Created by LongPD on 12/20/13.
//
//

#import "PDViewController.h"
#import "PDPhotoClustersMapView.h"
#import "PDPhotosMapView.h"
#import "KPTreeController.h"
#import "PDPhotosTableView.h"
#import "PDOverlayView.h"
#import "PDClusterMapViewController.h"

@interface PDUserMapViewController : PDClusterMapViewController <MGServerExchangeDelegate>

@property (weak, nonatomic) PDUser *user;

- (void)setInfoUser:(PDUser *)theUser;

@end
