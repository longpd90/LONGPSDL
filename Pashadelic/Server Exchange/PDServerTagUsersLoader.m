//
//  PDServerTagUsersLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 25.04.13.
//
//

#import "PDServerTagUsersLoader.h"

@implementation PDServerTagUsersLoader

- (void)loadTagUsers:(PDTag *)tag page:(NSUInteger)page
{
	self.functionPath = @"tags/followers.json";
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?tag=%@&page=%zd", tag.name, page]];
}

@end
