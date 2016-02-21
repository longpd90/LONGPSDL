//
//  PDCommentsViewController.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 30/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDTableViewController.h"
#import "PDServerComment.h"
#import "PDServerCommentsLoader.h"
#import "SSTextView.h"
#import "PDCommentsTableView.h"
#import "PDCommentCell.h"
#import "PDServerEditComment.h"
#import "PDServerDeleteComment.h"

@protocol PDCommentsViewControllerDelegate <NSObject>
- (void)refreshCommentCount;
@end

@interface PDCommentsViewController : PDTableViewController
<UITextViewDelegate, PDCommentCellDelegate>
{
	int addCommentLinesNumber;
}

@property (assign, nonatomic) int indexCell;
@property (nonatomic) bool addCommentMode;
@property (weak, nonatomic) PDPhoto *photo;
@property (weak, nonatomic) IBOutlet UIView *tablePlaceholderView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet SSTextView *commentTextView;
@property (weak, nonatomic) IBOutlet PDGradientButton *sendButton;
@property (strong, nonatomic) PDCommentsTableView *commentsTableView;
@property (strong, nonatomic) IBOutlet UIView *addCommentView;
@property (nonatomic, retain) PDComment *replyComment;
@property (strong, nonatomic) PDComment *deleteComment;
@property (weak, nonatomic) id<PDCommentsViewControllerDelegate> delegate;

- (IBAction)sendComment:(id)sender;
- (void)resetView;
- (void)deleteCommentWithServer:(PDServerDeleteComment *)serverExchange comment:(PDComment *)comment;

@end
