//
//  PDServerProfileInfoUpload.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 16/10/12.
//
//

#import "PDServerProfileInfoUpload.h"
#import "PDUserProfile.h"

@implementation PDServerProfileInfoUpload

- (void)uploadProfileInfo:(PDUserProfile *)profile
{
	self.functionPath = [NSString stringWithFormat:@"users/%zd.json", profile.identifier];
	NSString *parameters = [NSString stringWithFormat:
							@"[user]email=%@&[user]first_name=%@&[user]last_name=%@&[user]description=%@&[user]phone=%@&[user]sex=%ld&[user][profile_attributes]country_id=%zd&[user][profile_attributes]state_id=%zd&[user][profile_attributes]location=%@&[user]photo_level=%zd&[user]interests=%@",
							profile.email, profile.firstName, profile.lastName, profile.description, profile.phone,
							(long)profile.sex, profile.countryID, profile.stateID, profile.city, profile.level,
							profile.interests, nil];
	[self requestToPutFunctionWithString:parameters];
}

@end
