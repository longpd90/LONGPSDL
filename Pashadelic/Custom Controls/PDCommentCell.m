//
//  PDReviewCell.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 11/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDCommentCell.h"

#define kCommentTextLabelWidth		225
#define kCommentTextLabelY			5
#define kCommentTextLabelMinHeight	36
#define kCommentTextFramePadding	5
#define kFooterViewHeight			22
#define kUserNameLabelMaxWith       50

@interface PDCommentCell (Private)

- (NSString *)getReplyCommentFromNewComment:(NSString *)newComment;

@end

@implementation PDCommentCell
@synthesize comment;
@synthesize dateLabel;
@synthesize usernameLabel;
@synthesize commentTextLabel;
@synthesize deleteButton;
@synthesize delegate;
@synthesize avatarButton;
@synthesize replyButton;
@synthesize lineImageView;

- (void)awakeFromNib
{

	self.avatarButton.layer.cornerRadius = 3;
    self.canReply = YES;
    [replyButton setTitle:NSLocalizedString(@"reply", nil) forState:UIControlStateNormal];
    [replyButton setTitle:NSLocalizedString(@"edit", nil) forState:UIControlStateSelected];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && [self respondsToSelector:@selector(separatorInset)]) {
        self.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, self.bounds.size.width);
    }
}

- (void)setComment:(PDComment *)newComment
{
	comment = newComment;
	[self.avatarButton setImage:nil forState:UIControlStateNormal];
	[self.avatarButton sd_setImageWithURL:comment.user.thumbnailURL forState:UIControlStateNormal];
	
	
	NSInteger newWith = [comment.user.name sizeWithFont:kPDCommentCellTextFont constrainedToSize:CGSizeMake(9999, 15)
																	lineBreakMode:NSLineBreakByWordWrapping].width;
	if (newWith > kUserNameLabelMaxWith) {
		newWith = kUserNameLabelMaxWith;
	}
	usernameLabel.frame = CGRectWithWidth(usernameLabel.frame, newWith);
	usernameLabel.text = comment.user.name;
	
	dateLabel.text = [NSString stringWithFormat:@"%@", [comment.date intervalInStringSinceDate:[NSDate date]]];
	
	commentTextLabel.numberOfLines = 0;
    [self.replyButton setTitle:NSLocalizedString(@"reply", nil) forState:UIControlStateNormal];
    [self.deleteButton setTitle:NSLocalizedString(@"delete", nil) forState:UIControlStateNormal];
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName: [UIColor grayColor]};
    [self.replyButton setFontAwesomeIconForImage:[FAKFontAwesome replyIconWithSize:8] forState:UIControlStateNormal attributes:grayColorAttribute];
    [self.replyButton setFontAwesomeIconForImage:[FAKFontAwesome pencilIconWithSize:8] forState:UIControlStateSelected attributes:grayColorAttribute];
    [self.deleteButton setFontAwesomeIconForImage:[FAKFontAwesome trashOIconWithSize:11] forState:UIControlStateNormal attributes:grayColorAttribute];
	if (comment.user.identifier == kPDUserID) {
		deleteButton.hidden = NO;
        lineImageView.hidden = NO;
        replyButton.hidden = NO;
		replyButton.selected = YES;
	} else {
        lineImageView.hidden = YES;
		deleteButton.hidden = YES;
        if (!self.canReply) {
            self.replyButton.hidden = YES;
        }
		replyButton.selected = NO;
	}
	
	commentTextLabel.text = comment.comment;
	commentTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	[self layoutCell];
}

- (NSString *)getReplyCommentFromNewComment:(NSString *)newComment
{
	NSError *error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s+" options:NSRegularExpressionCaseInsensitive error:&error];
	NSTextCheckingResult *match = [regex firstMatchInString:newComment options:0 range:NSMakeRange(0, newComment.length)];
	return [newComment stringByReplacingCharactersInRange:match.range withString:@"\n"];
}

- (void)layoutCell
{
	CGFloat newHeight = [commentTextLabel sizeThatFits:CGSizeMake(commentTextLabel.bounds.size.width, MAXFLOAT)].height;
	
	commentTextLabel.height = (newHeight < 15) ? 15 : newHeight + 6;
    lineImageView.y = commentTextLabel.bottomYPoint;
    deleteButton.y = commentTextLabel.bottomYPoint;
    replyButton.y = commentTextLabel.bottomYPoint;
    _lineHorizontalImageView.y = deleteButton.bottomYPoint;
    _backgroundCell.height = _lineHorizontalImageView.bottomYPoint;
 	[usernameLabel sizeToFit];
}

- (void)disableDeteleAndReply
{
    self.deleteButton.hidden = YES;
    self.replyButton.hidden = YES;
    self.lineImageView.hidden = YES;
    _backgroundCell.height = _backgroundCell.height - 16;
    self.lineHorizontalImageView.y = _backgroundCell.bottomYPoint;
}

- (void)disableDetele
{
    self.deleteButton.hidden = YES;
    self.lineImageView.hidden = YES;
}

- (void)disableReply
{
    self.canReply = NO;
}

- (IBAction)avatarButtonTouch:(id)sender
{
	[comment.user itemWasSelected];
}

- (IBAction)deleteComment:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(commentWasDeleted:)]) {
		[delegate commentWasDeleted:comment];
	}
}

- (IBAction)replyComment:(id)sender
{
	if (delegate && [delegate respondsToSelector:@selector(replyToUserComment:atIndex:)]) {
		[delegate replyToUserComment:comment atIndex:self.tag];
	}
}


@end
