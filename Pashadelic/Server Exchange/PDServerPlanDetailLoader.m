//
//  PDServerPlanDetail.m
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/19/14.
//
//

#import "PDServerPlanDetailLoader.h"

@implementation PDServerPlanDetailLoader

- (void)loadPlanDetail:(NSInteger)planID
{
    self.functionPath = [NSString stringWithFormat:@"plans/%ld.json", (long)planID];
    [self requestToGetFunctionWithString:nil];
}

@end
