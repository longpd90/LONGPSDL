//
//  NSArray+Extra.h
//  Vlasne
//
//  Created by Виталий Гоженко on 15/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extra)

- (NSArray *)arrayOfKey:(NSString *)key;
- (NSArray*)shuffledArray;
- (id)objectAtIndexOrNil:(NSUInteger)index;
- (id)randomObject;
- (NSArray *)randomSubarrayWithCapacity:(NSUInteger)capacity;

@end


@interface NSMutableArray (Extra)

- (void)shuffle;

@end
