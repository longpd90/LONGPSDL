//
//  PDLandmarkAnnotationCalloutView.m
//  Pashadelic
//
//  Created by LTT on 6/19/14.
//
//

#import "PDLandmarkAnnotationCalloutView.h"
#define FAKFontAwesomePhotoIcon   @"\uf03e"
#define FAKFontAwesomeUseIcon     @"\uf0c0"

@implementation PDLandmarkAnnotationCalloutView

- (void)setLocation:(PDLocation *)location
{
    _location = location;
    self.title.text = location.name;
    self.photosLabel.text =[NSString stringWithFormat: NSLocalizedString(@"%d photos", nil), location.photosCount];
    self.usersLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d users", nil), location.photographersCount];
    [self.landmarkAvatar sd_setImageWithURL:location.avatarURL placeholderImage:[UIImage imageNamed:@"placeholder_landmark.png"]];
    NSDictionary *comfortColorAttribute = @{NSForegroundColorAttributeName:kPDGlobalComfortColor};
    [_photoCountImage setFontAwesomeIconForImage:[FAKFontAwesome iconWithCode:FAKFontAwesomePhotoIcon size:15]
                                  withAttributes:comfortColorAttribute ];
    [_userCountImage setFontAwesomeIconForImage:[FAKFontAwesome iconWithCode:FAKFontAwesomeUseIcon size:15]
                                 withAttributes:comfortColorAttribute ];
}

@end
