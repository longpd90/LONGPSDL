//
//  PDServerErrorAlertView.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 12.01.14.
//
//

#import "PDSingleErrorAlertView.h"
#import "Globals.h"

@interface PDSingleErrorAlertView ()
<UIAlertViewDelegate>

@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation PDSingleErrorAlertView

+ (instancetype)instance
{
  static dispatch_once_t once;
  static id instance;
  dispatch_once(&once, ^{
    instance = [[self alloc] init];
  });
  return instance;
}

- (void)showErrorMessage:(NSString *)error
{
	if (self.alertView) {		
		if (![self.messages.lastObject isEqualToString:error]) {
			[self.alertView dismissWithClickedButtonIndex:0 animated:NO];
			[self.messages addObject:error];
			self.alertView = [[UIAlertView alloc] initWithTitle:nil
																									message:[self.messages componentsJoinedByString:@"\n"]
																								 delegate:self
																				cancelButtonTitle:NSLocalizedString(@"OK", nil)
																				otherButtonTitles:nil];
			[self.alertView show];
		}
		
	} else {
		self.messages = [NSMutableArray arrayWithObject:error];
		self.alertView = [[UIAlertView alloc] initWithTitle:nil
																								message:error
																							 delegate:self
																			cancelButtonTitle:NSLocalizedString(@"OK", nil)
																			 otherButtonTitles:nil];
		[self.alertView show];
	}
}

- (void)setAlertView:(UIAlertView *)alertView
{
	_alertView = alertView;
	if (!alertView) {
		self.messages = [NSMutableArray array];
	}
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.alertView = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kPDDismissSingleErrorAlertView object:nil];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
	self.alertView = nil;
}

@end
