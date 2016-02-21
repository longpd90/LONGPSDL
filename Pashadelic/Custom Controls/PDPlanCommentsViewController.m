//
//  PDPlanCommentsViewController.m
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/20/14.
//
//

#import "PDPlanCommentsViewController.h"
#import "PDServerEditComment.h"

@interface PDPlanCommentsViewController ()

@end

@implementation PDPlanCommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.plan) {
        self.plan = self.plan;
    }
    PDCommentsTableView *commentsTableView = (PDCommentsTableView *)self.itemsTableView;
    commentsTableView.canReply = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setPlan:(PDPlan *)newPlan
{
	_plan = newPlan;
	
	if (self.isViewLoaded) {
		[self refetchData];
		[self resetView];
	}
}


- (void)fetchData
{
    [super fetchData];
	PDServerCommentsLoader *commentsLoader = [[PDServerCommentsLoader alloc] initWithDelegate:self];
	self.serverExchange = commentsLoader;
	[commentsLoader loadcommentsForPlan:_plan page:self.currentPage];
}
- (BOOL)validateData
{
	if (self.commentTextView.text.length == 0) {
		[UIAlertView showAlertWithTitle:nil message:NSLocalizedString(@"Please enter comment text", nil)];
		return NO;
	}
	
	return YES;
}

- (IBAction)sentComment:(id)sender {
    if (![self validateData]) return;
	
	[kPDAppDelegate showWaitingSpinner];
    if (self.replyComment.identifier) {
        if (self.replyComment.user.identifier == kPDUserID) {
            PDServerEditComment *serverEditComment = [[PDServerEditComment alloc] initWithDelegate:self];
            [serverEditComment editCommentPlan:_plan comment:self.replyComment text:self.commentTextView.text];
        }
    }
    else {
        PDServerComment *serverComment = [[PDServerComment alloc] initWithDelegate:self];
        [serverComment commentPlan:_plan text:self.commentTextView.text];
    }
	
    
}

#pragma mark - ServerExchangeDelegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
    [kPDAppDelegate hideWaitingSpinner];
	self.loading = NO;
	if ([serverExchange isKindOfClass:[PDServerCommentsLoader class]]) {
		self.totalPages = [result intForKey:@"total_pages"];
		self.items = [serverExchange loadCommentsFromArray:result[@"comments"]];
		_plan.commentsCount = [result intForKey:@"total_count"];
        if (_plan.commentsCount != self.items.count) {
            _plan.commentsCount = self.items.count;
            if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCommentCount)]) {
                [self.delegate refreshCommentCount];
            }
        }
        
		for (PDComment *comment in self.items) {
			comment.plan = _plan;
		}
	} else if ([serverExchange isKindOfClass:[PDServerComment class]]) {
		[kPDAppDelegate hideWaitingSpinner];
		[self.commentTextView resignFirstResponder];
		PDComment *comment = [[PDComment alloc] init];
		comment.plan = _plan;
		[comment loadFullDataFromDictionary:[result objectForKey:@"comment"]];
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
		[array insertObject:comment atIndex:0];
		_plan.commentsCount++;
		self.items = array;
		
		self.commentTextView.text = @"";
		[self textViewDidChange:self.commentTextView];
		[self.commentTextView resignFirstResponder];
		
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:_plan forKey:@"object"];
		[userInfo setObject:@[
                              @{@"value" : _plan.comments, @"key" : @"comments"},
                              @{@"value" : [NSNumber numberWithInteger:_plan.commentsCount], @"key" : @"commentsCount"}] forKey:@"values"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
															object:self
														  userInfo:userInfo];
	} else if ([serverExchange isKindOfClass:[PDServerEditComment class]]) {
        [kPDAppDelegate hideWaitingSpinner];
		[self.commentTextView resignFirstResponder];
		PDComment *comment = [[PDComment alloc] init];
		[comment loadFullDataFromDictionary:[result objectForKey:@"comment"]];
		NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
		[array replaceObjectAtIndex:self.indexCell withObject:comment];
		self.items = array;
		self.commentTextView.text = @"";
		[self textViewDidChange:self.commentTextView];
		[self.commentTextView resignFirstResponder];
		
		NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:_plan forKey:@"object"];
		[userInfo setObject:@[
                              @{@"value" : _plan.comments, @"key" : @"comments"},
                              @{@"value" : [NSNumber numberWithInteger:_plan.commentsCount], @"key" : @"commentsCount"}] forKey:@"values"];
		[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
															object:self
														  userInfo:userInfo];
    } else if ([serverExchange isKindOfClass:[PDServerDeleteComment class]]) {
        [kPDAppDelegate hideWaitingSpinner];
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
        [array removeObject:self.deleteComment];
        self.items = array;
        _plan.commentsCount--;
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshCommentCount)]) {
            [self.delegate refreshCommentCount];
        }
    }
    
	[self refreshView];
	[self.commentsTableView scrollViewDidScroll:self.commentsTableView];
}

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

- (void)deleteCommentWithServer:(PDServerDeleteComment *)serverExchange comment:(PDComment *)comment
{
    [serverExchange deleteCommentInPlan:self.deleteComment];
}

@end
