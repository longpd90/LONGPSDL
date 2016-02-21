//
//  PDServerPlansLoader.h
//  Pashadelic
//
//  Created by LongPD on 11/14/13.
//
//

#import "PDServerExchange.h"

@interface PDServerPlansLoader : PDServerExchange
- (void)loadPlansCount;
- (void)loadPlansUpcoming:(NSInteger)page;
- (void)loadPlansAll:(NSInteger)page;
@end
