//
//  PDServerDeactiveAccountFeedback.m
//  Pashadelic
//
//  Created by TungNT2 on 12/24/13.
//
//

#import "PDServerDeactiveAccountFeedback.h"

@implementation PDServerDeactiveAccountFeedback

- (void)sendDeactiveAccountFeedbackWithBody:(NSString *)body
{
    self.functionPath = @"users/deactive_feed_back.json";
    body = [body urlEncodeUsingEncoding:self.dataEncoding];
    [self requestToPostFunctionWithString:[NSString stringWithFormat:@"body=%@", body]];
}

@end
