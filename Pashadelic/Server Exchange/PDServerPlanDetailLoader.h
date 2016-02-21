//
//  PDServerPlanDetail.h
//  Pashadelic
//
//  Created by Nguyen Huu Anh on 8/19/14.
//
//

#import "PDServerExchange.h"

@interface PDServerPlanDetailLoader : PDServerExchange
- (void)loadPlanDetail:(NSInteger)planID;
@end
