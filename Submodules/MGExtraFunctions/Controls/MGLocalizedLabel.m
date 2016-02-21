//
//  MGLocalizedLabel.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 13.07.13.
//
//

#import "MGLocalizedLabel.h"

@implementation MGLocalizedLabel

- (void)awakeFromNib
{
	self.text = NSLocalizedString(self.text, nil);
}

@end
