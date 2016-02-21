//
//  PDPhotosTableView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 26/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDItemsTableView.h"
#import "PDPhotoTileCell.h"
#import "PDPhotoListCell.h"
#import "Globals.h"

@interface PDPhotosTableView : PDItemsTableView
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <PDPhotoViewDelegate> photoViewDelegate;
- (UIImageView *)photoImageViewForPhoto:(PDPhoto *)photo;
- (void)scrollToPhoto:(PDPhoto *)photo animated:(BOOL)animated;
- (void)pinchGesture:(UIPinchGestureRecognizer *)sender;

@end
