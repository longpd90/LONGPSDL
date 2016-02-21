//
//  PDCommentsViewController.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 30/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDCommentsViewController.h"
#import "PDAppRater.h"

@interface PDCommentsViewController ()
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)initCommentsTable;
- (void)initCommentsTextView;
- (void)layoutAddCommentView;
- (BOOL)validateData;
@end

@implementation PDCommentsViewController
@synthesize addCommentView;
@synthesize tablePlaceholderView;
@synthesize commentTextView;
@synthesize sendButton, commentsTableView, photo, addCommentMode;
@synthesize replyComment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.items = [NSArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setLeftBarButtonToBackWithStyle:kPDLeftBarButtonStyleGrayAngle];
	[self initCommentsTextView];
	[self initCommentsTable];
	addCommentLinesNumber = 1;
	[sendButton setRedGradientButtonStyle];
	[sendButton setTitle:NSLocalizedString(@"post", nil) forState:UIControlStateNormal];
	sendButton.layer.cornerRadius = 3;
	sendButton.titleLabel.font = [UIFont fontWithName:PDGlobalNormalFontName size:15];
	sendButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
	if (self.photo) {
		self.photo = self.photo;
	}
}

- (void)viewDidUnload
{
	[self setCommentsTableView:nil];
    [self setCommentTextView:nil];
    [self setSendButton:nil];
	[self setTablePlaceholderView:nil];
	[self setAddCommentView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[super fullscreenMode:NO animated:NO];
	
	if (addCommentMode) {
		[commentTextView becomeFirstResponder];
	}
    
}

- (PDNavigationBarStyle)defaultNavigationBarStyle
{
	return PDNavigationBarStyleWhite;
}

#pragma mark - Private

- (void)layoutAddCommentView
{
	int height = 33;
	if (addCommentLinesNumber > 1) {
		height += commentTextView.font.lineHeight * (addCommentLinesNumber - 1);
	}
	
	commentTextView.height = height;
	int heightDelta = height + commentTextView.y * 2 - addCommentView.height;
	addCommentView.height += heightDelta;
	addCommentView.y -= heightDelta;
	sendButton.frame = CGRectWithY(sendButton.frame, addCommentView.height / 2 - sendButton.height / 2);
}

- (void)initCommentsTextView
{
    commentTextView.placeholder = NSLocalizedString(@"Add comment...", nil);
	if (replyComment.user.name) {
        commentTextView.text = [NSString stringWithFormat:@"@%@ ", replyComment.user.name];
    }
}

- (void)initCommentsTable
{
	commentsTableView = [[PDCommentsTableView alloc] initWithFrame:CGRectMake(5, 0, tablePlaceholderView.width - 10,tablePlaceholderView.height)];
    commentsTableView.tableHeaderView = self.topView;
	commentsTableView.commentCellDelegate = self;
	commentsTableView.itemsTableDelegate = self;
	[tablePlaceholderView addSubview:commentsTableView];
	self.itemsTableView = commentsTableView;
    [self.tablePlaceholderView bringSubviewToFront:self.addCommentView];
}

- (BOOL)validateData
{
	if (commentTextView.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter comment text", nil)];
		return NO;
	}
	
	return YES;
}


#pragma mark - Public

- (void)refreshView
{
	[super refreshView];
    if (self.items.count > 1) {
        self.title = NSLocalizedString(@"comments", nil);
    } else {
        self.title = NSLocalizedString(@"comment", nil);
    }
}

- (NSString *)pageName
{
	return @"Photo Comments";
}

- (void)fullscreenMode:(bool)fullscreenMode animated:(bool)animated
{
	[super fullscreenMode:fullscreenMode animated:animated];
	[self viewWillLayoutSubviews];
}

- (void)goBack:(id)sender
{
	[commentTextView resignFirstResponder];
	[super goBack:sender];
}

- (void)refreshViewMode
{
	
}

- (void)resetView
{
	commentTextView.text = @"";
	self.currentPage = 1;
	self.itemsTotalCount = 0;
	self.totalPages = 1;
	[self textViewDidChange:commentTextView];
	[commentTextView resignFirstResponder];
	[commentsTableView reloadData];
    self.title = NSLocalizedString(@"comments", nil);
}

- (void)setPhoto:(PDPhoto *)newPhoto
{
	photo = newPhoto;
	
	if (self.isViewLoaded) {
		[self refetchData];
		[self resetView];
	}
}

- (void)fetchData
{
	[super fetchData];
    self.loading = YES;
	PDServerCommentsLoader *commentsLoader = [[PDServerCommentsLoader alloc] initWithDelegate:self];
	self.serverExchange = commentsLoader;
	[commentsLoader loadCommentsForPhoto:photo page:self.currentPage];
}

- (IBAction)sendComment:(id)sender
{
	if (![self validateData]) return;
	
    [PDAppRater userDidSignificantEvent:NO];
	[kPDAppDelegate showWaitingSpinner];
    if (replyComment.user.identifier == kPDUserID) {
        [self trackEvent:@"Edit Comment"];
    } else {
        [self trackEvent:@"Comment"];
    }
	PDServerComment *serverComment = [[PDServerComment alloc] initWithDelegate:self];
	self.serverExchange = serverComment;
	if (replyComment.identifier) {
        if (replyComment.user.identifier == kPDUserID) {
            PDServerEditComment *serverEditComment = [[PDServerEditComment alloc] initWithDelegate:self];
            [serverEditComment editCommentPhoto:photo comment:replyComment text:commentTextView.text];
        } else {
            [serverComment commentPhoto:photo text:commentTextView.text replyUserId:replyComment.identifier];
        }
    }
    else {
        [serverComment commentPhoto:photo text:commentTextView.text];
    }
    replyComment = nil;
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[kPDAppDelegate hideWaitingSpinner];
	if ([serverExchange isKindOfClass:[PDServerComment class]]) {
		[super serverExchange:serverExchange didFailWithError:error];
		
	} else if ([serverExchange isKindOfClass:[PDServerComment class]]) {
		if (self.photo.comments.count == 0) {
			self.loading = NO;
		} else {
			[super serverExchange:serverExchange didFailWithError:error];
		}
	} else if ([serverExchange isKindOfClass:[PDServerDeleteComment class]]) {
        [[PDSingleErrorAlertView instance] showErrorMessage:error];
    }
}

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[super serverExchange:serverExchange didParseResult:result];
	if ([serverExchange isKindOfClass:[PDServerCommentsLoader class]]) {
		self.totalPages = [result intForKey:@"total_pages"];
		self.items = [serverExchange loadCommentsFromArray:result[@"comments"]];
		self.photo.commentsCount = [result intForKey:@"total_count"];
        if (self.photo.commentsCount != self.items.count) {
            self.photo.commentsCount = self.items.count;
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCommentCount)]) {
                [self.delegate refreshCommentCount];
            }
        }
        
		for (PDComment *comment in self.items) {
			comment.photo = photo;
		}
	} else if ([serverExchange isKindOfClass:[PDServerComment class]]) {
		[kPDAppDelegate hideWaitingSpinner];
		[commentTextView resignFirstResponder];
		PDComment *comment = [[PDComment alloc] init];
		comment.photo = photo;
		[comment loadFullDataFromDictionary:[result objectForKey:@"comment"]];
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
		[array insertObject:comment atIndex:0];
		photo.commentsCount++;
		self.items = array;
		
		commentTextView.text = @"";
		[self textViewDidChange:commentTextView];
		[commentTextView resignFirstResponder];
		
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:photo forKey:@"object"];
		[userInfo setObject:@[
                              @{@"value" : photo.comments, @"key" : @"comments"},
                              @{@"value" : [NSNumber numberWithInteger:photo.commentsCount], @"key" : @"commentsCount"}] forKey:@"values"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
															object:self
														  userInfo:userInfo];
	} else if ([serverExchange isKindOfClass:[PDServerEditComment class]]) {
        [kPDAppDelegate hideWaitingSpinner];
		[commentTextView resignFirstResponder];
		PDComment *comment = [[PDComment alloc] init];
		[comment loadFullDataFromDictionary:[result objectForKey:@"comment"]];
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
		[array replaceObjectAtIndex:_indexCell withObject:comment];
		self.items = array;
		commentTextView.text = @"";
		[self textViewDidChange:commentTextView];
		[commentTextView resignFirstResponder];
		
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:photo forKey:@"object"];
		[userInfo setObject:@[
                              @{@"value" : photo.comments, @"key" : @"comments"},
                              @{@"value" : [NSNumber numberWithInteger:photo.commentsCount], @"key" : @"commentsCount"}] forKey:@"values"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
															object:self
														  userInfo:userInfo];
    } else if ([serverExchange isKindOfClass:[PDServerDeleteComment class]]) {
        [kPDAppDelegate hideWaitingSpinner];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
        [array removeObject:_deleteComment];
        self.items = array;
        photo.commentsCount--;
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCommentCount)]) {
            [self.delegate refreshCommentCount];
        }
    }
    
	[self refreshView];
	[commentsTableView scrollViewDidScroll:commentsTableView];
}


#pragma mark - Text view delegate

- (void)textViewDidChange:(UITextView *)textView
{
	int linesNumber = textView.contentSize.height / textView.font.lineHeight;
	if (linesNumber > 3) {
		linesNumber = 3;
	}
	
	if (addCommentLinesNumber != linesNumber) {
		addCommentLinesNumber = linesNumber;
		[self layoutAddCommentView];
	}
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
	CGRect frame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	double duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	self.keyboardShown = YES;
	[UIView animateWithDuration:duration animations:^{
		self.addCommentView.y = self.view.height - frame.size.height - self.addCommentView.height;
	}];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
	double duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	self.keyboardShown = NO;
	
	[UIView animateWithDuration:duration animations:^{
		self.addCommentView.y = self.view.height - self.addCommentView.height;
	}];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == alertView.cancelButtonIndex) return;
    [kPDAppDelegate showWaitingSpinner];
    PDServerDeleteComment *deleteComment = [[PDServerDeleteComment alloc] initWithDelegate:self];
	[self deleteCommentWithServer:deleteComment comment:_deleteComment];
    
}

- (void)deleteCommentWithServer:(PDServerDeleteComment *)serverExchange comment:(PDComment *)comment
{
    [serverExchange deleteComment:_deleteComment];
}

#pragma mark - Comments cell delegate

- (void)commentWasDeleted:(PDComment *)comment
{
    _deleteComment = comment;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Do you really want to delete your comment?", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
	[alertView show];
}

- (void)replyToUserComment:(PDComment *)comment atIndex:(int)intdex
{
    _indexCell = intdex;
    replyComment = comment;
    [commentTextView becomeFirstResponder];
    if (comment.user.identifier == kPDUserID) {
        commentTextView.text = [NSString stringWithFormat:@"%@ ", replyComment.comment];
    } else {
        commentTextView.text = [NSString stringWithFormat:@"@%@ ", replyComment.user.name];
    }
}

@end
