// 
//  AdditionalFunctions.h
//
//  Created by Vitaliy Gozhenko on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kDeviceIPhone = 0,
    kDeviceIPad
} DeviceType;

CG_INLINE DeviceType deviceType()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
		return kDeviceIPad;
	else
		return kDeviceIPhone;
#else
	return kDeviceIPhone;
#endif
}

CG_INLINE BOOL isPad()
{
	return (BOOL)(deviceType() == kDeviceIPad);
}

CG_INLINE BOOL isPhone()
{
	return (BOOL)(deviceType() == kDeviceIPhone);
}

#define UIColorFromRGB(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define MGLocalized(key)			NSLocalizedString(key, nil)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define IS_PAD												(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PHONE											(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_PHONE_4_INCH								(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0)
#define IS_RETINA_SCREEN ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

CGRect CGRectWithY(CGRect rect, CGFloat y);
CGRect CGRectWithX(CGRect rect, CGFloat x);
CGRect CGRectWithWidth(CGRect rect, CGFloat width);
CGRect CGRectWithHeight(CGRect rect, CGFloat height);
CGRect CGRectMakeWithSize(CGFloat x, CGFloat y, CGSize size);

@interface UIAlertView (Extra)
+ (void) showAlertWithTitle:(NSString *)title message:(NSString *)message;
@end

