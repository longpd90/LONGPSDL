//
//  PDServerUserPhotoMapLoader.h
//  Pashadelic
//
//  Created by LongPD on 12/20/13.
//
//

#import "PDServerExchange.h"

@interface PDServerUserPhotoMapLoader : PDServerExchange
- (void)loadPhotoOfUser:(PDUser *)user;
@end
