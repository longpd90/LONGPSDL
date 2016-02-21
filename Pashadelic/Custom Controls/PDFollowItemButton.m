//
//  PDFollowUserButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 18.11.12.
//
//

#import "PDFollowItemButton.h"
#import "PDUserProfile.h"
#import "PDViewController.h"
#import "UIImage+Extra.h"

@implementation PDFollowItemButton

- (void)awakeFromNib
{
	[self initialize];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize
{
	self.backgroundColor = [UIColor clearColor];
	self.layer.cornerRadius = 3;
	self.clipsToBounds = YES;
	if (![self imageForState:UIControlStateNormal]) {
		UIImage *backgroundImageFollow = [[[UIImage alloc] init] imageWithColor:kPDGlobalLightGrayColor];
		UIImage *backgroundImageFollowing = [[[UIImage alloc] init] imageWithColor:kPDGlobalGrayColor];
		[self setBackgroundImage:backgroundImageFollow forState:UIControlStateNormal];
		[self setBackgroundImage:backgroundImageFollowing forState:UIControlStateSelected];
		[self setTitleColor:kPDGlobalGrayColor forState:UIControlStateNormal];
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
		[self setTitle:NSLocalizedString(@"+ follow", nil) forState:UIControlStateNormal];
		[self setTitle:NSLocalizedString(@"following", nil) forState:UIControlStateSelected];
		[self setTitle:NSLocalizedString(@"following", nil) forState:UIControlStateSelected|UIControlStateHighlighted];
		[self applyGlobalFont];
	}
	[self addTarget:self action:@selector(followButtonTouch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setItem:(PDItem *)item
{
	_item = item;
	[self refreshButton];
}

- (void)refreshButton
{
	self.hidden = NO;
	if ([self.item isKindOfClass:[PDUser class]]) {
		self.hidden = (self.item.identifier == kPDUserID);
	} else if ([self.item isKindOfClass:[PDPhoto class]]) {
		self.hidden = [[(PDPhoto *) self.item user] identifier] == kPDUserID;
	}
	self.selected = self.item.followStatus;
}

- (void)followButtonTouch
{
	serverFollowItem = [[PDServerFollowItem alloc] initWithDelegate:self];
	if (self.item.followStatus) {
		[self showActivityWithStyle:UIActivityIndicatorViewStyleWhite color:[UIColor whiteColor]];
		[(PDViewController *) self.firstViewController trackEvent:@"Unfollow"];
		[serverFollowItem unfollowItem:self.item];
	} else {
		[self showActivityWithStyle:UIActivityIndicatorViewStyleWhite color:[UIColor blackColor]];
		[(PDViewController *) self.firstViewController trackEvent:@"Follow"];
		[serverFollowItem followItem:self.item];
	}
}

#pragma mark - Server delegate

- (void)serverExchange:(PDServerExchange *)serverExchange didParseResult:(NSDictionary *)result
{
	[self hideActivity];
	if ([serverExchange isKindOfClass:[PDServerFollowItem class]]) {
		if (self.item.followStatus) {
			self.item.followStatus = NO;
			self.item.followersCount--;
			if ([self.item isKindOfClass:[PDUser class]]) {
				kPDAppDelegate.userProfile.followingsCount--;
			}
		} else {
			self.item.followStatus = YES;
			self.item.followersCount++;
			if ([self.item isKindOfClass:[PDUser class]]) {
				kPDAppDelegate.userProfile.followingsCount++;
			}
		}
		if (self.item) {
			NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:self.item forKey:@"object"];
			[userInfo setObject:@[
														@{@"value" : [NSNumber numberWithBool:self.item.followStatus], @"key" : @"followStatus"},
														@{@"value" : [NSNumber numberWithInteger:self.item.followersCount], @"key" : @"followersCount"}] forKey:@"values"];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:kPDItemWasChangedNotification
																													object:self
																												userInfo:userInfo];
		}
		
		[self refreshButton];
	}
}

- (void)serverExchange:(PDServerExchange *)serverExchange didFailWithError:(NSString *)error
{
	[self hideActivity];
	if ([serverExchange isKindOfClass:[PDServerFollowItem class]]) {
		[[PDSingleErrorAlertView instance] showErrorMessage:error];
		[self refreshButton];
	}
}

@end
