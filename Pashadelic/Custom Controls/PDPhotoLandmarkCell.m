//
//  PDPhotoLandmarkCell.m
//  Pashadelic
//
//  Created by LongPD on 6/16/14.
//
//

#import "PDPhotoLandmarkCell.h"
#import "UIImageView+FontAwesome.h"
#define FAKFontAwesomePhotoIcon   @"\uf03e"
#define FAKFontAwesomeUseIcon     @"\uf0c0"

@implementation PDPhotoLandmarkCell

- (void)awakeFromNib
{
    float fontSize = 22;
    NSDictionary *grayColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalGrayColor};
    NSDictionary *darkGrayColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalDarkGrayColor};
    [_photoCountImage setFontAwesomeIconForImage:[FAKFontAwesome iconWithCode:FAKFontAwesomePhotoIcon size:15]
                                  withAttributes:darkGrayColorAttribute ];
    [_userCountImage setFontAwesomeIconForImage:[FAKFontAwesome iconWithCode:FAKFontAwesomeUseIcon size:15]
                                  withAttributes:darkGrayColorAttribute ];
    [_angleRightImage setFontAwesomeIconForImage:[FAKFontAwesome angleRightIconWithSize:fontSize]
                                 withAttributes:grayColorAttribute ];
    _photoCountLabel.textColor = kPDGlobalDarkGrayColor;
    _userCountLabel.textColor = kPDGlobalDarkGrayColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)initCell
{
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self.avatarImageView addSubview:self.activityIndicator];
	self.avatarImageView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setLandMarkItem:(PDPhotoLandMarkItem *)landMarkItem
{
    _landMarkItem = landMarkItem;
    [_avatarImageView sd_setImageWithURL:landMarkItem.avatarListURL];
    _nameLandmarkLabel.text = landMarkItem.name;
    if (self.landMarkItem.photoCount > 1)
        _photoCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photos", nil), landMarkItem.photoCount];
    else
        _photoCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photo", nil), landMarkItem.photoCount];
    
    if (self.landMarkItem.userCount > 1)
        
        _userCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photographers", nil), landMarkItem.userCount];
    else
        _userCountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d photographer", nil), landMarkItem.userCount];
}
@end
