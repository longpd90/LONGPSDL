//
//  PDServerEditPhoto.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 3/10/12.
//
//

#import "PDServerExchange.h"


@interface PDServerEditPhoto : PDServerExchange

- (void)uploadPhotoData:(PDPhoto *)photo title:(NSString *)title description:(NSString *)description tags:(NSString *)tags;

@end
