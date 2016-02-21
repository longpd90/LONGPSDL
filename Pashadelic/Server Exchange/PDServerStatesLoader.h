//
//  PDServerStatesLoader.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.12.12.
//
//

#import "PDServerExchange.h"

@interface PDServerStatesLoader : PDServerExchange

- (void)loadStatesForCountryWithID:(NSInteger)identifier;

@end
