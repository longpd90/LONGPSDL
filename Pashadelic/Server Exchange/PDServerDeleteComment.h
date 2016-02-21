//
//  PDServerDeleteComment.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 6/10/12.
//
//

#import <UIKit/UIKit.h>
#import "PDServerExchange.h"
#import "PDComment.h"
#import "PDPlan.h"
@interface PDServerDeleteComment : PDServerExchange

- (void)deleteComment:(PDComment *)comment;
- (void)deleteCommentInPlan:(PDComment *)comment;

@end
