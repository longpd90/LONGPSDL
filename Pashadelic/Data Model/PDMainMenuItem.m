//
//  PDMainMenuItem.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 04.04.13.
//
//

#import "PDMainMenuItem.h"

@implementation PDMainMenuItem

- (id)initMenuItemWithRootViewController:(UIViewController *)rootViewController title:(NSString *)title image:(UIImage *)image
{
	self = [super init];
	if (self) {
		self.rootViewController = rootViewController;
		self.title = title;
		self.image = image;
	}
	return self;
}

@end
