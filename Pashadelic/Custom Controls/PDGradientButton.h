//
//  PDGradientButton.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.01.13.
//
//

#import "MGGradientButton.h"
#import "UIView+Extra.h"

typedef enum {
    kPDSideLeftBarButton = 0,
    kPDSideLeftGrayAngleBarButton = 1,
    kPDSideRightBarButton
} kPDSideBarButton;

@interface PDGradientButton : MGGradientButton{
    
}
@property kPDSideBarButton theSideBarButton;
- (void)initialize;
- (void)setRoundedCornerStyle;
- (void)setBlueDarkGradientButtonStyle;
- (void)setGrayGradientButtonStyle;
- (void)setGrayLightGradientButtonStyle;
- (void)setOrangeGradientButtonStyle;
- (void)setWhiteSmokeGradientButtonStyle;
- (void)setRedGradientButtonStyle;
@end
