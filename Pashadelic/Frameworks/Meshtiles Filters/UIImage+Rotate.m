//
//  UIImage+Rotate.m
//  Pashadelic
//
//  Created by TungNT2 on 1/24/13.
//
//

#import "UIImage+Rotate.h"

@interface UIImage (InternalMethods)
CGFloat DegreesToRadians(CGFloat degrees);
@end

@implementation UIImage (Rotate)

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

- (UIImage *)rotateDegreesToRadians90
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
    CGAffineTransform rotatedTransform = CGAffineTransformMakeRotation(DegreesToRadians(90));
    rotatedViewBox.transform = rotatedTransform;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(90));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), self.CGImage);
    
    UIImage *rotatedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rotatedImage;
}

@end
