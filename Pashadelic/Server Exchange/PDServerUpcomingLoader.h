//
//  PDServerUpcomingLoader.h
//  Pashadelic
//
//  Created by TungNT2 on 6/5/14.
//
//

#import "PDServerExchange.h"

@interface PDServerUpcomingLoader : PDServerExchange
- (void)loadUpcomingPage:(NSUInteger)page;
- (void)loadUpcomingPage:(NSUInteger)page firstPhotoId:(NSUInteger)photoId;
@end
