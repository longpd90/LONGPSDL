//
//  NSObject+Extra.h
//  Vlasne
//
//  Created by Виталий Гоженко on 13/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extra)

+ (NSString *)className;
- (void)performSelectorOnMainThread:(SEL)aSelector withObject:(id)arg1 withObject:(id)arg2 waitUntilDone:(BOOL)wait;

@end
