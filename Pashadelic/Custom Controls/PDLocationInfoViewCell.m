//
//  PDLocationViewCell.m
//  Pashadelic
//
//  Created by LongPD on 6/18/14.
//
//

#import "PDLocationInfoViewCell.h"

@implementation PDLocationInfoViewCell

- (void)awakeFromNib
{
    float fontSize = 22;
    self.layer.cornerRadius = 4;
	self.layer.shadowOffset = CGSizeMake(1, 1);
	self.layer.shadowOpacity = 0.5;
	self.layer.shadowRadius = 2;
	self.layer.shadowColor = [UIColor colorWithRed:0.918 green:0.918 blue:0.918 alpha:1].CGColor;
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalGrayColor};
    [_angleRightImageView setFontAwesomeIconForImage:[FAKFontAwesome
                                                      angleRightIconWithSize:fontSize]
                                      withAttributes:grayColorAttribute ];
    _photoCountLabel.textColor = kPDGlobalGrayColor;
    _landmarkCountlabel.textColor = kPDGlobalGrayColor;
    _usercountLabel.textColor = kPDGlobalGrayColor;
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;

}


- (void)setLocationItem:(PDLocation *)locationItem
{
    if (locationItem.locationType == PDLocationTypeCity ) {
        _typeLabel.text = NSLocalizedString(@"City :", nil);
    } else if (locationItem.locationType == PDLocationTypeState) {
        _typeLabel.text = NSLocalizedString(@"State :", nil);
    } else if (locationItem.locationType == PDLocationTypeCountry) {
        _typeLabel.text = NSLocalizedString(@"Country :", nil);
    }
    CGSize typeLabelSize = [_typeLabel.text sizeWithFont:_typeLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, _typeLabel.height) lineBreakMode:NSLineBreakByCharWrapping];
    _typeLabel.width = typeLabelSize.width;
    _namLabel.x = _typeLabel.rightXPoint + 4;
    _namLabel.text = locationItem.name;
    
    if (locationItem.photosCount > 1) {
        _photoCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photos", nil), locationItem.photosCount];

    } else {
        _photoCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photo", nil), locationItem.photosCount];

    }
    if (locationItem.landmarksCount > 1) {
        _landmarkCountlabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d landmarks", nil), locationItem.landmarksCount];
    } else {
        _landmarkCountlabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d landmark", nil), locationItem.landmarksCount];
    }
    if (locationItem.usersCount > 1) {
        _usercountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d users", nil), locationItem.usersCount];
    } else {
        _usercountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d user", nil), locationItem.usersCount];
    }
    [_avatarImageView sd_setImageWithURL:locationItem.avatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
}

@end
