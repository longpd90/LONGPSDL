//
//  PDServerEditComment.h
//  Pashadelic
//
//  Created by LongPD on 6/12/14.
//
//

#import "PDServerExchange.h"
#import "PDComment.h"
#import "PDPlan.h"

@interface PDServerEditComment : PDServerExchange

- (void)editCommentPhoto:(PDPhoto *)photo comment:(PDComment *)comment text:(NSString *)text;
- (void)editCommentPlan:(PDPlan *)plan comment:(PDComment *)comment text:(NSString *)text;

@end
