//
//  PDBarButton.h
//  Pashadelic
//
//  Created by LongPD on 10/14/13.
//
//

#import <UIKit/UIKit.h>
#import "PDGradientButton.h"
@interface PDBarButton : UIButton

@property kPDSideBarButton sideBarButton;

- (id)initWithImage:(UIImage *)image withSide:(kPDSideBarButton)theSide;
- (void)setImageForSelectedState:(UIImage *)image;
@end
