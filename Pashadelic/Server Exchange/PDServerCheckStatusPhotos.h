//
//  PDServerCheckStatusPhotos.h
//  Pashadelic
//
//  Created by LongPD on 8/1/14.
//
//

#import "PDServerExchange.h"

@interface PDServerCheckStatusPhotos : PDServerExchange

- (void)checkStatusListPhotos:(NSArray *)photos;

@end
