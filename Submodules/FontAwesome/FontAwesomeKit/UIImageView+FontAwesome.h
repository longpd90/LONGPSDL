//
//  UIImageView+FontAwesome.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 26.02.14.
//
//

#import <UIKit/UIKit.h>
#import "FAKFontAwesome.h"

@interface UIImageView (FontAwesome)

- (void)setFontAwesomeIconForImage:(FAKIcon *)icon withAttributes:(NSDictionary *)attributes;

@end
