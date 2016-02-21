//
//  PDServerPlanParticipantsLoader.h
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/22/14.
//
//

#import "PDServerExchange.h"
#import "PDPlan.h"

@interface PDServerPlanParticipantsLoader : PDServerExchange

- (void)loadPlanParticipants:(PDPlan *)plan andPage:(NSInteger)page;

@end
