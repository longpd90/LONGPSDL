//
//  PDServerSearchSuggestions.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 29.03.13.
//
//

#import "PDServerExchange.h"

@interface PDServerSearchSuggestions : PDServerExchange

- (void)searchSuggestions:(NSString *)text;
- (void)searchSuggestionsTags:(NSString *)text;
@end
