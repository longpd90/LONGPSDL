//
//  MTFinger.m
//  Pashadelic
//
//  Created by TungNT2 on 1/31/13.
//
//

#import "MTFinger.h"

@interface MTFinger (Private)
- (void)initGPUImageFilterGroup;
@end
@implementation MTFinger
@synthesize gpuFilterGroup,
            gpuBrightnessFilter,
            gpuSaturationFilter;

- (id)init
{
    self = [super init];
    if (self) {
        [self initGPUImageFilterGroup];
    }
    return self;
}

- (void)initGPUImageFilterGroup
{
    self.gpuFilterGroup = [[[GPUImageFilterGroup alloc] init] autorelease];
    
    self.gpuBrightnessFilter = [[[GPUImageBrightnessFilter alloc] init] autorelease];
    [self.gpuFilterGroup addFilter:self.gpuBrightnessFilter];
    
    self.gpuSaturationFilter = [[[GPUImageSaturationFilter alloc] init] autorelease];
    [self.gpuFilterGroup addFilter:self.gpuSaturationFilter];
    
    [self.gpuBrightnessFilter addTarget:self.gpuSaturationFilter];
    [self.gpuFilterGroup setInitialFilters:[NSArray arrayWithObject:self.gpuBrightnessFilter]];
    [self.gpuFilterGroup setTerminalFilter:self.gpuSaturationFilter];
}

- (UIImage *)imageFingerFromImage:(UIImage *)image atPointX:(CGFloat)x andY:(CGFloat)y
{
    [self.gpuBrightnessFilter setBrightness:-1*y];
    [self.gpuSaturationFilter setSaturation:x+1.0];
    
    if (self.stillImageSource) {
        [self.stillImageSource removeOutputFramebuffer];
        [self.stillImageSource removeAllTargets];
        self.stillImageSource = nil;
    }
    
    self.stillImageSource = [[[GPUImagePicture alloc] initWithImage:image] autorelease];
    [self.stillImageSource addTarget:self.gpuFilterGroup];
    [self.gpuFilterGroup useNextFrameForImageCapture];
    [self.stillImageSource processImage];
    return [self.gpuFilterGroup imageFromCurrentFramebufferWithOrientation:UIImageOrientationUp];
}

- (void)dealloc
{
	[gpuBrightnessFilter release], gpuBrightnessFilter = nil;
	[gpuSaturationFilter release], gpuSaturationFilter = nil;
	[gpuFilterGroup release], gpuFilterGroup = nil;
	[_stillImageSource release], _stillImageSource = nil;
	[super dealloc];
}

@end
