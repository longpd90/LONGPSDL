//
//  PDServerJoinPlan.h
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/18/14.
//
//

#import "PDServerExchange.h"
#import "PDPlan.h"


@interface PDServerJoinPlan : PDServerExchange

- (void)joinUnjoinPlan:(PDPlan *)plan;

@end
