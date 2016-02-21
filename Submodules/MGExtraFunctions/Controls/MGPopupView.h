//
//  MGPopupView.h
//  Order&Pay
//
//  Created by Vitaliy Gozhenko on 09.12.12.
//
//

#import <UIKit/UIKit.h>

@interface MGPopupView : UIView
{
	UIWindow *window;
}

@property (unsafe_unretained, nonatomic) UIView *presentingView;

- (id)initWithView:(UIView *)view;
- (void)show;
- (void)hide;

@end
