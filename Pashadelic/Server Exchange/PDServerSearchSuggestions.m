//
//  PDServerSearchSuggestions.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 29.03.13.
//
//

#import "PDServerSearchSuggestions.h"

@implementation PDServerSearchSuggestions

- (void)searchSuggestions:(NSString *)text
{
	self.functionPath = @"search/term.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?query=%@", text]];
}

- (void)searchSuggestionsTags:(NSString *)text
{
    self.functionPath = @"photos/recommended_tag.json";
    [self requestToGetFunctionWithString:[NSString stringWithFormat:@"?tag=%@", text]];
}

@end
