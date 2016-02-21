//
//  UIImage+MTFilter.m
//  Pashadelic
//
//  Created by TungNT2 on 1/30/13.
//
//

#import "UIImage+MTFilter.h"
#import "GPUImage.h"
@implementation UIImage (MTFilter)

#pragma mark - DebugHelper
-(id) trackTime:(NSString *)method {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL _selector = NSSelectorFromString(method);
    id retVal = [self performSelector:_selector];
    return retVal;
#pragma clang diagnostic pop
}
#pragma mark - Meshtiles filter

+ (UIImage*)imageWithBlur:(UIImage*)image
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:3.5f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
		UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
		CGImageRelease(cgImage);
		return blurredImage;
  
    // if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

// 00_No Filter
- (UIImage *)m00 {
    return self;
}

// 01_vibrant
- (UIImage *)m01 {
    // B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixVibrant =  (GPUMatrix4x4){
        {1.5f, 0, 0, -0.1f}, { 0, 1.5f, 0, -0.1f}, {0, 0, 1.5f, -0.1f},{0, 0, 0, 1}
    };
    GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc] init];
    [colorMatrixFilter setColorMatrix:matrixVibrant];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];

    
    //B2: tăng contrast của ảnh lên 1.3
    GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.3];
    UIImage *imageContrastFilter = [contrastFilter imageByFilteringImage:imageColorMatrixFilter];
    
    //B4: lấy ảnh thu được
    UIImage *imageOutput = [[UIImage alloc]initWithCGImage:imageContrastFilter.CGImage scale:1.0 orientation:UIImageOrientationUp];
    return imageOutput;
}

// 02_beauty
- (UIImage *)m02 {
    // B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixBeauty =  (GPUMatrix4x4){
        {1.3f, 0, 0, 0}, { 0, 1.3f, 0, 0}, {0, 0, 1.3f, 0}, {0, 0, 0, 1}
    };
    GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc]init];
    [colorMatrixFilter setColorMatrix:matrixBeauty];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];
    
    //B4: lấy ảnh thu được
    UIImage *imageOutput = [[UIImage alloc]initWithCGImage:imageColorMatrixFilter.CGImage scale:1.0 orientation:UIImageOrientationUp];
    return imageOutput;
}

// 03_xproMt
-(UIImage *)m03 {
    
    //B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixXroMt = {
        {1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}
    };
    GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc] init];
    [colorMatrixFilter setColorMatrix:matrixXroMt];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];
    
    //B2: giảm brightness của ảnh xuống -0.1
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:-0.05];
    UIImage *imageBrightnessFilter = [brightnessFilter imageByFilteringImage:imageColorMatrixFilter];
    imageBrightnessFilter = [[UIImage alloc] initWithCGImage:imageBrightnessFilter.CGImage scale:1.0 orientation:UIImageOrientationUp];
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageBrightnessFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B3: chồng layer xpro_overlay_1.0 với mode Overlay, alpha 1.0
    UIImage *imageHardLight = [UIImage imageNamed:@"xpro_overlay_1.0.jpg"];
    [imageHardLight drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeOverlay alpha:1.0];
    
    //B4: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
}

// 04_lomoMt
-(UIImage *)m04 {
    //B1: tăng contrast của ảnh lên 1.21
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.21];
    UIImage *imageContrastFilter = [contrastFilter imageByFilteringImage:self];
    
    //B2: giảm bright của ảnh xuống 0.1
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:-0.1];
    UIImage *imageBrightnessFilter = [brightnessFilter imageByFilteringImage:imageContrastFilter];
    imageBrightnessFilter = [[UIImage alloc] initWithCGImage:imageBrightnessFilter.CGImage scale:1.0 orientation:UIImageOrientationUp];
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageBrightnessFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B3: chồng layer lomo_overlay_0.8 với mode Overlay, alpha 0.8
    UIImage *imageOverlay = [UIImage imageNamed:@"lomo_overlay_0.8.jpg"];
    [imageOverlay drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeOverlay alpha:0.8];
    
    //B4: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
}

// 05_retro
-(UIImage *)m05 {
    
    //B1: tăng contrast của ảnh lên 1.3
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.3];
    UIImage *imageContrastFilter = [contrastFilter imageByFilteringImage:self];
    
    //B2: giảm saturation của ảnh xuống 0.3
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:0.7];
    UIImage *imageSaturationFilter = [saturationFilter imageByFilteringImage:imageContrastFilter];
    imageSaturationFilter = [[UIImage alloc]initWithCGImage:imageSaturationFilter.CGImage scale:1 orientation:UIImageOrientationUp];
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageSaturationFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B3: chồng layer retro_multiply_0.6 với mode Mutiply, alpha 0.6
    UIImage *imageMutiply = [UIImage imageNamed:@"retro_multiply_0.6.jpg"];
    [imageMutiply drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeMultiply alpha:0.6];
    
    //B4: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageOutput;
}

// 06_griseous
-(UIImage *)m06 {
    
    //B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixGriseous =  (GPUMatrix4x4){
        {1, 0, 0, 0}, {0, 1, 0.2f, 0}, {0.1f, 0.3f, 1, 0}, {0, 0, 0, 1}
    };
    GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc]init];
    [colorMatrixFilter setColorMatrix:matrixGriseous];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];
    
    //B2: giảm brightness của ảnh xuống -0,1
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:-0.1];
    UIImage *imageBrightnessFilter = [brightnessFilter imageByFilteringImage:imageColorMatrixFilter];
    
    //B3: giảm saturation của ảnh xuống 0.5
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:0.7];
    UIImage* imageSaturationFilter = [saturationFilter imageByFilteringImage:imageBrightnessFilter];
    
    //B3: tăng contrast của ảnh lên 1.45
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.25];
    UIImage *imageContrastFilter = [contrastFilter imageByFilteringImage:imageSaturationFilter];
    imageContrastFilter = [[UIImage alloc]initWithCGImage:imageContrastFilter.CGImage scale:1 orientation:UIImageOrientationUp];
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageContrastFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B4: chồng layer griseuos_multiply_0.3 với mode Mutiply, alpha 0.3
    UIImage *imageMutiply = [UIImage imageNamed:@"griseuos_multiply_0.3.jpg"];
    [imageMutiply drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeMultiply alpha:0.3];
    
    //B5: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
}

// 07_sunrise
-(UIImage *)m07 {
    
    //B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixSunrise =  (GPUMatrix4x4){
        {1, 0.08f, 0.08f, 0.08f}, {0, 1, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}
    };
    GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc]init];
    [colorMatrixFilter setColorMatrix:matrixSunrise];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageColorMatrixFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B2: chồng layer sunrise_softlight_1.0 với mode Softlight, alpha 1.0
    UIImage *imageSoftLight = [UIImage imageNamed:@"sunrise_softlight_1.0.jpg"];
    [imageSoftLight drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeSoftLight alpha:1.0];
    imageSoftLight = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //B3: giảm saturation của ảnh xuống 0.8
    GPUImageSaturationFilter* saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:0.8];
    
    //B4: lấy ảnh thu được
    UIImage *imageOutput = [saturationFilter imageByFilteringImage:imageSoftLight];
    imageOutput = [[UIImage alloc]initWithCGImage:imageOutput.CGImage scale:1.0 orientation:UIImageOrientationUp];
    return imageOutput;
}

// 08_nostalgia
-(UIImage *)m08 {
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B1: chồng layer nostalgia1_multiply_1.0 với mode Mutiply, alpha 1.0
    UIImage *imageMutiply = [UIImage imageNamed:@"nostalgia1_multiply_1.0.jpg"];
    [imageMutiply drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeMultiply alpha:1.0];
    
    //B2: chồng layer nostalgia2_softlight_0.7 với mode SoftLight, alpha 0.7
    UIImage *imageSoftLight = [UIImage imageNamed:@"nostalgia2_softlight_0.7.jpg"];
    [imageSoftLight drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeSoftLight alpha:0.7];
    
    //B3: lấy ảnh thu được sau khi chồng layer
    imageSoftLight = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //B4: tăng saturation của ảnh lên 1.4
    GPUImageSaturationFilter* saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:1.4];
    UIImage *imageSaturationFilter = [saturationFilter imageByFilteringImage:imageSoftLight];
    
    //B5: tăng bright của ảnh lên 0.2
    GPUImageBrightnessFilter* brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:0.2];
    UIImage *imageBrightnessFilter = [brightnessFilter imageByFilteringImage:imageSaturationFilter];
    
    //B6: lấy ảnh thu được
    UIImage *outputImage = [[UIImage alloc]initWithCGImage:imageBrightnessFilter.CGImage scale:1.0 orientation:UIImageOrientationUp];
    return outputImage;
}

// 09_chrome
-(UIImage *)m09 {
    
    //B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixChrome =  (GPUMatrix4x4){
        {0.35f, 0.35f, 0.35f, 0},{ 0.35f, 0.35f, 0.35f, 0},{0.35f, 0.35f, 0.35f, 0},{0, 0,0, 1}
    };
    
    GPUImageColorMatrixFilter*colorMatrixFilter = [[GPUImageColorMatrixFilter alloc]init];
    [colorMatrixFilter setColorMatrix:matrixChrome];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];
    
    //B2: Giảm brightness của ảnh xuống -0.2
    GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:-0.1];
    UIImage *imageBrightnessFilter = [brightnessFilter imageByFilteringImage:imageColorMatrixFilter];
    
    //B3: tăng contrast của ảnh lên 1.36
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.36];
    UIImage *imageContrastFilter = [contrastFilter imageByFilteringImage:imageBrightnessFilter];
    imageContrastFilter = [[UIImage alloc]initWithCGImage:imageContrastFilter.CGImage scale:1 orientation:UIImageOrientationUp];
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageContrastFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B4: chồng layer chrome_softlight_1.0 với mode Softlight, alpha 1.0
    UIImage *imageSoftLight = [UIImage imageNamed:@"chrome_softlight_1.0.png"];
    [imageSoftLight drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeSoftLight alpha:1.0];
    
    //B5: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
    
}

// 10_brownish
-(UIImage *)m10 {
    
    // B1: tăng contrast lên 1.39
    GPUImageContrastFilter *filterContrast = [[GPUImageContrastFilter alloc] init];
    [filterContrast setContrast:1.3];
    UIImage *imageContrast = [filterContrast imageByFilteringImage:self];
    
    // B2: set ma trận màu cho ảnh
    GPUMatrix4x4 matrixBrownish =  (GPUMatrix4x4) {
        {1, 0.2f, 0, 0},{ 0.1f, 1, 0, 0},{0, 0, 1, 0},{0, 0, 0, 1}
    };
    
    GPUImageColorMatrixFilter* filterColorMatrix = [[GPUImageColorMatrixFilter alloc]init];
    [filterColorMatrix setColorMatrix:matrixBrownish];
    UIImage* imageFilterMatrix = [filterColorMatrix imageByFilteringImage:imageContrast];
    imageFilterMatrix = [[UIImage alloc]initWithCGImage:imageFilterMatrix.CGImage scale:1 orientation:UIImageOrientationUp];
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageFilterMatrix drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // B3: chồng layer brownish1_overlay_0.6 với mode overlay, alpha 0.6
    UIImage *imageOverlay = [UIImage imageNamed:@"brownish1_overlay_0.6.jpg"];
    [imageOverlay drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeOverlay alpha:0.6];
    
    // B3: chồng layer brownish2_mutiply_0.7 với mode mutiply, alpha 0.7
    UIImage *imageMutiply = [UIImage imageNamed:@"brownish2_mutiply_0.7.jpg"];
    [imageMutiply drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeMultiply alpha:0.7];
    
    //B4: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
}
// 11_happytear
- (UIImage *)m11 {
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B1: chồng layer happyTear_overlay_0.6 với mode Overlay, alpha 0.6
    UIImage* imageOverlay = [UIImage imageNamed:@"happytear_overlay_0.6.png"];
    [imageOverlay drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeOverlay alpha:0.6];
    
    //B2: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
}

// 12_bright
-(UIImage *)m12 {
    
    //B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixBeauty =  (GPUMatrix4x4){
        {1.3f, 0, 0, 0},{ 0, 1.3f, 0, 0},{0, 0, 1.3f, 0},{0, 0, 0, 1}
    };
    
    GPUImageColorMatrixFilter* colorMatrixFilter = [[GPUImageColorMatrixFilter alloc]init];
    [colorMatrixFilter setColorMatrix:matrixBeauty];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];
    
    //B2: tăng bright của ảnh lên 0.1
    GPUImageBrightnessFilter* brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:0.1];
    UIImage *imageBrightnessFilter = [brightnessFilter imageByFilteringImage:imageColorMatrixFilter];
    
    //B3: lấy ảnh thu được
    UIImage *imageOutput = [[UIImage alloc]initWithCGImage:imageBrightnessFilter.CGImage scale:1 orientation:UIImageOrientationUp];
    return imageOutput;
}

// 13_inkWash
-(UIImage *)m13 {
    
    //B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixChrome =  (GPUMatrix4x4){
        {0.25f, 0.25f, 0.25f, 0},{ 0.25f, 0.25f, 0.25f, 0},{0.3, 0.3f, 0.3f, 0},{0, 0,0, 1}
    };
    
    GPUImageColorMatrixFilter* colorMatrixFilter = [[GPUImageColorMatrixFilter alloc]init];
    [colorMatrixFilter setColorMatrix:matrixChrome];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];
    
    //B2: tăng contrast của ảnh lên 1.1
    GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.1];
    UIImage *imageContrastFilter = [contrastFilter imageByFilteringImage:imageColorMatrixFilter];
    imageContrastFilter = [[UIImage alloc]initWithCGImage:imageContrastFilter.CGImage scale:1.0 orientation:UIImageOrientationUp];
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageContrastFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B3: chồng layer inkwash_overlay_0.8 với mode Overlay, alpha 0.8
    UIImage *imageOverlay = [UIImage imageNamed:@"inkwash_overlay_0.8.jpg"];
    [imageOverlay drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeOverlay alpha:0.8];
    
    //B4: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
}



// 14_instant
- (UIImage *)m14 {
    
    //B1: giảm saturation của ảnh xuống 0.5
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:0.5];
    UIImage* imageSaturationFilter = [saturationFilter imageByFilteringImage:self];
    
    //B2: tăng contrast của ảnh lên 1.15
    GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.15];
    UIImage *imageContrastFilter = [contrastFilter imageByFilteringImage:imageSaturationFilter];
    
    //B3: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixInstant =  (GPUMatrix4x4) {
        {1, 0, 0, 0}, { 0.03f, 1, 0.03f, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}
    };
    GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc]init];
    [colorMatrixFilter setColorMatrix:matrixInstant];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:imageContrastFilter];
    imageColorMatrixFilter = [[UIImage alloc]initWithCGImage:imageColorMatrixFilter.CGImage scale:1 orientation:UIImageOrientationUp];
    
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageColorMatrixFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B4: chồng layer instant_multiply_0.6 với mode Mutiply, alpha 0.6
    UIImage* imageMutiply = [UIImage imageNamed:@"instant_multiply_0.6.jpg"];
    [imageMutiply drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeMultiply alpha:0.6];
    //B5: lấy ảnh thu được
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
}

// 15_richtone
-(UIImage *)m15 {
    
    //B1: thiết lập ma trận màu cho ảnh
    GPUMatrix4x4 matrixRichTone =  (GPUMatrix4x4) {
        {1.2f, 0, 0, 0}, { 0, 1.25f, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}
    };
    GPUImageColorMatrixFilter *colorMatrixFilter = [[GPUImageColorMatrixFilter alloc]init];
    [colorMatrixFilter setColorMatrix:matrixRichTone];
    UIImage *imageColorMatrixFilter = [colorMatrixFilter imageByFilteringImage:self];
    imageColorMatrixFilter = [[UIImage alloc]initWithCGImage:imageColorMatrixFilter.CGImage scale:1 orientation:UIImageOrientationUp];
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [imageColorMatrixFilter drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //B2: chồng layer richtone_colorburn_0.5 với mode colorburn, alpha 0.5
    UIImage* imageColorBurn = [UIImage imageNamed:@"richtone_colorburn_0.5.jpg"];
    [imageColorBurn drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeColorBurn alpha:0.5];
    
    UIImage *imageOutput = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOutput;
}

@end
