//
//  PDServerJoinPlan.m
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/18/14.
//
//

#import "PDServerJoinPlan.h"

@implementation PDServerJoinPlan

- (void)joinUnjoinPlan:(PDPlan *)plan
{
    self.functionPath = [NSString stringWithFormat:@"plans/%ld/join_unjoin.json",(long)plan.identifier];
    [self requestToPostFunctionWithString:nil];
}

@end
