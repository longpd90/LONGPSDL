//
//  UIImage+FontAwesome.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 26.02.14.
//
//

#import <UIKit/UIKit.h>
#import "FontAwesomeKit.h"

@interface UIImage (FontAwesome)

- (UIImage *)fontAwesomeImageForIcon:(FAKIcon *)icon imageSize:(CGSize)imageSize attributes:(NSDictionary *)attributes;

@end
