//
//  PDServerPhotographers.h
//  Pashadelic
//
//  Created by LTT on 6/16/14.
//
//

#import "PDServerExchange.h"
#import "PDLocation.h"
@interface PDServerGetPhotographers : PDServerExchange

- (void)getPhotographersInLocation:(PDLocation *)location andPage:(NSInteger)page;

@end
