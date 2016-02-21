//
//  PDLandmarkCell.m
//  Pashadelic
//
//  Created by TungNT2 on 7/23/13.
//
//

#import "PDLandmarkCell.h"

@implementation PDLandmarkCell

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [_compassImageView setFontAwesomeIconForImage:[FAKFontAwesome compassIconWithSize:15] withAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

- (void)setPOI:(PDPOIItem *)poiItem
{
    _landmarkNameLabel.text = [NSString stringWithFormat:@"%@",poiItem.name] ;
    
    [_imageViewItem sd_setImageWithURL:[NSURL URLWithString:poiItem.avatarTileURL]
                   placeholderImage:[UIImage imageNamed:@"placeholder_landmark.png"]];

    CGSize sizeTagName = [_landmarkNameLabel.text sizeWithFont:_landmarkNameLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, _landmarkNameLabel.height) lineBreakMode:NSLineBreakByCharWrapping];
    float widthCell = MIN(sizeTagName.width + 5, 240);
    _backgroundLabelView.width = widthCell + offsetLeft;
    _landmarkNameLabel.width = widthCell;

    if (poiItem.photosCount > 1) {
        _photoCountsLabel.text = [NSString stringWithFormat:@"%zd", poiItem.photosCount];
        _photoUnitLabel.text = [NSString stringWithFormat:NSLocalizedString(@"photos", nil)];
    } else {
        _photoCountsLabel.text = [NSString stringWithFormat:@"%zd", poiItem.photosCount];
        _photoUnitLabel.text = [NSString stringWithFormat:NSLocalizedString(@"photo", nil)];
    }
    
    if ([poiItem distanceInString] && [poiItem distanceInString].length > 0) {
        _distanceLabel.text = [poiItem distanceInString];
        _unitDistanceLabel.text = [poiItem unitDistanceString];

    } else {
        _distanceLabel.text = NSLocalizedString(@"unknow", nil);
        _unitDistanceLabel.text = nil;
    }
    
    CGSize sizeDistanceLabel = [_distanceLabel.text sizeWithFont:_distanceLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, _distanceLabel.height) lineBreakMode:NSLineBreakByCharWrapping];
    _distanceLabel.width = sizeDistanceLabel.width;
    _unitDistanceLabel.x = _distanceLabel.frame.origin.x + _distanceLabel.width;
    
    CGSize sizePhotoCountLabel = [_photoCountsLabel.text sizeWithFont:_photoCountsLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, _photoCountsLabel.height) lineBreakMode:NSLineBreakByCharWrapping];
    _photoCountsLabel.x = _unitDistanceLabel.rightXPoint + 30;
    _photoCountsLabel.width = sizePhotoCountLabel.width;
    _photoUnitLabel.x = _photoCountsLabel.rightXPoint + 2;
}

@end
