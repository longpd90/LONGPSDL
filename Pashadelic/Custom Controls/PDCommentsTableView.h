//
//  PDCommentsTableView.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 31/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDItemsTableView.h"
#import "PDCommentCell.h"

@interface PDCommentsTableView : PDItemsTableView
<UITableViewDelegate, UITableViewDataSource>
{
	PDCommentCell *commentCellExample;
}

@property (weak, nonatomic) id <PDCommentCellDelegate> commentCellDelegate;
@property (assign, nonatomic) BOOL canReply;
@end
