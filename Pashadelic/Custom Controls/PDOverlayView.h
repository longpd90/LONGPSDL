//
//  PDOverlayView.h
//  Pashadelic
//
//  Created by TungNT2 on 8/7/13.
//
//

#import <UIKit/UIKit.h>

@protocol PDOverlayViewDelegate <NSObject>
- (void)didTouchesToOverlayView;
@end

@interface PDOverlayView : UIView
@property (strong, nonatomic)id<PDOverlayViewDelegate>delegate;

@end
