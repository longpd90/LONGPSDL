//
//  PDUploadPhotoView.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 28.05.13.
//
//

#import <UIKit/UIKit.h>

@interface PDUploadPhotoView : UIImageView

@property (strong, nonatomic) UIView *overlayView;
@property (assign, nonatomic) double progress;

- (void)reset;

@end
