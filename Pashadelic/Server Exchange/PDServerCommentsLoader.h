//
//  PDServerCommentsLoader.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 30/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PDServerExchange.h"
#import "PDPlan.h"

@interface PDServerCommentsLoader : PDServerExchange

- (void)loadCommentsForPhoto:(PDPhoto *)photo page:(NSUInteger)page;

- (void)loadcommentsForPlan:(PDPlan *)plan page:(NSUInteger)page;

@end
