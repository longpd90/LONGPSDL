//
//  PDServerComment.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
#import "PDComment.h"
#import "PDPlan.h"
@interface PDServerComment : PDServerExchange

- (void)commentPhoto:(PDPhoto *)photo text:(NSString *)text;
- (void)commentPhoto:(PDPhoto *)photo text:(NSString *)text replyUserId:(NSInteger)userId;

- (void)commentPlan:(PDPlan *)plan text:(NSString *)text;

@end
