//
//  MTTiltShift.h
//  Pashadelic
//
//  Created by TungNT2 on 2/4/13.
//
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface MTTiltShift : NSObject

@property(nonatomic,assign)size_t height;
@property(nonatomic,assign)size_t width;
@property(nonatomic,assign)unsigned char*pInside;
@property(nonatomic,retain) GPUImageGaussianSelectiveBlurFilter *radialBlurFilter;
@property(nonatomic,retain) GPUImageTiltShiftFilter *squareBlruFilter;

- (UIImage *)imageTiltShiftWithImage:(UIImage*)image fromPointCenter:(CGPoint)center andRadius:(CGFloat)radius;
- (UIImage *)imageTiltShiftWithImage:(UIImage *)image fromTopFocusLevel:(CGFloat)topFocusLevel andBottomFocusLevel:(CGFloat)bottomFocusLevel;
+ (UIImage *) convertBitmapRGBA8ToUIImage:(unsigned char *) buffer
                                withWidth:(int) width
                               withHeight:(int) height;
+ (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image ;

-(id)initWithImage:(UIImage*)image;
-(void)initInforWithImage:(UIImage*)image;
-(UIImage*)createBlurImageWithPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 isRound:(bool)isRound;
-(void)createDataBlur;
@end
