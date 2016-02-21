//
//  PDServerUserFollowings.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.04.13.
//
//

#import "PDServerUserFollowings.h"

@implementation PDServerUserFollowings

- (void)loadUserFollowings:(PDUser *)user page:(NSInteger)page
{
	self.functionPath = [NSString stringWithFormat:@"users/%zd/user_relations/following_users.json", user.identifier];
	[self requestToGetFunctionWithString:[NSString stringWithFormat:@"?page=%zd", page]];
}

@end
