//
//  PDPopupView.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 17.12.13.
//
//

#import <UIKit/UIKit.h>

typedef enum {
	PDPopupPositionTop = 0,
	PDPopupPositionBottom
	} PDPopupPosition;

@interface PDPopupView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textLabel;

+ (PDPopupView *)showPopupWithImage:(UIImage *)image text:(NSString *)text position:(PDPopupPosition)position;
- (void)hidePopup;

@end
