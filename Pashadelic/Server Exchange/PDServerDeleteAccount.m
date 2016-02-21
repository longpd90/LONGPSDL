//
//  PDDeleteAccount.m
//  Pashadelic
//
//  Created by LongPD on 12/20/13.
//
//

#import "PDServerDeleteAccount.h"
#import "PDFacebookExchange.h"

@implementation PDServerDeleteAccount

- (void)deleteAccountWithId:(NSInteger)userId
{
    [kPDUserDefaults setObject:@"" forKey:kPDAuthTokenKey];
	[kPDUserDefaults setInteger:0 forKey:kPDUserIDKey];
	kPDAppDelegate.userProfile = nil;
	[PDFacebookExchange logout];
    
    self.functionPath = [NSString stringWithFormat:@"users/%ld.json", (long)userId];
    [self requestToDeleteFunction];
}

@end
