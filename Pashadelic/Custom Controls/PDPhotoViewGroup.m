//
//  PDPhotoViewGroup.m
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 07.06.13.
//
//

#import "PDPhotoViewGroup.h"

@implementation PDPhotoViewGroup

- (void)awakeFromNib
{
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

@end
