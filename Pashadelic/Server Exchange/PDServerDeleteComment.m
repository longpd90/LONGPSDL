//
//  PDServerDeleteComment.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 6/10/12.
//
//

#import "PDServerDeleteComment.h"


@implementation PDServerDeleteComment

- (void)deleteComment:(PDComment *)comment
{
	self.functionPath = [NSString stringWithFormat:@"photos/%zd/comments/%zd.json",
						 comment.photo.identifier, comment.identifier];
	[self requestToDeleteFunction];
}

- (void)deleteCommentInPlan:(PDComment *)comment
{
    self.functionPath = [NSString stringWithFormat:@"plans/%zd/comments/%zd.json",
						 comment.plan.identifier, comment.identifier];
	[self requestToDeleteFunction];
}

@end
