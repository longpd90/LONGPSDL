//
//  PDServerPlanParticipantsLoader.m
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/22/14.
//
//

#import "PDServerPlanParticipantsLoader.h"

@implementation PDServerPlanParticipantsLoader

- (void)loadPlanParticipants:(PDPlan *)plan andPage:(NSInteger)page
{
    self.functionPath = [ NSString stringWithFormat:@"plans/%ld/participants.json",(long)plan.identifier];
    [self requestToGetFunctionWithString:nil];
}

@end
