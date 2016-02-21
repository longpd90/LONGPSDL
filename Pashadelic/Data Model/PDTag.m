//
//  PDTag.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 22.05.13.
//
//

#import "PDTag.h"

@implementation PDTag

- (NSString *)followItemName
{
	return [NSString stringWithFormat:@"tags/follow_unfollow.json?tag=%@", self.name];
}

- (BOOL)isEqual:(id)object
{
	if (![object isKindOfClass:[PDTag class]]) return NO;
	
	return [self.name isEqual:[object name]];
}

@end
