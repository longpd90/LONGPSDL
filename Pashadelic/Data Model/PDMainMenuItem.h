//
//  PDMainMenuItem.h
//  Pashadelic
//
//  Created by Vitaliy Gozhenko on 04.04.13.
//
//

#import <Foundation/Foundation.h>

@interface PDMainMenuItem : NSObject

@property (strong, nonatomic) UIViewController *rootViewController;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic, assign) NSUInteger badgeCount;

- (id)initMenuItemWithRootViewController:(UIViewController *)rootViewController title:(NSString *)title image:(UIImage *)image;

@end
