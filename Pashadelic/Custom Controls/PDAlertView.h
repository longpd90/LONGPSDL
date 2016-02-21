//
//  PDAlertView.h
//  Pashadelic
//
//  Created by TungNT2 on 12/20/13.
//
//

#import <UIKit/UIKit.h>
@class PDViewController;
@class PDAlertView;

#define kPDWindowBackgroundViewTag            99999
@protocol PDAlertViewDelegate <NSObject>
@optional
- (void)alertViewDidFinish:(PDAlertView *)alertView;
- (void)alertViewDidCancel:(PDAlertView *)alertView;
@end

@interface PDAlertView : UIView
@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) PDViewController *parentViewController;
@property (nonatomic, strong) UIView *backgroundAlertView;
- (void)initialize;
- (void)show;
- (void)dismissWithBackgroundView:(BOOL)isDismissBackgroundView;
@end

