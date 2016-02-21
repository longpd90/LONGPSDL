//
//  PDServerEditComment.m
//  Pashadelic
//
//  Created by LongPD on 6/12/14.
//
//

#import "PDServerEditComment.h"

@implementation PDServerEditComment
- (void)editCommentPhoto:(PDPhoto *)photo comment:(PDComment *)comment text:(NSString *)text
{
    self.functionPath = [NSString stringWithFormat:@"photos/%ld/comments/%ld.json", (long)photo.identifier,(long)comment.identifier];
    text = [text urlEncodeUsingEncoding:self.dataEncoding];
    [self requestToPutFunctionWithString:[NSString stringWithFormat:@"comment=%@", text]];
}

- (void)editCommentPlan:(PDPlan *)plan comment:(PDComment *)comment text:(NSString *)text
{
    self.functionPath = [NSString stringWithFormat:@"plans/%ld/comments/%ld.json", (long)plan.identifier,(long)comment.identifier];
    text = [text urlEncodeUsingEncoding:self.dataEncoding];
    [self requestToPutFunctionWithString:[NSString stringWithFormat:@"comment=%@", text]];
}
@end
