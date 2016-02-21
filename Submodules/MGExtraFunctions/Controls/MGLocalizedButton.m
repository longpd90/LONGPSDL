//
//  MGLocalizedButton.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.07.13.
//
//

#import "MGLocalizedButton.h"

@implementation MGLocalizedButton

- (void)awakeFromNib
{
	NSString *normalTitle = [self titleForState:UIControlStateNormal];
	[self setTitle:NSLocalizedString([self titleForState:UIControlStateNormal], nil) forState:UIControlStateNormal];
	if (![normalTitle isEqualToString:[self titleForState:UIControlStateHighlighted]]) {
		[self setTitle:NSLocalizedString([self titleForState:UIControlStateHighlighted], nil) forState:UIControlStateHighlighted];
	}
	
	if (![normalTitle isEqualToString:[self titleForState:UIControlStateDisabled]]) {
		[self setTitle:NSLocalizedString([self titleForState:UIControlStateDisabled], nil) forState:UIControlStateDisabled];
	}
	
	if (![normalTitle isEqualToString:[self titleForState:UIControlStateSelected]]) {
		[self setTitle:NSLocalizedString([self titleForState:UIControlStateSelected], nil) forState:UIControlStateSelected];
	}
}

@end
