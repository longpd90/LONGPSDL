//
//  PDDeckViewController.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 04.04.13.
//
//

#import "MWPhotoBrowser.h"

@interface PDDeckViewController ()

@end

@implementation PDDeckViewController

-(BOOL)shouldAutorotate
{
	if ([self.rightController.navigationController.topViewController isKindOfClass:[MWPhotoBrowser class]]) {
		return YES;
	} else {
		return NO;
	}
}

- (NSUInteger)supportedInterfaceOrientations
{
	if ([self.rightController.navigationController.topViewController isKindOfClass:[MWPhotoBrowser class]]) {
		return UIInterfaceOrientationMaskAll;
	} else {
		return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
	}
}

@end
