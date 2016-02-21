//
//  PDLocationViewCell.m
//  Pashadelic
//
//  Created by LongPD on 6/18/14.
//
//

#import "PDLocationViewCell.h"

@implementation PDLocationViewCell

- (void)awakeFromNib
{
    float fontSize = 22;
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalGrayColor};
    [_angleRightImageView setFontAwesomeIconForImage:[FAKFontAwesome
                                                      angleRightIconWithSize:fontSize]
                                      withAttributes:grayColorAttribute ];
}

- (void)setLocationItem:(PDLocationInfoItem *)locationItem
{
    if (locationItem.locationType == PDLocationTypeCity ) {
        _typeLabel.text = NSLocalizedString(@"City", nil);
    } else if (locationItem.locationType == PDLocationTypeState) {
        _typeLabel.text = NSLocalizedString(@"State", nil);
    } else if (locationItem.locationType == PDLocationTypeCountry) {
        _typeLabel.text = NSLocalizedString(@"Country", nil);
    }
    
    _namLabel.text = locationItem.name;
    _photoCountLabel.text = [NSString stringWithFormat:@"%d photos",locationItem.photoCount];
    _landmarkCountlabel.text = [NSString stringWithFormat:@"%d landmarks",locationItem.landmardCount];
    _usercountLabel.text = [NSString stringWithFormat:@"%d users",locationItem.userCount];
    [_avatarImageView setImageWithURL:locationItem.avatarURL];
}

@end
