//
//  PDServerProfileEditInfoLoader.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 16/10/12.
//
//

#import "PDServerProfileEditInfoLoader.h"

@implementation PDServerProfileEditInfoLoader

- (void)loadProfileInfo:(NSInteger)profileID
{
	self.functionPath = [NSString stringWithFormat:@"/users/%zd/edit.json", profileID];
	[self requestToGetFunctionWithString:nil];
}

@end
