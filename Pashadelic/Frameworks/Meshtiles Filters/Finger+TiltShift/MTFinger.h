//
//  MTFinger.h
//  Pashadelic
//
//  Created by TungNT2 on 1/31/13.
//
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface MTFinger : NSObject

@property(nonatomic, strong) GPUImageFilterGroup *gpuFilterGroup;
@property(nonatomic, strong) GPUImageBrightnessFilter *gpuBrightnessFilter;
@property(nonatomic, strong) GPUImageSaturationFilter *gpuSaturationFilter;
@property(nonatomic, strong) GPUImagePicture *stillImageSource;

- (UIImage *)imageFingerFromImage:(UIImage *)image atPointX:(CGFloat)x andY:(CGFloat)y;

@end
