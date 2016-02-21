//
//  UIImage+Extra.m
//  Pet Calendar
//
//  Created by Vitaliy Gozhenko on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImage+Extra.h"

@implementation UIImage (Extra)

- (UIImage *)negativeMaskImage
{
	// get width and height as integers, since we'll be using them as
	// array subscripts, etc, and this'll save a whole lot of casting
	CGSize size = self.size;
	int width = size.width;
	int height = size.height;
	
	// Create a suitable RGB+alpha bitmap context in BGRA colour space
	CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
	CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colourSpace);
	
	// draw the current image to the newly created context
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
	
	// run through every pixel, a scan line at a time...
	for(int y = 0; y < height; y++)
	{
		// get a pointer to the start of this scan line
		unsigned char *linePointer = &memoryPool[y * width * 4];
		
		// step through the pixels one by one...
		for(int x = 0; x < width; x++)
		{
			linePointer[0] = linePointer[1] = linePointer[2] = 0;
			if (linePointer[3] == 255) {
				linePointer[3] = 0;
			} else {
				linePointer[3] = 255;
			}
			linePointer += 4;
		}
	}
	
	// get a CG image from the context, wrap that into a
	// UIImage
	CGImageRef cgImage = CGBitmapContextCreateImage(context);
	UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	
	// clean up
	CGImageRelease(cgImage);
	CGContextRelease(context);
	free(memoryPool);
	
	// and return
	return returnImage;
}

- (UIImage *)grayscaleMaskImage
{
	UIImage *image = self;
	CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
	CGContextRef c = UIGraphicsGetCurrentContext();
	[image drawInRect:rect];
	CGContextSetFillColorWithColor(c, [[UIColor whiteColor] CGColor]);
	CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
	CGContextFillRect(c, rect);
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return result;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
		image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
	}
    return image;
}

- (UIImage *)grayscaleCopy
{
	CGRect imageRect = CGRectMake(0, 0, self.size.width, self.size.height);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, 0, colorSpace, (CGBitmapInfo) kCGImageAlphaNone);
	
	CGContextDrawImage(context, imageRect, [self CGImage]);
	
	CGImageRef imageRef = CGBitmapContextCreateImage(context);
	
	UIImage *newImage = [UIImage imageWithCGImage:imageRef];
	
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	CFRelease(imageRef);
	
	return newImage;
}

- (UIImage *)fixOrientation {
	
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
	
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
	
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
			
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
			
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
	
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
			
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
	
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
			
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
	
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (UIImage *)stretchableImageWithName:(NSString *)name
{
	UIImage *originalImage = [UIImage imageNamed:name];
	int halfHeight = originalImage.size.height / 2;
	int halfWidth = originalImage.size.width / 2;
	UIEdgeInsets insets = UIEdgeInsetsMake(halfHeight - 1, halfWidth - 1, halfHeight - 1, halfWidth - 1);
	if ([originalImage respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
		return [originalImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
	} else {
		return [originalImage resizableImageWithCapInsets:insets];
	}
}

+ (UIImage *)buttonImageWithName:(NSString *)name
{
	return [UIImage stretchableImageWithName:name];
}

- (UIImage *) overlayWithImage:(UIImage *)image
{
	UIGraphicsBeginImageContext(self.size);
	[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
	[image drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return result;
}

- (UIImage *)cutImageWithRect:(CGRect)rect
{
	CGImageRef cuttedImage = CGImageCreateWithImageInRect(self.CGImage, rect);
	UIImage *image = [UIImage imageWithCGImage:cuttedImage];
	CGImageRelease(cuttedImage);
	return image;
}

@end
