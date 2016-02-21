//
//  PDTagsTableView.h
//  Pashadelic
//
//  Created by Linh on 2/18/13.
//
//

#import "PDItemsTableView.h"
#import "PDTagCell.h"
#import <UIKit/UIKit.h>

@interface PDTagsTableView : PDItemsTableView
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <PDTagCellDelegate> tagCellDelegate;

@end
