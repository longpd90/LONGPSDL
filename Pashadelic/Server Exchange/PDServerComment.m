//
//  PDServerComment.m
//  Pashadelic
//
//  Created by Виталий Гоженко on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerComment.h"

@implementation PDServerComment

- (void)commentPhoto:(PDPhoto *)photo text:(NSString *)text
{
	self.functionPath = [NSString stringWithFormat:@"photos/%ld/comments.json", (long)photo.identifier];

    text = [text urlEncodeUsingEncoding:self.dataEncoding];
    [self requestToPostFunctionWithString:[NSString stringWithFormat:@"comment=%@", text]];
}

- (void)commentPhoto:(PDPhoto *)photo text:(NSString *)text replyUserId:(NSInteger)userId
{
    self.functionPath = [NSString stringWithFormat:@"photos/%ld/comments.json", (long)photo.identifier];
    
    text = [text urlEncodeUsingEncoding:self.dataEncoding];
    if (userId) {
        [self requestToPostFunctionWithString:[NSString stringWithFormat:@"comment=%@&reply_to_id=%ld", text, (long)userId]];
    } else {
        [self requestToPostFunctionWithString:[NSString stringWithFormat:@"comment=%@", text]];
    }
}

- (void)commentPlan:(PDPlan *)plan text:(NSString *)text
{
    self.functionPath = [NSString stringWithFormat:@"plans/%ld/comments.json",
                         (long)plan.identifier];
    text = [text urlEncodeUsingEncoding:self.dataEncoding];
    [self requestToPostFunctionWithString:[NSString stringWithFormat:@"comment=%@", text]];
}

@end
