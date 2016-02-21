//
//  PDServerProfileEditInfoLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 16/10/12.
//
//

#import "PDServerExchange.h"

@interface PDServerProfileEditInfoLoader : PDServerExchange

- (void)loadProfileInfo:(NSInteger)profileID;

@end
