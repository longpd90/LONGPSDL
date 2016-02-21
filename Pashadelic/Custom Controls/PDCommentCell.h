//
//  PDReviewCell.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PDComment.h"
#import "PDGlobalFontLabel.h"
#import "PDGlobalFontButton.h"

#define kPDCommentCellTextFont				[UIFont fontWithName:PDGlobalNormalFontName size:13]

@protocol PDCommentCellDelegate <NSObject>
- (void)commentWasDeleted:(PDComment *)comment;
- (void)replyToUserComment:(PDComment *)comment atIndex:(int)intdex;
@end

@interface PDCommentCell : UITableViewCell

@property (weak, nonatomic) id <PDCommentCellDelegate> delegate;
@property (weak, nonatomic) PDComment *comment;
@property (weak, nonatomic) IBOutlet UIView *backgroundCell;
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *dateLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontLabel *commentTextLabel;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *deleteButton;
@property (weak, nonatomic) IBOutlet PDGlobalFontButton *replyButton;
@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lineHorizontalImageView;
@property (assign, nonatomic) BOOL canReply;
- (void)layoutCell;
- (void)disableDeteleAndReply;
- (void)disableReply;
- (void)disableDetele;
- (IBAction)avatarButtonTouch:(id)sender;
- (IBAction)deleteComment:(id)sender;
- (IBAction)replyComment:(id)sender;

@end
