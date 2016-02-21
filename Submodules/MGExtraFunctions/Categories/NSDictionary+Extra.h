//
//  NSDictionary+Extra.h
//  Pashadelic
//
//  Created by Виталий Гоженко on 20/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extra)

- (NSDate *)dateForKey:(NSString *)key format:(NSString *)format;
- (NSDate *)unixDateForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSURL *)urlForKey:(NSString *)key;
- (NSInteger)intForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
- (NSDecimalNumber *)decimalNumberForKey:(NSString *)key;
- (id)notNullObjectForKey:(id)key;
							

@end
