//
//  PDTipDescription.m
//  Pashadelic
//
//  Created by LongPD on 6/10/14.
//
//

#import "PDTipDescription.h"

@implementation PDTipDescription

- (void)awakeFromNib
{
	[super awakeFromNib];
    [self.arrowImageView setFontAwesomeIconForImage:[FAKFontAwesome caretDownIconWithSize:30] withAttributes: @{NSForegroundColorAttributeName:[UIColor colorWithIntRed:52 green:60 blue:64 alpha:255]} ];
}

- (void)setTipDescription:(NSString *)tipTile
{
    _tipTileLabel.text = tipTile;
    int width = [tipTile sizeWithFont:_tipTileLabel.font].width + 10;
    _tipTileLabel.width = width;
    self.width = width;
    self.arrowImageView.center = CGPointMake(self.tipTileLabel.center.x, self.arrowImageView.center.y) ;
}

@end
