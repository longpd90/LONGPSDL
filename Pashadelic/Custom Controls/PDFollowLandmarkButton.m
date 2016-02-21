//
//  PDFollowLandmarkButton.m
//  Pashadelic
//
//  Created by LongPD on 1/8/14.
//
//

#import "PDFollowLandmarkButton.h"

@implementation PDFollowLandmarkButton

- (void)followButtonTouch
{
	[self showActivityWithStyle:UIActivityIndicatorViewStyleWhiteLarge];
	serverFollowItem = [[PDServerFollowItem alloc] initWithDelegate:self];
	if (self.item.followStatus) {
        [(PDViewController *) self.firstViewController trackEvent:[NSString stringWithFormat:@"Unfollow item %ld", (long)self.item.identifier]];
		[serverFollowItem unfollowItem:self.item];
	} else {
        [(PDViewController *) self.firstViewController trackEvent:[NSString stringWithFormat:@"Follow item %ld", (long)self.item.identifier]];
		[serverFollowItem followItem:self.item];
	}
}

@end
