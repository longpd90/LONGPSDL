//
//  PDPhotoTipsView.m
//  Pashadelic
//
//  Created by LongPD on 3/10/14.
//
//

#import "PDPhotoTipsView.h"

@implementation PDPhotoTipsView

- (id)init
{
    self = [UIView loadFromNibNamed:@"PDPhotoTipsView"];
    if (self) {
    }
    return self;
}

- (IBAction)showTile:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTitleTip:)]) {
        [self.delegate showTitleTip:self];
    }
    sender.selected =! sender.selected;
}

- (void)setcontentImage:(UIImage *)image withTitle:(NSString *)tile
{
    _avatarImage.image = image;
    _titleTip = tile;
}

@end
